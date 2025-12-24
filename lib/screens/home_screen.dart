import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:my_project/models/item.dart';
import 'package:my_project/repositories/data_repository.dart';

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
  final String _currentTemp = '--';

  // Змінні для роботи з API (Лаба 5)
  late Future<List<Item>> _itemsFuture;
  final DataRepository _repo = DataRepository();

  @override
  void initState() {
    super.initState();
    // Перевіряємо інтернет при завантаженні
    _checkInitialConnection();
    // Завантажуємо дані з API
    _itemsFuture = _repo.getItems();
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

  // Функція для оновлення даних з API (Лаба 5)
  void _refreshData() {
    setState(() {
      _itemsFuture = _repo.getItems();
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
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
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
            // Картка для відображення температури
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.orangeAccent.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Living Room Temp', 
                        style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Sensor Status', 
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

            const Divider(height: 40),

            // НОВИЙ БЛОК: Дані з API через FutureBuilder (Лаба 5)
            const Text(
              'API Data:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 300,
              child: FutureBuilder<List<Item>>(
                future: _itemsFuture,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return Center(
                      child: Text('Error: ${snap.error}'),
                    );
                  }
                  final items = snap.data ?? [];
                  if (items.isEmpty) {
                    return const Center(child: Text('No data'));
                  }
                  return ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (context, _) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final it = items[i];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blueAccent.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Colors.blueAccent.withValues(alpha: 0.3),
                              child: Text('${it.id}'),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                it.title,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
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
