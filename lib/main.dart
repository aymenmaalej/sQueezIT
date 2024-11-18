import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squeezit/pages/authentification.page.dart';
import 'package:squeezit/pages/classement.page.dart';
import 'package:squeezit/pages/home.page.dart';
import 'package:squeezit/pages/inscription.page.dart';
import 'package:squeezit/pages/parametres.page.dart';
import 'package:squeezit/pages/quiz.page.dart';
import 'config/theme.provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider()..loadTheme(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final routes = {
    '/home': (context) => HomePage(),
    '/inscription': (context) => InscriptionPage(),
    '/authentification': (context) => AuthentificationPage(),
    '/parametres': (context) => ParametresPage(),
    '/quiz': (context) => QuizPage(parameters: {},),
    '/classement' : (context)=> ClassementPage() ,
  };

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
      initialRoute: '/authentification',
      routes: routes,
    );
  }
}
