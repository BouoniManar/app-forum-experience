import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:forum_experience/post_page.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forum de partage d\'experience',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 243, 33, 191),
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 243, 33, 191),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color.fromARGB(255, 243, 33, 191),
          secondary: Color.fromARGB(255, 255, 182, 193),
        ),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: SplashScreen(), // Affiche le SplashScreen au démarrage
    );
  }
}
