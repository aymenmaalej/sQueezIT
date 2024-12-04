import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parseFragment;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class QuizPage extends StatefulWidget {
  final Map<String, dynamic> parameters;

  const QuizPage({required this.parameters});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<dynamic> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool isLoading = true;
  bool hasError = false;
  String? selectedAnswer;
  bool showAnswerFeedback = false;
  bool isCorrectAnswer = false;
  int remainingTime = 30;
  Timer? questionTimer;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _fetchQuestions();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _fetchQuestions() async {
    final baseUrl = "https://opentdb.com/api.php";
    final amount = widget.parameters['numberOfQuestions'];
    final category = widget.parameters['category'];
    final difficulty = widget.parameters['difficulty'];

    final url =
        "$baseUrl?amount=$amount&category=$category&difficulty=$difficulty&type=multiple";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final results = json.decode(utf8.decode(response.bodyBytes))['results'];
        setState(() {
          questions = results.map((question) {
            question['question'] = parseFragment(question['question']).text;
            question['correct_answer'] =
                parseFragment(question['correct_answer']).text;
            question['incorrect_answers'] =
                (question['incorrect_answers'] as List)
                    .map((answer) => parseFragment(answer).text)
                    .toList();
            question['shuffled_answers'] = [
              ...question['incorrect_answers'],
              question['correct_answer']
            ]
              ..shuffle();
            return question;
          }).toList();
          isLoading = false;
          hasError = questions.isEmpty;
          _startTimer();
        });
      } else {
        _handleError(
            "Failed to load questions. Status code: ${response.statusCode}");
      }
    } catch (error) {
      _handleError("Error fetching questions: $error");
    }
  }

  void _handleError(String message) {
    setState(() {
      hasError = true;
      isLoading = false;
    });
    print(message);
  }

  void _answerQuestion(String selectedAnswer) {
    final correctAnswer = questions[currentQuestionIndex]['correct_answer'];
    isCorrectAnswer = (selectedAnswer == correctAnswer);
    setState(() {
      showAnswerFeedback = true;
      if (isCorrectAnswer) {
        score++;
      }
    });

    Future.delayed(Duration(seconds: 1), () {
      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          this.selectedAnswer = null;
          showAnswerFeedback = false;
        });
        _startTimer();
      } else {
        _showFinalScore();
      }
    });
  }

  void _showFinalScore() {
    questionTimer?.cancel();

    final user = FirebaseAuth.instance.currentUser;
    String email = user?.email ?? "";
    String username = email.split('@')[0].toUpperCase();
    updateUserScore(username, score);

    showLeaderboardNotification();

    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text("Quiz Completed"),
            content: Text("Your score is $score/${questions.length}."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          ),
    );
  }

  Future<void> updateUserScore(String username, int score) async {
    final leaderboardRef = FirebaseFirestore.instance.collection('leaderboard')
        .doc(username);

    try {
      final doc = await leaderboardRef.get();
      if (doc.exists) {
        await leaderboardRef.update({
          'totalScore': FieldValue.increment(score),
        });
      } else {
        await leaderboardRef.set({
          'username': username,
          'totalScore': score,
        });
      }
    } catch (e) {
      print("Error updating leaderboard: $e");
    }
  }

  Future<void> showLeaderboardNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'leaderboard_channel',
      'Leaderboard Notifications',
      channelDescription: 'Notifications to check the leaderboard',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Quiz Completed!',
      'Check the leaderboard to see your ranking.',
      platformChannelSpecifics,
    );
  }

  void _startTimer() {
    questionTimer?.cancel();
    setState(() {
      remainingTime = 30;
    });

    questionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          timer.cancel();
          _answerQuestion(
              ""); // Automatically move to next question if time runs out
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Quiz")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (hasError || questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Quiz")),
        body: Center(
          child: Text(
            "An error occurred or no questions are available. Please try again.",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final question = questions[currentQuestionIndex];
    final allAnswers = question['shuffled_answers'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Question ${currentQuestionIndex + 1}/${questions.length}",
          style: TextStyle(color: Colors.orange),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question['question'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Time Remaining: $remainingTime seconds",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            SizedBox(height: 20),
            ...allAnswers.map((answer) {
              return ListTile(
                title: Text(answer),
                tileColor: showAnswerFeedback
                    ? (answer ==
                    questions[currentQuestionIndex]['correct_answer']
                    ? Colors.green.withOpacity(0.2)
                    : (answer == selectedAnswer
                    ? Colors.red.withOpacity(0.2)
                    : null))
                    : null,
                leading: Radio<String>(
                  value: answer,
                  groupValue: selectedAnswer,
                  activeColor: Colors.orange,
                  onChanged: showAnswerFeedback ? null : (value) {
                    setState(() {
                      selectedAnswer = value;
                    });
                  },
                ),
              );
            }).toList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedAnswer != null && !showAnswerFeedback
                  ? () => _answerQuestion(selectedAnswer!)
                  : null,
              child: Text(
                  "Submit Answer", style: TextStyle(color: Colors.orange)),
            ),
          ],
        ),
      ),
    );
  }
}