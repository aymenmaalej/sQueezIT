import 'package:flutter/material.dart';

class ClassementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classement Page'),
      ),
      body: Center(
        child: Text(
          'Classement will be here!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}