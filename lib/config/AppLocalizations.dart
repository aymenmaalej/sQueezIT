import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  static AppLocalizations? _current;

  static AppLocalizations get current {
    return _current!;
  }
/*
  static const AppLocalizationsDelegate delegate = AppLocalizationsDelegate();

  String get appTitle => Intl.message('sQueezIT', name: 'appTitle');
  String get quizTitle => Intl.message('Quiz', name: 'quizTitle');
  String get questionText => Intl.message('Question', name: 'questionText');
  String get submitAnswer => Intl.message('Submit Answer', name: 'submitAnswer');
  String get quizCompleted => Intl.message('Quiz Completed', name: 'quizCompleted');
  String get score => Intl.message('Your score is {score}/{total}', name: 'score');
  String get errorLoadingQuestions => Intl.message('An error occurred or no questions are available. Please try again.', name: 'errorLoadingQuestions');
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations.current = AppLocalizations();
    return AppLocalizations.current;
  }


  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
*/
}
