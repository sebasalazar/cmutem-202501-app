import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hm/widgets/my_menu.dart';

class GeoScreenState extends State<GeoScreen> {
  Future<Position> _currentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('La ubicación está desactivada');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("El permiso de ubicación fue denegado");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("El permiso está permanentemente denegado");
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyMenu(),
      appBar: AppBar(title: Text("Página de ubicación")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: FutureBuilder(
              future: _currentPosition(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Position? position = snapshot.data;
                  if (position != null) {
                    return Text(
                      "Latitud :${position.latitude} Longitud: ${position.longitude}",
                    );
                  } else {
                    return const Text("No fue posible determinar su ubicación");
                  }
                } else if (snapshot.hasError) {
                  return const Text("No fue posible determinar su ubicación");
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GeoScreen extends StatefulWidget {
  const GeoScreen({super.key});

  @override
  State<StatefulWidget> createState() => GeoScreenState();
}
