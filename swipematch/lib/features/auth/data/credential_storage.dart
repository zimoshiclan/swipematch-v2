import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CredentialStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const _keyEmail = 'saved_email';
  static const _keyPassword = 'saved_password';

  Future<void> save({required String email, required String password}) async {
    await Future.wait([
      _storage.write(key: _keyEmail, value: email),
      _storage.write(key: _keyPassword, value: password),
    ]);
  }

  Future<({String email, String password})?> load() async {
    final email = await _storage.read(key: _keyEmail);
    final password = await _storage.read(key: _keyPassword);
    if (email == null || password == null) return null;
    return (email: email, password: password);
  }

  Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: _keyEmail),
      _storage.delete(key: _keyPassword),
    ]);
  }
}
