import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yawele_app/apis/google_api.dart';
import 'package:yawele_app/models/place_model.dart';

import '../../../models/activity_model.dart';

Future<LocationActivity?> showInputAutocomplete(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true, // important pour le clavier
    backgroundColor:
        Colors.transparent, // pour un effet visuel propre si besoin
    builder: (context) => const InputAdress(),
  );
}

class InputAdress extends StatefulWidget {
  const InputAdress({super.key});

  @override
  State<InputAdress> createState() => _InputAdressState();
}

class _InputAdressState extends State<InputAdress> {
  List<Place> _places = [];
  Timer? _debounce;

  Future<void> _searchAddress(String value) async {
    try {
      if (_debounce?.isActive == true) _debounce?.cancel();
      _debounce = Timer(const Duration(seconds: 1), () async {
        print(value);
        if (value.isNotEmpty) {
          _places = await getAutocompleteSuggestions(value);
          setState(() {});
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getPlaceDetails(String placeId) async {
    try {
      LocationActivity location =
          await getPlaceDetailsApi(placeId); // Récupère les détails
      if (location.address != null) {
        Navigator.pop(
            context, location); // Ferme le modal et renvoie la location
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // ← empêche de passer sous la status bar
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Rechercher',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: _searchAddress,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => Navigator.pop(context, null),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _places.length,
                  itemBuilder: (_, i) {
                    final place = _places[i];
                    return ListTile(
                      leading: const Icon(Icons.place),
                      title: Text(place.description),
                      onTap: () => getPlaceDetails(place.placeId),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
