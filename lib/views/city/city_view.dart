import 'package:flutter/material.dart';
import 'package:yawele_app/providers/city_provider.dart';
import 'package:yawele_app/providers/trip_provider.dart';
import 'package:yawele_app/views/Home/home_view.dart';
import 'package:provider/provider.dart';

import '../../widgets/dyma_drawer.dart';
import '../activity_Form/activity_form_view.dart';
import './widgets/trip_activity_list.dart';
import './widgets/activity_list.dart';
import './widgets/trip_overview.dart';

import '../../models/city_model.dart';
import '../../models/trip_model.dart';
import '../../models/activity_model.dart';

class CityView extends StatefulWidget {
  static const String routeName = '/city';

  showContext({BuildContext? context, List<Widget>? children}) {
    var orientation = MediaQuery.of(context!).orientation;
    if (orientation == Orientation.landscape) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children!,
      );
    } else {
      return Column(
        children: children!,
      );
    }
  }

  const CityView({super.key});

  @override
  State<CityView> createState() => _CityViewState();
}

class _CityViewState extends State<CityView> with WidgetsBindingObserver {
  late Trip mytrip;
  late int index;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    mytrip = Trip(
      activities: [],
      city: null,
      date: null,
      id: null,
    );
    index = 0;
  }

  double get amount {
    return mytrip.activities.fold(0.00, (prev, element) {
      return prev + element.price;
    });
  }

  void setDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.orange, // Change primary color here
              onPrimary: Colors.white, // Text color on primary elements
              onSurface: Colors.black, // Text color on the calendar
            ),
            dialogBackgroundColor:
                Colors.white, // Background color of the dialog
          ),
          child: child!,
        );
      },
    ).then(
      (newDate) {
        if (newDate != null) {
          // Handle the new date
          setState(() {
            mytrip.date = newDate;
          });
        }
      },
    );
  }

  void switchIndex(newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  void toggleActivity(Activity activity) {
    setState(() {
      mytrip.activities.contains(activity)
          ? mytrip.activities.remove(activity)
          : mytrip.activities.add(activity);
    });
  }

  void deleteTripActivity(Activity activity) {
    setState(() {
      mytrip.activities.remove(activity);
    });
  }

  void saveTrip(String cityName) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Voulez vous sauvegarder ?'),
          contentPadding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, 'cancel');
                  },
                  child: const Text(
                    'Annuler',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.orangeAccent),
                  ),
                  onPressed: () {
                    Navigator.pop(context, 'save');
                  },
                  child: const Text(
                    'Sauvegarder',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
    if (result == 'save' && mytrip.date == null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Attention !',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
                ),
              ),
              content: const Text(
                  'Vous n\'avez pas entré de date pour votre voyage, veillez à le faire svp!'),
              actions: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.orangeAccent),
                    fixedSize:
                        WidgetStateProperty.all(const Size.fromWidth(350)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Ok',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          });
    } else if (result == 'save') {
      // widget.addTrip(mytrip);
      mytrip.city = cityName;
      Provider.of<TripProvider>(context, listen: false).addTrip(mytrip);
      Navigator.pushNamed(context, HomeView.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    String cityName = ModalRoute.of(context)?.settings.arguments as String;
    City city = Provider.of<CityProvider>(context).getCityByName(cityName);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organisation du voyage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () => Navigator.pushNamed(
              context,
              ActivityFormView.routeName,
              arguments: cityName,
            ),
          ),
        ],
      ),
      drawer: const DymaDrawer(),
      body: Container(
        padding: const EdgeInsets.all(2),
        child: widget.showContext(
          context: context,
          children: [
            TripOverview(
              cityName: city.name,
              cityImage: city.image,
              cityId: city.id,
              setDate: setDate,
              trip: mytrip,
              amount: amount,
            ),
            Expanded(
              child: index == 0
                  ? ActivityList(
                      activities: city.activities,
                      selectedActivities: mytrip.activities,
                      toggleActivity: toggleActivity,
                    )
                  : TripActivityList(
                      activities: mytrip.activities,
                      deleteTripActivity: deleteTripActivity,
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () {
          saveTrip(city.name);
        },
        child: const Icon(
          Icons.forward,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        fixedColor: Colors.green[700],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Decouverte',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stars),
            label: 'Mes activités',
          ),
        ],
        onTap: switchIndex,
      ),
    );
  }
}
