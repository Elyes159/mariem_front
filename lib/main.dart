import 'package:flutter/material.dart';
import 'package:projet_pfe/homepage.dart';
import 'package:projet_pfe/login.dart';
import 'package:projet_pfe/provider/code_provider.dart';
import 'package:projet_pfe/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance(); // Wait for initialization

  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  print("$token");

  runApp(
    ChangeNotifierProvider(
        create: (context) => ControllerCodeProvider(),
        child: MyApp(
          isLoggedIn: token != null,
          initialLoggedIn: false,
        )),
  );
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;

  final bool initialLoggedIn = false; // Corrected name

  const MyApp(
      {Key? key, required this.isLoggedIn, required bool initialLoggedIn})
      : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false; // Internal state for login status

  @override
  void initState() {
    super.initState();
    _isLoggedIn = widget.initialLoggedIn; // Use initial value
    _checkToken(); // Start asynchronous token check
  }

  Future<void> _checkToken() async {
    final prefs =
        await SharedPreferences.getInstance(); // Get prefs inside the function
    final String? token = prefs.getString('token');
    setState(() {
      _isLoggedIn = token != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(isLoggedIn: _isLoggedIn),
      child: MaterialApp(
        home: _isLoggedIn ? Homepage() : Login(),
      ),
    );
  }
}
