import 'package:flutter/material.dart';
import 'package:yawele_app/providers/city_provider.dart';
import 'package:yawele_app/views/Home/widgets/city_card.dart';
import 'package:yawele_app/widgets/dyma_drawer.dart';
import 'package:yawele_app/widgets/dyma_loader.dart';
import 'package:provider/provider.dart';

import '../../models/city_model.dart';

class HomeView extends StatefulWidget {
  static const String routeName = '/';

  const HomeView({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _HomeViewState createState() {
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CityProvider cityProvider = Provider.of<CityProvider>(context);
    List<City> filteredCities =
        cityProvider.getFilteredCities(searchController.text);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yawélé'),
        actions: const <Widget>[
          Icon(Icons.more_vert),
        ],
      ),
      drawer: const DymaDrawer(),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    cursorColor: Colors.green,
                    controller: searchController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      prefixIconColor: Colors.deepOrangeAccent,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                          width: 2.0,
                        ),
                      ),
                      hintText: 'rechercher une ville',
                    ),
                    onSubmitted: (value) => print(value),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() => searchController.clear());
                  },
                  color: Colors.deepOrangeAccent,
                  icon: const Icon(Icons.clear),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10.00),
              child: cityProvider.isLoading
                  ? const DymaLoader()
                  : filteredCities.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh:
                              Provider.of<CityProvider>(context).fetchData,
                          child: ListView.builder(
                            itemCount: filteredCities.length,
                            itemBuilder: (_, i) => CityCard(
                              city: filteredCities[i],
                            ),
                          ),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Aucun resultat retrouvé!',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrangeAccent,
                              ),
                            ),
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
