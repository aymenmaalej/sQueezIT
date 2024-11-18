import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/theme.provider.dart';
import '../config/global.params.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: ListView(
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
          ...(GlobalParams.menus as List).map((item) {
            return Column(
              children: [
                ListTile(
                  title: Text(
                    '${item['title']}',
                    style: const TextStyle(fontSize: 22),
                  ),
                  leading: IconTheme(
                    data: const IconThemeData(color: Colors.black), // Set icon color to black
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
          }).toList(),
          const SizedBox(height: 400),
          ListTile(
            title: const Text('Dark Mode', style: TextStyle(fontSize: 22)),
            leading: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
              color: Colors.black, // Ensure the theme icon is also black
            ),
            trailing: Switch(
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
          ),
        ],
      ),
    );
  }
}
