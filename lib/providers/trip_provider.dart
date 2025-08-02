import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/activity_model.dart';
import '../models/trip_model.dart';

class TripProvider with ChangeNotifier {
  final String host = 'https://yawele-api.onrender.com';
  List<Trip> _trips = [];
  bool isLoading = false;

  UnmodifiableListView<Trip> get trips => UnmodifiableListView(_trips);

  Future<void> fetchData() async {
    try {
      isLoading = true;
      final Uri url = Uri.parse('$host/api/trips');
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        _trips = (json.decode(response.body) as List)
            .map((tripJson) => Trip.fromJson(tripJson))
            .toList();
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      rethrow;
    }
  }

  Future<void> addTrip(Trip trip) async {
    try {
      final Uri url = Uri.parse('$host/api/trip');
      http.Response response = await http.post(
        url,
        body: jsonEncode(trip.toJson()),
        headers: {'Content-type': 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        _trips.add(
          Trip.fromJson(
            json.decode(response.body),
          ),
        );
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTrip(Trip trip, String activityId) async {
    try {
      Activity activity =
          trip.activities.firstWhere((activity) => activity.id == activityId);

      activity.status = ActivityStatus.done;

      final Uri url = Uri.parse('$host/api/trip');
      http.Response response = await http.put(
        url,
        body: jsonEncode(trip.toJson()),
        headers: {'Content-type': 'application/json'},
      );
      if (response.statusCode != 200) {
        activity.status = ActivityStatus.ongoing;
        throw const HttpException('Error!');
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Trip getTripById(String tripId) {
    return trips.firstWhere((trip) => trip.id == tripId);
  }

  Activity getActivityByIds(
      {required String activityId, required String tripId}) {
    return getTripById(tripId)
        .activities
        .firstWhere((activity) => activity.id == activityId);
  }
}
