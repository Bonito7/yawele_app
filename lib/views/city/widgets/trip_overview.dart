import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/trip_model.dart';
import 'trip_overview_city.dart';

class TripOverview extends StatelessWidget {
  final VoidCallback setDate;
  final Trip? trip;
  final String? cityName;
  final String? cityImage;
  final String? cityId;
  final double? amount;

  const TripOverview(
      {super.key,
      required this.setDate,
      this.cityId,
      this.trip,
      this.cityName,
      this.cityImage,
      this.amount});

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var size = MediaQuery.of(context).size;

    return Container(
      width:
          orientation == Orientation.landscape ? size.width * 0.5 : size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: TripOverviewCity(
              cityName: cityName!,
              cityImage: cityImage!,
              cityId: cityId!,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    trip?.date != null
                        ? DateFormat("d/M/y").format(trip!.date!)
                        : 'Choisissez une date',
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.orangeAccent),
                  ),
                  onPressed: setDate,
                  child: const Text(
                    'Selectionner une date',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Montant / personne',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Text(
                  '$amount CFA',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
