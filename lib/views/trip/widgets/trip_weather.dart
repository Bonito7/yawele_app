import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:yawele_app/widgets/dyma_loader.dart';

class TripWeather extends StatelessWidget {
  final String cityName;
  final String hostBase = 'https://api.openweathermap.org/data/2.5/weather?q=';
  final String apiKey = '&lang=fr&appid=1be35d720d7c5af7273813c2a5d6f262';

  const TripWeather({super.key, required this.cityName});

  Uri get url => Uri.parse('$hostBase$cityName$apiKey');

  Future<Map<String, String>> getWeather(Uri url) async {
    try {
      // Make the HTTP GET request
      final http.Response response = await http.get(url);

      // Check if the response status is successful
      if (response.statusCode == 200) {
        // Decode the response body
        Map<String, dynamic> body = json.decode(response.body);

        // Safely extract the 'icon' from the weather data
        if (body['weather'] != null && body['weather'].isNotEmpty) {
          String icon = body['weather'][0]['icon'];
          String description = body['weather'][0]['description'];
          return {'icon': icon, 'description': description};
        } else {
          return {'error': 'Aucune donnée météorologique trouvée'};
        }
      } else {
        return {
          'error': 'Erreur : Échec de l\'extraction des données météorologiques'
        };
      }
    } catch (e) {
      // Handle any error that occurs during the HTTP request
      return {'error': 'Error: $e'};
    }
  }
  // Future<String> get getWeather{
  //   return http.get(url).then((http.Response response){
  //     Map<String, dynamic> body = json.decode(response.body);
  //     return body['weather'][0]['icon'];

  //   }).catchError((e) => 'error');
  // }

  String getIconUrl(String iconName) {
    return 'https://openweathermap.org/img/wn/$iconName@2x.png';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getWeather(url),
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          return const Text('Une erreur s\'est produite');
        } else if (snapshot.hasData) {
          var weatherData = snapshot.data!;
          if (weatherData.containsKey('error')) {
            return Text(weatherData['error']!);
          }
          String icon = weatherData['icon']!;
          String description = weatherData['description']!;
          return Container(
            color: Colors.greenAccent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Météo',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.green[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.green[900],
                    ),
                  ),
                  Image.network(
                    getIconUrl(icon),
                    height: 50,
                    width: 50,
                  ),
                ],
              ),
            ),
          );
        } else {
          return const DymaLoader();
        }
      },
    );
  }
}
