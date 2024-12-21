import 'package:flutter/material.dart';

class UserHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Home Page"),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text('Welcome User', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
