import 'package:yawele_app/models/activity_model.dart';
import 'package:yawele_app/models/place_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const GOOGLE_KEY_API = 'AIzaSyDuUYnalbqsnx14aUssQWbAmDxgIjK4T20';

Uri _queryAutocompleteBuilder(String query) {
  return Uri.parse(
    'https://maps.googleapis.com/maps/api/place/queryautocomplete/json?input=$query&key=$GOOGLE_KEY_API',
  );
}

Uri _queryPlaceDetailsBuilder(String placeId) {
  return Uri.parse(
    'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=formatted_address,geometry&key=$GOOGLE_KEY_API',
  );
}

Uri _queryGetAddressFromLatLngBuilder({double? lat, double? lng}) {
  return Uri.parse(
    'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_KEY_API',
  );
}

Future<List<Place>> getAutocompleteSuggestions(String query) async {
  try {
    var response = await http.get(_queryAutocompleteBuilder(query));
    if (response.statusCode == 200) {
      // Parse the JSON response
      var body = jsonDecode(response.body);
      return (body['predictions'] as List)
          .map((suggestion) => Place(
                placeId: suggestion['place_id'],
                description: suggestion['description'],
              ))
          .toList();
    } else {
      throw Exception('Échec du chargement des suggestions');
    }
  } catch (e) {
    print(
        'Erreur dans la récupération des suggestions de la saisie semi-automatique: $e');
    rethrow;
  }
}

Future<LocationActivity> getPlaceDetailsApi(String placeId) async {
  try {
    var response = await http.get(_queryPlaceDetailsBuilder(placeId));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var result = body['result'];
      return LocationActivity(
        address: result['formatted_address'],
        latitude: result['geometry']['location']['lat'],
        longitude: result['geometry']['location']['lng'],
      );
    } else {
      throw Exception('Aucune adresse trouvée pour ce lieu');
    }
  } catch (e) {
    print('Erreur dans la récupération des détails du lieu: $e');
    rethrow;
  }
}

Future<String?> getAddressFromCoordinates({
  required double lat,
  required double lng,
}) async {
  try {
    var response =
        await http.get(_queryGetAddressFromLatLngBuilder(lat: lat, lng: lng));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      return body['results'][0]['formatted_address'];
    } else {
      return null; // Si aucun résultat n'est trouvé
    }
  } catch (e) {
    print('Erreur dans la récupération de l\'adresse: $e');
    rethrow;
  }
}
