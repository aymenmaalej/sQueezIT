import 'package:flutter/material.dart';
import 'package:squeezit/pages/parametres.page.dart';
import '../menu/drawer.widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text(
          'sQueezIT',
          style: TextStyle(color: Colors.orange),
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.deepOrange],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to sQueezIT!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black ,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "images/logo.jpeg",
                    height: 200,
                    width: 300,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, size: 100, color: Colors.red);
                    },
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ParametresPage()),
                    );
                  },
                  child: const Text('Start Quiz' , style: TextStyle(color: Colors.orange)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'sQueezIT',
                      applicationVersion: '1.0.0',
                      children: const [
                        Text(
                          'sQueezIT is a quiz application developped by Aymen Maalej for the end of semestre evalutaion. \n  '
                              'Questions are provided by the Open Trivia Database.',
                        ),
                      ],
                    );
                  },
                  child: const Text('About', style: TextStyle(color: Colors.orange)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
