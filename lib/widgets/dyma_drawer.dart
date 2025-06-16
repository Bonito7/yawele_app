import 'package:flutter/material.dart';

import '../views/Home/home_view.dart';
import '../views/trips/trips_view.dart';

class DymaDrawer extends StatelessWidget {
  const DymaDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepOrangeAccent,
                  Color.fromARGB(180, 255, 109, 64)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DymaTrip',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Votre application de gestion de voyage',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            iconColor: Colors.deepOrangeAccent,
            leading: const Icon(Icons.home),
            title: const Text('Accueil'),
            onTap: () {
              Navigator.pushNamed(context, HomeView.routeName);
            },
          ),
          ListTile(
            iconColor: Colors.deepOrangeAccent,
            leading: const Icon(Icons.flight),
            title: const Text('Mes voyages'),
            onTap: () {
              Navigator.pushNamed(context, TripsView.routeName);
            },
          ),
        ],
      ),
    );
  }
}
