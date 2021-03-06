import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:app_gastos/src/ui/screens/home_screen.dart';
import 'package:app_gastos/src/ui/screens/login_screen.dart';
import 'package:app_gastos/src/ui/screens/details_screen.dart';

import 'package:app_gastos/src/utils/login_state.dart';

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
    super.initState();
    initializeFlutterFire();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) return _container('Error', Colors.red);

    if (!_initialized) return _container('Loading...', Colors.blue);

    return ChangeNotifierProvider(
      create: (context) => LoginState(),
      child: MaterialApp(
        title: 'App Gastos',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: (settings) {
          if (settings.name == '/details') {
            DetailsParams params = settings.arguments;
            return MaterialPageRoute(
              builder: (context) => DetailsScreen(params: params),
            );
          }
          return null;
        },
        routes: {
          '/': (context) {
            var state = Provider.of<LoginState>(context);
            return state.isLoggedIn ? HomeScreen() : LoginScreen();
          },
        },
      ),
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
