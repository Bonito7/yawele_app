import 'package:flutter/material.dart';
import 'package:yawele_app/providers/city_provider.dart';
import 'package:yawele_app/providers/trip_provider.dart';
import 'package:yawele_app/views/activity_Form/activity_form_view.dart';
import 'package:yawele_app/views/google_map/google_map_view.dart';
import 'package:yawele_app/views/trip/trip_view.dart';
import 'package:yawele_app/views/trips/trips_view.dart';
// import 'package:projet_dyma_end/widgets/widgets_courses/example_animation_widget.dart';
// import 'package:projet_dyma_end/widgets/widgets_courses/main_widget.dart';

import 'package:provider/provider.dart';

import './views/city/city_view.dart';
import 'views/not-found/not_found.dart';
import './views/Home/home_view.dart';

main() {
  runApp(const DymaTrip());
}

class DymaTrip extends StatefulWidget {
  // final List<City> cities = data.cities;

  const DymaTrip({super.key});

  @override
  State<DymaTrip> createState() => _DymaTripState();
}

class _DymaTripState extends State<DymaTrip> {
  final CityProvider cityProvider = CityProvider();
  final TripProvider tripProvider = TripProvider();

  @override
  void initState() {
    cityProvider.fetchData();
    tripProvider.fetchData();
    super.initState();
  }
  // void addTrip(Trip trip) {
  //   setState(() {
  //     trips.add(trip);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: cityProvider,
        ),
        ChangeNotifierProvider.value(
          value: tripProvider,
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepOrangeAccent,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 23),
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        debugShowCheckedModeBanner: false,
        // home: const ExampleAnimationWidget(),
        // home: const MainWidget(),
        home: const HomeView(),
        routes: {
          CityView.routeName: (_) => const CityView(),
          TripsView.routeName: (_) => const TripsView(),
          TripView.routeName: (_) => const TripView(),
          ActivityFormView.routeName: (_) => const ActivityFormView(),
          GoogleMapView.routeName: (_) => const GoogleMapView(),
        },
        onUnknownRoute: (_) {
          return MaterialPageRoute(builder: (_) {
            return const NotFound();
          });
        },
      ),
    );
  }
}
