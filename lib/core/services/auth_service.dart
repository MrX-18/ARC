import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/auth_models.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _authBoxName = 'arc_auth_session_box';
  static const String _userKey = 'current_auth_user';

  late Box _authBox;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      await Hive.initFlutter();
      _authBox = await Hive.openBox(_authBoxName);
      _initialized = true;
    } catch (e) {
      debugPrint('AuthService init error: $e');
    }
  }

  AuthUser? getCurrentUser() {
    if (!_initialized) return null;
    final data = _authBox.get(_userKey);
    if (data == null) return null;
    try {
      return AuthUser.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      debugPrint('Error loading auth user: $e');
      return null;
    }
  }

  Future<AuthUser> signInWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate API call

    if (email.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('Email and password cannot be empty.');
    }

    final user = AuthUser(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      email: email.trim(),
      displayName: email.split('@').first.toUpperCase(),
      token: 'jwt_token_${DateTime.now().millisecondsSinceEpoch}',
      isGuest: false,
      createdAt: DateTime.now(),
    );

    await _authBox.put(_userKey, user.toMap());
    return user;
  }

  Future<AuthUser> signUpWithEmail(String email, String password, String name) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate API call

    if (email.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('Email and password cannot be empty.');
    }

    final user = AuthUser(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      email: email.trim(),
      displayName: name.trim().isNotEmpty ? name.trim() : email.split('@').first,
      token: 'jwt_token_${DateTime.now().millisecondsSinceEpoch}',
      isGuest: false,
      createdAt: DateTime.now(),
    );

    await _authBox.put(_userKey, user.toMap());
    return user;
  }

  Future<AuthUser> signInAsGuest() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final guest = AuthUser.createGuest();
    await _authBox.put(_userKey, guest.toMap());
    return guest;
  }

  Future<void> signOut() async {
    await _authBox.delete(_userKey);
  }
}
