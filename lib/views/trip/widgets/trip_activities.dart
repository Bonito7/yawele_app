import 'package:flutter/material.dart';

import 'package:yawele_app/views/trip/widgets/trip_activities_list.dart';

import '../../../models/activity_model.dart';

class TripActivities extends StatelessWidget {
  final String tripId;

  const TripActivities({super.key, required this.tripId});

  @override
  Widget build(BuildContext context) {
    print('BUILD : TRIPACTIVITIES');

    return Container(
      child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                color: Colors.deepOrangeAccent,
                child: TabBar(
                  indicatorColor: Colors.deepOrangeAccent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  unselectedLabelColor: Colors.orange[400],
                  labelStyle: TextStyle(
                    color: Colors.orange[100],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: const [
                    Tab(
                      text: 'En cours',
                    ),
                    Tab(
                      text: 'Terminé(s)',
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 600,
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    TripActivitiesList(
                      tripId: tripId,
                      filter: ActivityStatus.ongoing,
                    ),
                    TripActivitiesList(
                      tripId: tripId,
                      filter: ActivityStatus.done,
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
