import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_project/models/user_model.dart';
import 'package:my_project/repositories/auth_repository.dart';
import 'package:my_project/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthRepository _repository = AuthRepository();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Завантажуємо дані відразу при вході
  }

  // Читаємо дані користувача з пам'яті
  Future<void> _loadUserData() async {
    final user = await _repository.getUser();
    if (!mounted) return;
    setState(() {
      _user = user;
    });
  }

  // ФУНКЦІЯ ДІАЛОГУ ВИХОДУ (Вимога лаби)
  void _confirmLogout() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Вихід з акаунту'),
        content: const Text('Ви точно хочете вийти?'),
        actions: [
          // Кнопка "Ні"
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ні'),
          ),
          // Кнопка "Так"
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear(); // Повністю чистимо пам'ять (сесію)

              if (!mounted) return;
              
              if (mounted) {
                // ignore: use_build_context_synchronously
                final nav = Navigator.of(context);
                nav.pushNamedAndRemoveUntil(
                  '/',
                  (route) => false,
                );
              }
            },
            child: const Text(
              'Так, вийти',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мій Профіль')),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            
            // Виводимо ім'я
            Text(
              _user?.name ?? 'Завантаження...',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            
            // Виводимо пошту
            Text(
              _user?.email ?? 'Пошта не знайдена',
              style: const TextStyle(color: Colors.grey),
            ),
            
            const Spacer(),
            
            // Кнопка виходу, яка тепер викликає діалог
            CustomButton(
              title: 'Вийти з системи',
              onPressed: _confirmLogout,
            ),
          ],
        ),
      ),
    );
  }
}
