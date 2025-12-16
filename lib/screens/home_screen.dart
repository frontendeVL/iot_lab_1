import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDark = false;
  final TextEditingController _controller = TextEditingController();

  void _changeTheme() {
    setState(() {
      final String input = _controller.text.toLowerCase().trim();
      if (input == 'dark') isDark = true;
      if (input == 'light') isDark = false;
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
      appBar: AppBar(
        title: const Text('Smart Home Hub'),
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
            Icon(
              isDark ? Icons.nightlight_round : Icons.wb_sunny,
              size: 80,
              color: isDark ? Colors.blueAccent : Colors.amber,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                labelText: 'Type "light" or "dark"',
                labelStyle: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _changeTheme,
              child: const Text('Change Light Mode'),
            ),
            const Divider(height: 40),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                _buildDeviceCard('Living Room', Icons.lightbulb, !isDark),
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

  Widget _buildDeviceCard(String name, IconData icon, bool isOn) {
    final color = isOn
        ? Colors.blueAccent
        : (isDark ? Colors.grey[800] : Colors.white);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
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
            style: TextStyle(
              color: isOn
                  ? Colors.white
                  : (isDark ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
