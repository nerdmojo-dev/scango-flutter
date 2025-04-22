import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scango/services/secure_storage_service.dart';

class ApiClient {
  final SecureStorageService _secureStorage = SecureStorageService();
  final String _baseUrl = 'https://attendance-three-ivory.vercel.app/api';

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _secureStorage.getToken();
    print("🛠 Retrieved Token: $token");

    if (token == null || token.isEmpty) {
      throw Exception("No token found");
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String endpoint) async {
    final headers = await _getAuthHeaders();

    final response = await http.get(
      Uri.parse('$_baseUrl$endpoint'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("❌ Error ${response.statusCode}: ${response.body}"); // <-- Add this
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final headers = await _getAuthHeaders();

    final response = await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      // Handle unauthorized (token expired)
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to submit data');
    }
  }
}
