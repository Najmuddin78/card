
import 'package:card/screens/navigation_screen.dart';
import 'package:card/screens/welcome_screen.dart';
import 'package:card/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isLoggedIn = prefs.getBool('isLoggedIn');

  runApp(MyApp(isLoggedIn: isLoggedIn ?? false));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: isLoggedIn ? const NavigationScreen() : const WelcomeScreen(),
    );
  }
}
