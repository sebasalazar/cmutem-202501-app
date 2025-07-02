import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hm/widgets/my_menu.dart';
import 'package:latlong2/latlong.dart';

class GeoScreenState extends State<GeoScreen> {
  Future<LatLng> _currentPosition() async {
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

    Position position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyMenu(),
      appBar: AppBar(title: Text("Página de ubicación")),
      body: FutureBuilder(
        future: _currentPosition(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            LatLng? geo = snapshot.data;
            if (geo != null) {
              return FlutterMap(
                options: MapOptions(initialCenter: geo, initialZoom: 17),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    userAgentPackageName: 'cl.utem.cm',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: geo,
                        width: 80,
                        height: 80,
                        child: const Icon(Icons.location_pin),
                      ),
                    ],
                  ),
                ],
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
    );
  }
}

class GeoScreen extends StatefulWidget {
  const GeoScreen({super.key});

  @override
  State<StatefulWidget> createState() => GeoScreenState();
}
