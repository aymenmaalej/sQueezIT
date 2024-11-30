import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ParametresPage extends StatefulWidget {
  @override
  _ParametresPageState createState() => _ParametresPageState();
}

class _ParametresPageState extends State<ParametresPage> {
  List<dynamic> categories = [];
  String? selectedCategory;
  String? selectedDifficulty;
  int? numberOfQuestions;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    const url = "https://opentdb.com/api_category.php";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          categories = json.decode(response.body)['trivia_categories'];
        });
      } else {
        throw Exception("Failed to load categories");
      }
    } catch (error) {
      print("Error fetching categories: $error");
    }
  }

  void _startQuiz() {
    if (selectedCategory != null && selectedDifficulty != null && numberOfQuestions != null) {
      Navigator.pushNamed(
        context,
        '/quiz',
        arguments: {
          'category': selectedCategory,
          'difficulty': selectedDifficulty,
          'numberOfQuestions': numberOfQuestions,
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select all parameters")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Settings" , style: TextStyle(color: Colors.orange)),
      ),
      body: categories.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Category",
                labelStyle: TextStyle(
                  color: Colors.orange,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange, 
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange,
                    width: 2.0,
                  ),
                ),
              ),
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category['id'].toString(),
                  child: Text(category['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Difficulty",
                labelStyle: TextStyle(
                  color: Colors.orange, 
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange, 
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange, 
                    width: 2.0,  
                  ),
                ),
              ),
              items: [
                DropdownMenuItem(value: "easy", child: Text("Easy")),
                DropdownMenuItem(value: "medium", child: Text("Medium")),
                DropdownMenuItem(value: "hard", child: Text("Hard")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedDifficulty = value;
                });
              },
            ),
            SizedBox(height: 20),
            const Text(
              "Number Of Questions",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold , color: Colors.orange
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [5, 10, 15, 20].map((value) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<int>(
                      value: value,
                      groupValue: numberOfQuestions,
                      activeColor: Colors.orange,
                      onChanged: (newValue) {
                        setState(() {
                          numberOfQuestions = newValue;
                        });
                      },
                    ),
                    Text("$value"),
                  ],
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _startQuiz,
              child: Text("Start Quiz" , style: TextStyle(color: Colors.orange),
            ),
            )],
        ),
      ),
    );
  }
}
