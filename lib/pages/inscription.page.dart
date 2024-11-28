import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InscriptionPage extends StatelessWidget {
  late SharedPreferences prefs;
  TextEditingController txt_login = new TextEditingController();
  TextEditingController txt_password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Page Inscription')),
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
                  _onInscrire(context);
                },
                child: Text('Inscription', style: TextStyle(fontSize: 22, color: Colors.orange),),
              ),
            ),
            TextButton(
                child : Text("J'ai deja un compte" , style: TextStyle(fontSize: 22, color: Colors.orange)),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/authentification');
                }
            )
          ],
        )
    );
  }
  Future<void> _onInscrire(BuildContext context) async{
    if(!txt_login.text.isEmpty && !txt_password.text.isEmpty){
      try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: txt_login.text.trim(), password: txt_password.text.trim());
        Navigator.pop(context);
        Navigator.pushNamed(context, "/home");
      } on FirebaseAuthException catch(e){
        SnackBar snackBar = SnackBar(content: Text(""));
        if(e.code == 'weak-password'){
          snackBar = SnackBar(content: Text("Mot de passe faible"),);
        }
        else if (e.code == 'email-already-in-use'){
          snackBar = SnackBar(content: Text("Email dèjà existant"),);
        }
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    else{
      const snackBar = SnackBar(content: Text("Id ou mot de passe vides"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

