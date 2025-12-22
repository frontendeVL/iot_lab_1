import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_project/screens/home_screen.dart';
import 'package:my_project/screens/login_screen.dart';
import 'package:my_project/screens/profile_screen.dart';
import 'package:my_project/screens/register_screen.dart';

void main() async {
  // Це обов'язково для async main
  WidgetsFlutterBinding.ensureInitialized();
  
  // Перевіряємо, чи є збережений email (сесія)
  final prefs = await SharedPreferences.getInstance();
  final String? userEmail = prefs.getString('email');

  runApp(SmartHomeApp(
    // Якщо email знайдено — стартуємо з дому, якщо ні — з логіну
    initialRoute: userEmail != null ? '/home' : '/',
  ));
}

class SmartHomeApp extends StatelessWidget {
  final String initialRoute;
  
  const SmartHomeApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Home Hub',
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
