import 'package:flutter/material.dart';
import 'package:hm/screens/secure_screen.dart';
import 'package:hm/service/google_service.dart';
import 'package:logger/logger.dart';

class LoginScreen extends StatelessWidget {
  static final Logger _logger = Logger();

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/img/logo_utem.jpg', width: 300, height: 300),
              ElevatedButton(
                onPressed: () {
                  GoogleService.logIn(context).then((ok) {
                    if (ok) {
                      _logger.i("Autenticación exitosa");
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SecureScreen();
                          },
                        ),
                      );
                    } else {
                      _logger.e("Autenticación fallida");
                    }
                  });
                },
                child: Text('Iniciar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
