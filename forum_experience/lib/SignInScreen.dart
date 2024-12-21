import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forum_experience/AdminHomePage.dart';
import 'package:forum_experience/post_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'SignUpScreen.dart';

class SignInScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signIn(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome back, ${userCredential.user?.email}!')),
        );
        // Rediriger après connexion réussie
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminHomePage()), 
      );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign in: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      // Initialiser le processus de connexion avec Google
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // L'utilisateur a annulé la connexion

      // Obtenir les informations d'authentification de Google
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Créer un objet d'identification pour Firebase
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Connexion à Firebase avec les informations d'identification de Google
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Rediriger vers MyAccountScreen après une connexion réussie
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signed in as ${userCredential.user?.email}')),
      );
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => MyAccountScreen()),
      // );
    } catch (e) {
      // Gérer les erreurs de connexion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with Google: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        backgroundColor: const Color.fromARGB(255, 150, 0, 117),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 40),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 120,
                ),
              ),
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 150, 0, 137),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Please sign in to your account',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () => _signIn(context),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: const Color.fromARGB(255, 150, 0, 117),
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => _signInWithGoogle(context),
                      icon: Image.asset(
                        'assets/images/google_logo.png',
                        height: 24,
                      ),
                      label: Text('Sign In with Google'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpScreen()),
                        );
                      },
                      child: Text(
                        "Don't have an account? Sign Up",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
