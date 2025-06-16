import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yawele_app/models/activity_model.dart';
import 'package:yawele_app/providers/trip_provider.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});
  static const String routeName = '/google-map-view';

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  final bool _isLoaded = false;
  GoogleMapController? controller;
  late Activity _activity;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      var args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      _activity =
          Provider.of<TripProvider>(context, listen: false).getActivityByIds(
        activityId: args['activityId']!,
        tripId: args['tripId']!,
      );
    }
    // You can add any initialization logic here if needed
  }

  get _activityLatLng {
    return LatLng(
      _activity.location!.latitude!,
      _activity.location!.longitude!,
    );
  }

  CameraPosition get _initialCameraPosition {
    return CameraPosition(
      target: _activityLatLng,
      zoom: 14.0,
    );
  }

  Future<void> _openUrl() async {
    final String url = 'google.navigation:q=${_activity.location!.address}';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Impossible d\'ouvrir l\'application de navigation')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_activity.name),
      ),
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) => controller = controller,
        markers: {
          Marker(
            markerId: const MarkerId('activityId'),
            flat: true,
            position: _activityLatLng,
            infoWindow: InfoWindow(title: _activity.name),
          ),
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepOrange,
        icon: const Icon(
          Icons.directions_car,
          color: Colors.white,
        ),
        onPressed: _openUrl,
        label: const Text(
          'Visiter ',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
