import 'package:flutter/material.dart';
// Замінюємо відносні імпорти на пакетні (package:my_project/...)
import 'package:my_project/models/user_model.dart';
import 'package:my_project/repositories/auth_repository.dart';
import 'package:my_project/widgets/custom_button.dart';
import 'package:my_project/widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Контролери, щоб забирати текст, який вводить користувач
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  
  // Об'єкт репозиторію для збереження даних у пам'ять
  final repository = AuthRepository();

  // Основна функція для створення акаунту
  void signUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passController.text.trim();

    // 1. Перевірка на пусті поля
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError('Будь ласка, заповніть усі поля');
      return; 
    }

    // 2. Валідація пошти (шукаємо символ @)
    if (!email.contains('@')) {
      _showError('Некоректний імейл (має бути @)');
      return; 
    }

    // 3. Валідація довжини пароля
    if (password.length < 6) {
      _showError('Пароль занадто короткий (мін. 6 символів)');
      return; 
    }

    // Якщо все добре — створюємо модель користувача
    final newUser = UserModel(
      name: name,
      email: email,
      password: password,
    );

    // Викликаємо метод збереження (асинхронно)
    await repository.saveUser(newUser);

    // Лінтер просить перевіряти mounted перед Navigator.pop після await
    if (mounted) {
      Navigator.pop(context);
    }
  }

  // Функція для виведення повідомлення про помилку внизу екрана
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Поле для введення повного імені
              CustomTextField(
                label: 'Full Name', 
                controller: nameController,
              ),
              const SizedBox(height: 15),
              // Поле для введення електронної пошти
              CustomTextField(
                label: 'Email Address', 
                controller: emailController,
              ),
              const SizedBox(height: 15),
              // Поле для введення пароля
              CustomTextField(
                label: 'Password', 
                isPassword: true, 
                controller: passController,
              ),
              const SizedBox(height: 30),
              // Кнопка реєстрації
              CustomButton(
                title: 'Sign Up',
                onPressed: signUp, 
              ),
            ],
          ),
        ),
      ),
    );
  }
}
