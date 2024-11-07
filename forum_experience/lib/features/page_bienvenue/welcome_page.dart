// lib/features/welcome_page/welcome_page.dart
import 'package:flutter/material.dart';
import 'signin_page.dart';
import 'signup_page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenue - Partage d'expérience"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Découvre les avis et expériences des utilisateurs",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
            },
            child: Text("Se connecter"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage()),
              );
            },
            child: Text("Créer un compte"),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text("Produit X"),
                  subtitle: Text("Très bon produit, je recommande !"),
                ),
                ListTile(
                  title: Text("Produit Y"),
                  subtitle: Text("Un peu déçu, pas à la hauteur de mes attentes."),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
