enum ActivityStatus { ongoing, done }

class Activity {
  String name;
  String image;
  String? id;
  String city;
  double price;
  ActivityStatus status;
  LocationActivity? location;
  Activity({
    required this.name,
    required this.city,
    this.id,
    required this.image,
    required this.price,
    this.status = ActivityStatus.ongoing,
    required this.location,
  });

  Activity.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'],
        image = json['image'],
        city = json['city'],
        price = json['price'].toDouble(),
        location = LocationActivity(
          address: json['address'],
          latitude: json['latitude'].toDouble(),
          longitude: json['longitude'].toDouble(),
        ),
        status =
            json['status'] == 0 ? ActivityStatus.ongoing : ActivityStatus.done;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> value = {
      'name': name,
      'image': image,
      'city': city,
      'price': price,
      'address': location?.address,
      'longitude': location?.longitude,
      'latitude': location?.latitude,
      'status': status == ActivityStatus.ongoing ? 0 : 1
    };
    if (id != null) {
      value['_id'] = id;
    }
    return value;
  }
}

class LocationActivity {
  String? address;
  double? longitude;
  double? latitude;

  LocationActivity({
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}
