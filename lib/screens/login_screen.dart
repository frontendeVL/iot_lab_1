import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:my_project/repositories/auth_repository.dart';
import 'package:my_project/widgets/custom_button.dart';
import 'package:my_project/widgets/custom_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final repository = AuthRepository();

  // ГОЛОВНА ФУНКЦІЯ ЛОГІНУ
  void login() async {
    // 1. ПЕРЕВІРКА ІНТЕРНЕТУ (Вимога лаби)
    final connectivityResult = await Connectivity().checkConnectivity();
    
    // Якщо в списку результатів є "none" — значить інету немає
    if (connectivityResult.contains(ConnectivityResult.none)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Помилка: Немає підключення до інтернету!'),
          backgroundColor: Colors.orange,
        ),
      );
      return; // Зупиняємо функцію, далі код не піде
    }

    // 2. ЛОГІКА ПЕРЕВІРКИ ДАНИХ
    final savedUser = await repository.getUser();
    final inputEmail = emailController.text.trim();
    final inputPass = passController.text.trim();

    if (!mounted) return;

    // Перевіряємо чи співпадають введені дані з тими, що в пам'яті
    if (savedUser != null &&
        savedUser.email == inputEmail &&
        savedUser.password == inputPass) {
      // Зберігаю простий токен (опція з вимог)
      final prefs = await SharedPreferences.getInstance();
      final tokenValue = 'fake_token_${DateTime.now().millisecondsSinceEpoch}';
      await prefs.setString('token', tokenValue);

      if (!mounted) return;
      // Якщо все ок — йдемо додому
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Якщо помилка — показуємо червоне повідомлення
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Невірний імейл або пароль!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 30),
            
            CustomTextField(label: 'Email', controller: emailController),
            const SizedBox(height: 15),
            
            CustomTextField(
              label: 'Password',
              isPassword: true,
              controller: passController,
            ),
            
            const SizedBox(height: 30),
            
            CustomButton(title: 'Login', onPressed: login),
            
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('Don\'t have an account? Register'),
            ),
          ],
        ),
      ),
    );
  }
}
