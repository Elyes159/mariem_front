import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  static const String _isLoggedInKey = 'isLoggedIn'; // Use a clear constant

  bool _isLoggedIn = false; // Private variable for state

  AuthProvider({required bool isLoggedIn}) {
    _init(); // Initialize state on creation
  }

  bool get isLoggedIn => _isLoggedIn; // Public getter for state

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    notifyListeners(); // Notify listeners after updating state
  }

  Future<void> setLoggedIn(bool isLoggedIn) async {
    _isLoggedIn = isLoggedIn;
    notifyListeners(); // Notify listeners of change

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn); // Persist state
  }

  void login() {
    setLoggedIn(true); // Update state and notify listeners
  }

  void logout() {
    setLoggedIn(false); // Update state and notify listeners
  }
}
