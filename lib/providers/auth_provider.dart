import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  String? _username;
  bool _isLoading = false;

  String? get username => _username;
  bool get isLoading => _isLoading;

  final AuthService _authService;

  AuthProvider() : _authService = AuthService();

  Future<void> initialize() async {
    _username = await _authService.getCurrentUser();
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _authService.login(username, password);
      if (success) {
        _username = username;
      }
      return success;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String username, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _authService.register(username, email, password);
      if (success) {
        _username = username;
      }
      return success;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _username = null;
    notifyListeners();
  }
}
