import 'package:flutter/material.dart';
import 'package:my_project/repositories/auth_repository.dart';
import 'package:my_project/widgets/custom_button.dart';
import 'package:my_project/widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final repository = AuthRepository();

  void login() async {
    final savedUser = await repository.getUser();
    final inputEmail = emailController.text.trim();
    final inputPass = passController.text.trim();

    if (!mounted) return;

    if (savedUser != null && 
        savedUser.email == inputEmail && 
        savedUser.password == inputPass) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
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
