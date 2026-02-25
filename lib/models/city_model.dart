import './activity_model.dart';

class City {
  String id;
  String image;
  String name;
  List<Activity> activities;
  City({
    required this.image,
    required this.name,
    required this.activities,
    required this.id,
  });

  City.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        image = json['image']
            .toString()
            .replaceAll('http://', 'https://')
            .replaceAll('/public/assets/', '/assets/'),
        name = json['name'],
        activities = (json['activities'] as List).map(
          (activityJson) {
            // Fix activity specific image paths if they come malformed within the city response
            if (activityJson['image'] != null) {
              activityJson['image'] = activityJson['image']
                  .toString()
                  .replaceAll('http://', 'https://')
                  .replaceAll('/public/assets/', '/assets/')
                  .replaceAll('/assets/images/', '/assets/images/activities/')
                  .replaceAll('/activities/activities/', '/activities/');
            }
            return Activity.fromJson(activityJson);
          },
        ).toList();
}
