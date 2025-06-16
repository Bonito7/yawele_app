import 'package:yawele_app/models/activity_model.dart';

class Trip {
  String? id;
  String? city;
  List<Activity> activities;
  DateTime? date;
  Trip({
    this.city,
    required this.activities,
    this.date,
    this.id,
  });

  Trip.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        city = json['city'],
        date = DateTime.parse(json['date']),
        activities = (json['activities'] as List)
            .map(
              (activityJson) => Activity.fromJson(activityJson),
            )
            .toList();

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'date': date?.toIso8601String(),
      'activities': activities.map((activity) => activity.toJson()).toList(),
    };
  }
}
