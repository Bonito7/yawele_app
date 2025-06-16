import 'package:flutter/material.dart';
import '../../../models/activity_model.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final bool isSelected;
  final VoidCallback toggleActivity;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.isSelected,
    required this.toggleActivity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.all(2),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Ink.image(
            image: NetworkImage(activity.image),
            fit: BoxFit.cover,
            child: InkWell(
              onTap: toggleActivity,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (isSelected)
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 40,
                          color: Colors.green,
                        ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: FittedBox(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          color: const Color.fromARGB(180, 76, 175, 79),
                          child: Text(
                            activity.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}





// Card(
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundImage: AssetImage(
//             activity.image,
//           ),
//         ),
//         subtitle: Text(activity.city),
//         title: Text(activity.name),
//         trailing: Checkbox(
//           value: false,
//           tristate: false,
//           onChanged: (value) {},
//         ),
//       ),
//     );