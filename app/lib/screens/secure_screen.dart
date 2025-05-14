import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _SecureScreenStatus extends State<SecureScreen> {
  static final Logger _logger = Logger();
  String _name = "";

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((instance) {
      _name = instance.getString("name") ?? '';
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(_name)));
  }
}

class SecureScreen extends StatefulWidget {
  const SecureScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SecureScreenStatus();
}
