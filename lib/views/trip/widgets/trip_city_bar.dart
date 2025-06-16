import 'package:flutter/material.dart';
import 'package:yawele_app/models/city_model.dart';

class TripCityBar extends StatelessWidget {
  final City city;
  const TripCityBar({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.darken),
            child: Image.network(
              city.image,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Expanded(
                    child: Center(
                  child: Text(
                    city.name,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
