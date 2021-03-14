import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app_gastos/src/utils/login_state.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<LoginState>(
          builder: (BuildContext context, LoginState state, Widget child) {
            if (state.isLoading) return CircularProgressIndicator();
            return child;
          },
          child: RaisedButton(
            child: Text("Sign in"),
            onPressed: () {
              context.read<LoginState>().login();
            },
          ),
        ),
      ),
    );
  }
}
