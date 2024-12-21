// lib/core/splash_screen/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'SignUpScreen.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(Duration(seconds: 6));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/animation.json',
          width: 200,
          height: 200,
          fit: BoxFit.cover,
          repeat: true,
        ),
      ),
    );
  }
}
