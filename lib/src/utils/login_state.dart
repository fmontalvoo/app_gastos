import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginState with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _loggedIn = false;
  bool _loading = false;
  User _user;
  SharedPreferences _prefs;

  LoginState() {
    loginState();
  }

  bool get isLoggedIn => this._loggedIn;

  bool get isLoading => this._loading;

  User get currentUser => this._user;

  void login() async {
    this._loading = true;
    notifyListeners();

    _user = await _handleSignIn();

    this._loading = false;
    if (_user != null)
      this._loggedIn = true;
    else
      this._loggedIn = false;

    this._prefs.setBool('idLoggedIn', this._loggedIn);
    notifyListeners();
  }

  void logout() {
    _googleSignIn.signOut();
    this._loggedIn = false;
    this._prefs.clear();
    notifyListeners();
  }

  Future<User> _handleSignIn() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
    UserCredential user = await _auth.signInWithCredential(
        GoogleAuthProvider.credential(
            idToken: gSA.idToken, accessToken: gSA.accessToken));
    return user.user;
  }

  void loginState() async {
    this._prefs = await SharedPreferences.getInstance();
    if (this._prefs.containsKey('idLoggedIn') &&
        this._prefs.getBool('idLoggedIn')) {
      this._user = this._auth.currentUser;
      this._loggedIn = (this._user != null);
      this._loading = false;
      notifyListeners();
    } else {
      this._loading = false;
      notifyListeners();
    }
  }
}
