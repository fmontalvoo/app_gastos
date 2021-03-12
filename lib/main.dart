import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:app_gastos/src/ui/screens/home_screen.dart';
import 'package:app_gastos/src/ui/screens/add_expense_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) return _container('Error', Colors.red);

    if (!_initialized) return _container('Loading...', Colors.blue);

    return MaterialApp(
      title: 'App Gastos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => HomeScreen(),
        '/add': (context) => AddExpensePage(),
      },
    );
  }

  Widget _container(String title, Color color) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: Text(title,
          style: TextStyle(color: color), textDirection: TextDirection.ltr),
    );
  }
}
