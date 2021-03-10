import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:app_gastos/src/ui/screens/home_screen.dart';

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
    final error = Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Text('Error', style: TextStyle(color: Colors.red)),
    );

    final loading = Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Text('Loading...', style: TextStyle(color: Colors.blue)));

    return MaterialApp(
      title: 'App Gastos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _error
          ? error
          : !_initialized
              ? loading
              : HomeScreen(),
    );
  }
}
