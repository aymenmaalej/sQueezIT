import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/music.config.dart';
import '../config/theme.provider.dart';
import '../config/global.params.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

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
          ListTile(
            title: const Text("Music", style: TextStyle(fontSize: 22)),
            leading: const Icon(Icons.music_note, color: Colors.black),
            trailing: Switch(
              value: BackgroundMusic.isPlaying(),
                onChanged: (value) async {
                  print("Switch toggled: $value");
                  if (value) {
                    await BackgroundMusic.playMusic();
                    print("Music started");
                  } else {
                    await BackgroundMusic.stopMusic();
                    print("Music stopped");
                  }
                  setState(() {});
                }
            ),
          ),
        ],
      ),
    );
  }
}
