// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scango/services/secure_storage_service.dart';

class AuthService {
  final SecureStorageService _secureStorage = SecureStorageService();
  final String _baseUrl = 'https://attendance-three-ivory.vercel.app/api';

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        // Store the token securely
        await _secureStorage.storeToken(token);
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _secureStorage.deleteToken();
  }

  Future<bool> isLoggedIn() async {
    return await _secureStorage.hasToken();
  }
}
