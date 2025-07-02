import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hm/screens/geo_screen.dart';
import 'package:hm/screens/secure_screen.dart';
import 'package:hm/service/storage_service.dart';
import 'package:logger/logger.dart';

class MyMenu extends StatelessWidget {
  static final Logger _logger = Logger();

  const MyMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.black),
            accountName: FutureBuilder<String>(
              future: StorageService.getValue('name'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(snapshot.data ?? 'Nombre');
                } else if (snapshot.hasError) {
                  return const Text("Nombre");
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            accountEmail: FutureBuilder<String>(
              future: StorageService.getValue('email'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(snapshot.data ?? 'Correo');
                } else if (snapshot.hasError) {
                  return const Text("Correo");
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: FutureBuilder(
                  future: StorageService.getValue('photoUrl'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      String url = snapshot.data ?? '';
                      if (url.isNotEmpty) {
                        return CachedNetworkImage(
                          imageUrl: url,
                          placeholder: (context, url) {
                            return const CircularProgressIndicator();
                          },
                          errorWidget: (context, url, error) {
                            _logger.e(error);
                            return const Icon(
                              Icons.person_3,
                              color: Colors.red,
                              size: 47,
                            );
                          },
                        );
                      } else {
                        return const Icon(Icons.person_2, size: 47);
                      }
                    } else if (snapshot.hasError) {
                      return const Icon(
                        Icons.person_3,
                        color: Colors.red,
                        size: 47,
                      );
                    } else {
                      return const Icon(Icons.person_4);
                    }
                  },
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              _logger.d("Voy a inicio");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SecureScreen();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.my_location),
            title: const Text('Ubicación'),
            onTap: () {
              _logger.d("Voy a ubicación");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const GeoScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
