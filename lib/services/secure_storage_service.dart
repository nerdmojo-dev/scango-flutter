import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';

  // Save token after successful login
  Future<void> storeToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Get token for authenticated requests
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Delete token on logout
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // Check if user is logged in
  Future<bool> hasToken() async {
    String? token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
