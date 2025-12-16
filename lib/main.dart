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
  // Змінна для керування станом теми
  ThemeMode _currentTheme = ThemeMode.light;

  // Контролер для зчитування тексту
  final TextEditingController _controller = TextEditingController();

  // Функція для зміни теми
  void _changeTheme() {
    setState(() {
      final String input = _controller.text.toLowerCase().trim();
      if (input == 'dark') {
        _currentTheme = ThemeMode.dark;
      } else if (input == 'light') {
        _currentTheme = ThemeMode.light;
      }
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLight = _currentTheme == ThemeMode.light;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _currentTheme,
      home: Scaffold(
        appBar: AppBar(title: const Text('IoT Light Control')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isLight ? Icons.wb_sunny : Icons.nightlight_round,
                size: 100,
                color: isLight ? Colors.orange : Colors.blueAccent,
              ),
              const SizedBox(height: 20),
              Text(
                'Current Mode: ${isLight ? 'Light' : 'Dark'}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter "light" or "dark"',
                  hintText: 'Type mode here...',
                ),
              ),
              const SizedBox(height: 20),
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
