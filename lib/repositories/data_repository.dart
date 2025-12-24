import 'dart:convert';

import 'package:my_project/models/item.dart';
import 'package:my_project/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Репозиторій: пробуємо онлайн, інакше віддаємо кеш
class DataRepository {
  final ApiService _api = ApiService();

  // Ключ для кешу у SharedPreferences
  static const String cacheKey = 'cached_items';

  // Головний метод: отримати список елементів
  Future<List<Item>> getItems() async {
    try {
      final online = await _api.fetchItems();
      await _saveCache(online);
      return online;
    } catch (_) {
      // Якщо сервер недоступний — повертаю те, що збережене локально
      final cached = await _readCache();
      return cached;
    }
  }

  // Зберігаю кеш у вигляді JSON рядка
  Future<void> _saveCache(List<Item> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(cacheKey, jsonStr);
  }

  // Читаю кеш і перетворюю на список моделей
  Future<List<Item>> _readCache() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(cacheKey);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    final List<dynamic> data = jsonDecode(jsonStr) as List<dynamic>;
    return data.map((e) => Item.fromJson(e as Map<String, dynamic>)).toList();
  }
}
