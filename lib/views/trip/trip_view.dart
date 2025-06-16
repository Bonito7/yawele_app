import 'package:flutter/material.dart';
import 'package:yawele_app/providers/city_provider.dart';

import 'package:yawele_app/views/trip/widgets/trip_activities.dart';
import 'package:yawele_app/views/trip/widgets/trip_city_bar.dart';
import 'package:provider/provider.dart';

import '../../models/city_model.dart';
import 'widgets/trip_weather.dart';

class TripView extends StatelessWidget {
  static const String routeName = '/trip';

  const TripView({super.key});

  @override
  Widget build(BuildContext context) {
    print('BUILD : TRIPVIEW');

    final String? cityName = (ModalRoute.of(context)!.settings.arguments
        as Map<String?, String?>)['cityName'];
    final String? tripId = (ModalRoute.of(context)!.settings.arguments
        as Map<String?, String?>)['tripId'];
    final City city = Provider.of<CityProvider>(context, listen: false)
        .getCityByName(cityName!);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              TripCityBar(
                city: city,
              ),
              TripWeather(
                cityName: cityName,
              ),
              TripActivities(
                tripId: tripId!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
