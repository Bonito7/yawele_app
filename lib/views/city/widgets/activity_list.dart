import 'package:flutter/material.dart';
import '../../../models/activity_model.dart';
import 'activity_card.dart';

class ActivityList extends StatelessWidget {
  final List<Activity> activities;
  final Function toggleActivity;
  final List<Activity> selectedActivities;

  const ActivityList({
    super.key,
    required this.activities,
    required this.selectedActivities,
    required this.toggleActivity,
  });

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      children: activities
          .map(
            (activity) => ActivityCard(
              activity: activity,
              isSelected: selectedActivities.contains(activity),
              toggleActivity: () => toggleActivity(activity),
            ),
          )
          .toList(),
    );
  }
}
