import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import '../models/activity_model.dart';
import '../models/city_model.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';

class CityProvider with ChangeNotifier {
  final String host = 'https://yawele-api.onrender.com';
  List<City> _cities = [];
  bool isLoading = false;

  UnmodifiableListView<City> get cities => UnmodifiableListView(_cities);

  City getCityByName(String cityName) =>
      cities.firstWhere((city) => city.name == cityName);

  UnmodifiableListView<City> getFilteredCities(String filter) =>
      UnmodifiableListView(
        _cities
            .where(
              (city) => city.name.toLowerCase().startsWith(
                    filter.toLowerCase(),
                  ),
            )
            .toList(),
      );

  Future<void> fetchData() async {
    try {
      isLoading = true;
      final Uri url = Uri.parse('$host/api/cities');
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        _cities = (json.decode(response.body) as List)
            .map((cityJson) => City.fromJson(cityJson))
            .toList();
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      rethrow;
    }
  }

  Future<void> addActivityToCity(Activity newActivity) async {
    try {
      isLoading = true;

      String cityId = getCityByName(newActivity.city).id;
      final Uri url = Uri.parse('$host/api/city/$cityId/activity');
      http.Response response = await http.post(
        url,
        body: jsonEncode(newActivity.toJson()),
        headers: {'Content-type': 'application/json'},
      );

      if (response.statusCode == 200) {
        int index = _cities.indexWhere((city) => city.id == cityId);
        _cities[index] = City.fromJson(json.decode(response.body));

        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      rethrow;
    }
  }

  Future<dynamic> verifyIfActivityNameIsUnique(
      String cityName, String activityName) async {
    try {
      City city = getCityByName(cityName);
      final Uri url = Uri.parse(
          '$host/api/city/${city.id}/activities/verify/$activityName');

      http.Response response = await http.get(url);

      // Print the status code and body for debugging
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Error in verifying activity: $e');
      rethrow;
    }
  }

  Future<String> uploadImage(File pickedImage) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse('$host/api/activity/image'),
    );

    request.files.add(
      http.MultipartFile.fromBytes(
        'activity',
        pickedImage.readAsBytesSync(),
        filename: basename(pickedImage.path),
        contentType: MediaType('multipart', 'form-data'),
      ),
    );
    try {
      // Send the request
      var response = await request.send();

      // Read and return the response
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        print(responseData);
        print('Image uploaded successfully');
        return json.decode(responseString);
      } else {
        return 'Failed to upload image: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error occurred: $e';
    }
  }
}
