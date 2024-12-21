import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
        backgroundColor: const Color.fromARGB(255, 150, 0, 117),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to your account!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/signin');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 150, 0, 117),
              ),
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
