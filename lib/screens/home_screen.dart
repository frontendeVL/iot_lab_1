import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Змінна для збереження темної теми
  bool isDark = false;
  // Початкова назва нашого розумного будинку
  String homeName = 'Smart Home Hub';
  // Контролер для поля введення назви
  final TextEditingController _nameController = TextEditingController();

  // Функція для перемикання теми (світла/темна)
  void _changeTheme(String mode) {
    setState(() {
      if (mode == 'dark') isDark = true;
      if (mode == 'light') isDark = false;
    });
  }

  // Функція для зміни назви будинку в AppBar
  void _updateHomeName() {
    if (_nameController.text.isNotEmpty) {
      setState(() {
        homeName = _nameController.text;
      });
      // Очищаємо поле після того, як натиснули кнопку
      _nameController.clear();
    }
  }

  // Скидаємо назву до стандартної
  void _resetHomeName() {
    setState(() {
      homeName = 'Smart Home Hub';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Визначаємо колір фону залежно від обраної теми
    final bgColor = isDark ? Colors.grey[900] : Colors.grey[100];
    // Визначаємо колір тексту залежно від теми
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(homeName),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Поле для введення нової назви будинку
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Edit Home Name',
                hintText: 'Enter new name...',
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.white,
                border: const OutlineInputBorder(),
              ),
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 10),
            
            Row(
              children: [
                // Кнопка для збереження назви
                Expanded(
                  child: ElevatedButton(
                    onPressed: _updateHomeName,
                    child: const Text('Save Name'),
                  ),
                ),
                const SizedBox(width: 10),
                // Кнопка для повернення стандартної назви
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetHomeName,
                    child: const Text('Reset'),
                  ),
                ),
              ],
            ),
            
            const Divider(height: 40),
            
            // Кнопки для швидкої зміни теми
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _changeTheme('light'),
                  child: const Text('Light'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _changeTheme('dark'),
                  child: const Text('Dark'),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Список наших смарт-пристроїв
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                _buildDeviceCard('Living Room', Icons.lightbulb, true),
                _buildDeviceCard('Kitchen', Icons.kitchen, false),
                _buildDeviceCard('Bedroom', Icons.bed, true),
                _buildDeviceCard('Security', Icons.security, true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Окремий віджет для картки пристрою,зроблено через DecoratedBox для лінтера
  Widget _buildDeviceCard(String name, IconData icon, bool isOn) {
    // Колір картки залежить від того, чи увімкнений пристрій
    final cardColor = isOn 
        ? Colors.blueAccent 
        : (isDark ? Colors.grey[800] : Colors.white);
    
    // Колір тексту всередині картки
    final itemTextColor = isOn 
        ? Colors.white 
        : (isDark ? Colors.white : Colors.black);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon, 
            size: 40, 
            color: isOn ? Colors.white : Colors.grey,
          ),
          const SizedBox(height: 8),
          Text(
            name, 
            style: TextStyle(color: itemTextColor),
          ),
        ],
      ),
    );
  }
}
