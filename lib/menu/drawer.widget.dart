import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squeezit/config/languague.config.dart';
import '../config/music.config.dart';
import '../config/theme.provider.dart';
import '../config/global.params.dart'; 

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final BackgroundMusic _backgroundMusic = BackgroundMusic();
  bool isMusicPlaying = false;
  String? _selectedLanguage;
  final Map<String, String> _languageOptions = {
    'en': 'English',
    'fr': 'Français',
    'ar': 'العربية',
  };

  @override
  void initState() {
    super.initState();
    isMusicPlaying = _backgroundMusic.isMusicPlaying;
    LanguageConfig.getSavedLanguage().then((savedLanguage) {
      setState(() {
        _selectedLanguage = savedLanguage;
      });
    });
  }

  void _changeLanguage(String newLang) async {
    setState(() {
      _selectedLanguage = newLang;
    });

    await LanguageConfig.saveLanguage(newLang);
    Provider.of<LanguageNotifier>(context, listen: false).changeLanguage(newLang);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = FirebaseAuth.instance.currentUser;
    String email = user?.email ?? ""; 
    String username = email.split('@')[0].toUpperCase();

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.orangeAccent, Colors.deepOrange]),
            ),
            child: const Center(
              child: CircleAvatar(
                backgroundImage: AssetImage("images/nobglogo.png"),
                radius: 50,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text("Hello! ${username}", style: TextStyle(fontSize: 22)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: GlobalParams.menus.length,
              itemBuilder: (context, index) {
                final item = GlobalParams.menus[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        '${item['title']}',
                        style: const TextStyle(fontSize: 22),
                      ),
                      leading: IconTheme(
                        data: const IconThemeData(color: Colors.black),
                        child: item['icon'],
                      ),
                      trailing: const Icon(Icons.arrow_right, color: Colors.deepOrange),
                      onTap: () async {
                        if ('${item['title']}' != "Déconnexion") {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, "${item['route']}");
                        } else {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setBool("connecte", false);
                          Navigator.pushNamedAndRemoveUntil(context, '/authentification', (route) => false);
                        }
                      },
                    ),
                    const Divider(height: 4, color: Colors.deepOrange),
                  ],
                );
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.language , color: Colors.black),
            title: Text('Language', style: TextStyle(fontSize: 22)),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (String? newLang) {
                if (newLang != null) {
                  _changeLanguage(newLang);
                }
              },
              items: _languageOptions.entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: const Text('Dark Mode', style: TextStyle(fontSize: 22)),
            leading: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
              color: Colors.black,
            ),
            trailing: Switch(
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
          ),
          SwitchListTile(
            title: const Text("Music", style: TextStyle(fontSize: 22)),
            secondary: const Icon(Icons.music_note , color: Colors.black),
            value: isMusicPlaying,
            onChanged: (value) async {
              setState(() {
                isMusicPlaying = value;
              });
              if (isMusicPlaying) {
                await _backgroundMusic.playMusic('beat.mp3');
              } else {
                await _backgroundMusic.stopMusic();
              }
            },
          ),
        ],
      ),
    );
  }
}
