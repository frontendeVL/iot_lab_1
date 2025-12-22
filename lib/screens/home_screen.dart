import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:my_project/services/mqtt_service.dart';

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

  // Нові змінні для роботи з датчиком температури
  String _currentTemp = '--';
  final MqttService _mqttService = MqttService();

  @override
  void initState() {
    super.initState();
    // Перевіряємо інтернет та налаштовуємо отримання даних з MQTT
    _checkInitialConnection();
    _setupMqtt();
  }

  // Функція для підключення до MQTT та оновлення температури
  void _setupMqtt() async {
    await _mqttService.connect((temp) {
      if (!mounted) return;
      setState(() {
        _currentTemp = temp; 
      });
    });
  }

  // Перевіряємо чи є інтернет при завантаженні головного екрана
  Future<void> _checkInitialConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (!mounted) return;
    
    // ignore: iterable_contains_unrelated_type
    if (connectivityResult.contains(ConnectivityResult.none)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Увага: Немає підключення до мережі!')),
      );
    }
  }

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
            // Картка для відображення температури в реальному часі через MQTT
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orangeAccent.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Living Room Temp', 
                        style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('MQTT Sensor Live', 
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  Text(
                    '$_currentTemp°C', 
                    style: const TextStyle(
                      fontSize: 30, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.orange),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

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
