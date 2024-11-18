import 'package:flutter/material.dart';

class GlobalParams {
  static List<Map<String, dynamic>> menus = [
    {"title": "Accueil", "icon": Icon(Icons.home, color: Colors.black), "route": "/home"},
    {"title": "Classement", "icon": Icon(Icons.leaderboard, color: Colors.black), "route": "/classement"},
    {"title": "Déconnexion", "icon": Icon(Icons.logout, color: Colors.black), "route": "/authentification"},
  ];
}
