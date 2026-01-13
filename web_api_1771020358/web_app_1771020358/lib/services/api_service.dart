import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiService {
  // Use 10.0.2.2 for Android Emulator, localhost for iOS/Web
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:3000/api';
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:3000/api';
    } catch (e) {
      // Platform check might fail on web, but kIsWeb handles it.
      // Fallback for other environments
    }
    return 'http://localhost:3000/api';
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('user', jsonEncode(data['user']));
      return data;
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Login failed');
    }
  }

  static Future<void> register({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
    String? address,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'full_name': fullName,
        'phone_number': phoneNumber,
        'address': address,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Registration failed',
      );
    }
  }

  static Future<List<dynamic>> getMenuItems() async {
    final token = await getToken();
    final response = await http.get(Uri.parse('$baseUrl/menu-items'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map && data.containsKey('menuItems')) {
        return data['menuItems'];
      } else if (data is List) {
        return data;
      }
      return [];
    } else {
      throw Exception('Failed to load menu items');
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
  }
}
