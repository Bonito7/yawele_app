import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yawele_app/views/trip/trip_view.dart';

import '../../../models/trip_model.dart';

class TripsList extends StatelessWidget {
  final List<Trip> trips;
  const TripsList({super.key, required this.trips});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: trips.length,
      itemBuilder: (context, i) {
        var trip = trips[i];
        return ListTile(
          title: Text(trip.city!),
          subtitle: trip.date != null // Check if date is not null
              ? Text(DateFormat("d/M/y").format(trip.date!)) // Format the date
              : const Text('Pas de date choisis pour ce voyage!'),
          trailing: const Icon(
            Icons.info,
            color: Colors.orangeAccent,
          ),
          onTap: () =>
              Navigator.pushNamed(context, TripView.routeName, arguments: {
            'tripId': trip.id,
            'cityName': trip.city,
          }),
        );
      },
    );
  }
}
