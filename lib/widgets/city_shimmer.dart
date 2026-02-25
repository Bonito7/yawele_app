import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CityShimmer extends StatelessWidget {
  const CityShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4, // Number of skeleton items
      itemBuilder: (context, index) {
        return Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
          child: SizedBox(
            height: 150,
            width: double.infinity,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
