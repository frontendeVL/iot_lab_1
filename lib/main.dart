import 'package:flutter/material.dart';

void main() {
  runApp(const SmartLightingApp());
}

class SmartLightingApp extends StatefulWidget {
  const SmartLightingApp({super.key});

  @override
  State<SmartLightingApp> createState() => _SmartLightingAppState();
}

class _SmartLightingAppState extends State<SmartLightingApp> {
  // Змінна для керування станом теми (Light/Dark)
  ThemeMode _currentTheme = ThemeMode.light;
  
  // Контролер для зчитування тексту з поля вводу
  final TextEditingController _controller = TextEditingController();

  // Функція для зміни теми на основі введеного тексту
  void _changeTheme() {
    setState(() {
      String input = _controller.text.toLowerCase().trim();
      if (input == "dark") {
        _currentTheme = ThemeMode.dark;
      } else if (input == "light") {
        _currentTheme = ThemeMode.light;
      }
      _controller.clear(); // Очищуємо поле після натискання кнопки
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Налаштування тем: світла та темна
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _currentTheme, 
      
      home: Scaffold(
        appBar: AppBar(title: const Text('IoT Light Control')),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Іконка, яка змінюється залежно від теми
              Icon(
                _currentTheme == ThemeMode.light ? Icons.wb_sunny : Icons.nightlight_round,
                size: 100,
                color: _currentTheme == ThemeMode.light ? Colors.orange : Colors.blueAccent,
              ),
              const SizedBox(height: 20),
              // Текст з поточним статусом
              Text(
                'Current Mode: ${_currentTheme == ThemeMode.light ? "Light" : "Dark"}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              // Поле вводу для користувача
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter "light" or "dark"',
                  hintText: 'Type mode here...',
                ),
              ),
              const SizedBox(height: 20),
              // Кнопка для застосування змін
              ElevatedButton(
                onPressed: _changeTheme,
                child: const Text('Apply Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}