import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _key = "jwt";

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await storage.write(key: _key, value: token);
  }

  Future<String?> getToken() async {
    return storage.read(key: _key);
  }

  Future<void> clearToken() async {
    await storage.delete(key: _key);
  }

  Future<void> deleteToken() async {
    await storage.delete(key: _key);
  }
}
