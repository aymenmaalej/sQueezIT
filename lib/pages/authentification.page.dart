import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthentificationPage extends StatelessWidget {
  late SharedPreferences prefs;
  TextEditingController txt_login = new TextEditingController();
  TextEditingController txt_password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'sQueezIT',
            style: TextStyle(color: Colors.orange),
          ),
        ),

        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: txt_login,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: "Utilisateur",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: txt_password,
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.password),
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: (){
                  _onAuthentifier(context);
                },
                child: Text('Login', style: TextStyle(fontSize: 22 , color: Colors.orange),),
              ),
            ),
            TextButton(
                child : Text("New User" , style: TextStyle(fontSize: 22 , color: Colors.orange)),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/inscription');
                }
            ),
            TextButton(
                child : Text("Continue as a Guest" , style: TextStyle(fontSize: 22 , color: Colors.orange)),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/home');
                }
            ),
          ],
        )
    );
  }
  Future<void> _onAuthentifier(BuildContext context) async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: txt_login.text.trim(), password: txt_password.text.trim());
      Navigator.pop(context);
      Navigator.pushNamed(context, "/home");
    } on FirebaseAuthException catch (e){
      SnackBar snackBar = SnackBar(content: Text(""));
      if(e.code == 'user-not-found'){
        snackBar = SnackBar(content: Text("Utilisateur inextistant"));
      }
      else if(e.code == 'wrong-password'){
        snackBar = SnackBar(content: Text("Verifier votre mot de passe"));
      }
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
