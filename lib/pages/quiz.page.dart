import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
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
        final data = json.decode(response.body);
        if (data['results'].isNotEmpty) {
          setState(() {
            questions = data['results'];
            isLoading = false;
          });
        } else {
          throw Exception("No questions available");
        }
      } else {
        throw Exception("Failed to load questions");
      }
    } catch (error) {
      setState(() {
        hasError = true;
      });
      print("Error fetching questions: $error");
    }
  }

  void _answerQuestion(String selectedAnswer) {
    final correctAnswer = questions[currentQuestionIndex]['correct_answer'];
    if (selectedAnswer == correctAnswer) {
      setState(() {
        score++;
      });
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        this.selectedAnswer = null;
      });
    } else {
      _showFinalScore();
    }
  }

  void _showFinalScore() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
    final allAnswers = [...question['incorrect_answers'], question['correct_answer']];
    allAnswers.shuffle();

    return Scaffold(
      appBar: AppBar(
        title: Text("Question ${currentQuestionIndex + 1}/${questions.length}"),
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
            SizedBox(height: 20),
            ...allAnswers.map((answer) {
              return ListTile(
                title: Text(answer),
                leading: Radio<String>(
                  value: answer,
                  groupValue: selectedAnswer,
                  onChanged: (value) {
                    setState(() {
                      selectedAnswer = value;
                    });
                  },
                ),
              );
            }).toList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedAnswer != null
                  ? () => _answerQuestion(selectedAnswer!)
                  : null,
              child: Text("Submit Answer"),
            ),
          ],
        ),
      ),
    );
  }
}
