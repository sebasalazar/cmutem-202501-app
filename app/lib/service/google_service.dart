import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleService {
  static final Logger _logger = Logger();
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static Future<bool> logIn(BuildContext context) async {
    bool ok = false;
    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        GoogleSignInAuthentication auth = await account.authentication;
        String accessToken = auth.accessToken ?? '';
        String idToken = auth.idToken ?? '';
        ok = (accessToken.isNotEmpty && idToken.isNotEmpty);
        if (ok) {
          SharedPreferences.getInstance().then((current) {
            current.setString("idToken", idToken);
            current.setString("email", account.email);
            current.setString("name", account.displayName ?? '');
            current.setString("photoUrl", account.photoUrl ?? '');
          });
        }
      }
    } catch (error, stackTrace) {
      _logger.e(error);
      _logger.t(stackTrace.toString());
    }
    return ok;
  }
}
