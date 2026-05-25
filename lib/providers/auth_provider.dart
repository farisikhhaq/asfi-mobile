import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/buyer.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  Buyer? _user;
  String? _token;
  bool _isLoading = false;

  Buyer? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  AuthProvider() {
    _loadSession();
  }

  Future<void> _loadSession() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final userDataString = prefs.getString('user_data');

    if (_token != null && userDataString != null) {
      try {
        _user = Buyer.fromJson(jsonDecode(userDataString));
        // Verify from server asynchronously
        final freshUser = await ApiService.getMe();
        if (freshUser != null) {
          _user = freshUser;
          await prefs.setString('user_data', jsonEncode(freshUser.toJson()));
        } else {
          // Token is expired
          await logout();
        }
      } catch (e) {
        print('Session load error: $e');
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await ApiService.login(email, password);
    if (result['success']) {
      _user = result['user'] as Buyer;
      _token = result['token'] as String;
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<Map<String, dynamic>> register(String name, String email, String password, String passwordConfirmation) async {
    _isLoading = true;
    notifyListeners();

    final result = await ApiService.register(name, email, password, passwordConfirmation);
    if (result['success']) {
      _user = result['user'] as Buyer;
      _token = result['token'] as String;
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await ApiService.logout();
    _user = null;
    _token = null;

    _isLoading = false;
    notifyListeners();
  }
}
