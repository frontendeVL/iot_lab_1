import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_project/models/item.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Прості виклики АПІ без складної логіки
// Я використовую публічний JSONPlaceholder як мок-сервер
class ApiService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  // Читаю токен з локальної пам'яті (якщо ми його колись збережемо)
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Завантажую список елементів (наприклад, "posts")
  Future<List<Item>> fetchItems() async {
    final token = await _getToken();
    final uri = Uri.parse('$baseUrl/posts');
    final res = await http.get(uri, headers: {
      if (token != null) 'Authorization': 'Bearer $token',
    });

    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
      return data
          .take(10)
          .map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('API error: ${res.statusCode}');
  }
}
