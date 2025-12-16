import 'package:flutter/material.dart';
import 'package:my_project/widgets/custom_button.dart';
import 'package:my_project/widgets/custom_textfield.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration')),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const CustomTextField(label: 'Full Name'),
            const SizedBox(height: 15),
            const CustomTextField(label: 'Email'),
            const SizedBox(height: 15),
            const CustomTextField(label: 'Password', isPassword: true),
            const SizedBox(height: 30),
            CustomButton(
              title: 'Sign Up',
              onPressed: () => Navigator.pushNamed(context, '/'),
            ),
          ],
        ),
      ),
    );
  }
}
