import 'package:flutter/material.dart';

class ControllerCodeProvider with ChangeNotifier {
  String _code = '';

  String get code => _code;

  void setCode(String value) {
    _code = value;
    notifyListeners();
  }
}
