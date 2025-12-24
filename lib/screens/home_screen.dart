import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:my_project/models/item.dart';
import 'package:my_project/repositories/data_repository.dart';

// Головний екран: показує дані з АПІ через FutureBuilder
// Я залишила прості перемикачі теми та кнопку оновлення
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDark = false; // моє просте перемикання теми
  late Future<List<Item>> _itemsFuture; // майбутні дані з АПІ
  final DataRepository _repo = DataRepository();

  @override
  void initState() {
    super.initState();
    _itemsFuture = _repo.getItems();
    _checkInitialConnection(); // просто попереджаю, якщо офлайн
  }

  Future<void> _checkInitialConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (!mounted) return;
    if (connectivityResult.contains(ConnectivityResult.none)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Офлайн: показую з кешу, якщо є')),
      );
    }
  }

  void _refresh() {
    setState(() {
      _itemsFuture = _repo.getItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? Colors.grey[900] : Colors.grey[100];
    final txt = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Smart Home Hub'),
        actions: [
          IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh)),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Прості кнопки для перемикання теми
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => isDark = false),
                  child: const Text('Світла тема'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => setState(() => isDark = true),
                  child: const Text('Темна тема'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Основний блок: дані з АПІ через FutureBuilder
            Expanded(
              child: FutureBuilder<List<Item>>(
                future: _itemsFuture,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return Center(
                      child: Text('Помилка завантаження: ${snap.error}'),
                    );
                  }
                  final items = snap.data ?? [];
                  if (items.isEmpty) {
                    return const Center(
                      child: Text('Немає даних (можливо кеш порожній)'),
                    );
                  }
                  // Прості карточки з назвою елемента
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
                            color: Colors.orangeAccent.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.orangeAccent.withValues(
                                alpha: 0.3,
                              ),
                              child: Text('${it.id}'),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                it.title,
                                style: TextStyle(
                                  color: txt,
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
}
