import 'package:flutter/material.dart';
import 'package:yawele_app/providers/trip_provider.dart';
import 'package:yawele_app/views/trips/widgets/trips_list.dart';
import 'package:yawele_app/widgets/dyma_drawer.dart';
import 'package:yawele_app/widgets/dyma_loader.dart';
import 'package:provider/provider.dart';

class TripsView extends StatelessWidget {
  static const String routeName = '/trips';

  const TripsView({super.key});

  @override
  Widget build(BuildContext context) {
    TripProvider tripProvider = Provider.of<TripProvider>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Mes voyages',
          ),
          bottom: TabBar(
            indicatorColor: Colors.deepOrangeAccent,
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelColor: Colors.orange[400],
            labelStyle: TextStyle(
              color: Colors.orange[100],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(
                text: 'A venir',
              ),
              Tab(
                text: 'Passés',
              ),
            ],
          ),
        ),
        drawer: const DymaDrawer(),
        body: tripProvider.isLoading != true
            ? tripProvider.trips.isNotEmpty
                ? TabBarView(
                    children: [
                      TripsList(
                        trips: tripProvider.trips
                            .where(
                                (trip) => DateTime.now().isBefore(trip.date!))
                            .toList(),
                      ),
                      TripsList(
                        trips: tripProvider.trips
                            .where((trip) => DateTime.now().isAfter(trip.date!))
                            .toList(),
                      ),
                    ],
                  )
                : Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Aucun voyage pour le moment !',
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
                      ),
                    ),
                  )
            : const DymaLoader(),
      ),
    );
  }
}
