import 'package:flutter/material.dart';
import 'package:hm/service/rest_service.dart';
import 'package:hm/widgets/my_menu.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _SecureScreenStatus extends State<SecureScreen> {
  static final Logger _logger = Logger();
  String _name = "";
  int _temperature = 0;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((instance) {
      _name = instance.getString("name") ?? '';
      setState(() {
        _logger.d("Actualizando vista");
      });
    });

    RestService.getWheather("SCEL").then((data) {
      _temperature = data?.temperature ?? 0;
      setState(() {
        _logger.d("Actualizando vista");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyMenu(),
      appBar: AppBar(title: Text("Página segura")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Mi nombre es $_name")),
          Center(child: Text("La temperatura es $_temperature")),
        ],
      ),
    );
  }
}

class SecureScreen extends StatefulWidget {
  const SecureScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SecureScreenStatus();
}
