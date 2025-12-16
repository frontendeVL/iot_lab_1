import 'package:flutter/material.dart';
import 'package:my_project/widgets/custom_button.dart';
import 'package:my_project/widgets/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.home_repair_service,
              size: 80,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 30),
            const CustomTextField(label: 'Email'),
            const SizedBox(height: 15),
            const CustomTextField(label: 'Password', isPassword: true),
            const SizedBox(height: 30),
            CustomButton(
              title: 'Login',
              onPressed: () => Navigator.pushNamed(context, '/home'),
            ),
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
