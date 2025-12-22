import 'package:flutter/material.dart';
// Використовуємо правильні пакетні імпорти для лінтера
import 'package:my_project/models/user_model.dart';
import 'package:my_project/repositories/auth_repository.dart';
import 'package:my_project/widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Створюємо екземпляр репозиторію для роботи з пам'яттю
  final AuthRepository _repository = AuthRepository();
  // Сюди ми запишемо дані користувача, коли вони завантажаться
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    // Викликаємо завантаження даних відразу при створенні екрана
    _loadUserData();
  }

  // Спеціальна функція для читання даних із SharedPreferences
  Future<void> _loadUserData() async {
    final user = await _repository.getUser();
    
    // Перевіряємо, чи екран ще відкритий (вимога лінтера для асинхронності)
    if (!mounted) return;

    setState(() {
      // Оновлюємо стан екрана отриманими даними
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            // Аватарка користувача
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            
            // Виводимо ім'я користувача (або Loading, поки дані вантажаться)
            Text(
              _user?.name ?? 'Loading...', 
              style: const TextStyle(
                fontSize: 22, 
                fontWeight: FontWeight.bold,
              ),
            ),
            
            // Виводимо електронну пошту
            Text(
              _user?.email ?? 'No email found',
              style: const TextStyle(color: Colors.grey),
            ),
            
            const Spacer(),
            
            // Кнопка для виходу з акаунту
            CustomButton(
              title: 'Logout',
              onPressed: () {
                // Повертаємо користувача на екран логіну та очищуємо 
                //історію переходів
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
