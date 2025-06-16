import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:yawele_app/apis/google_api.dart';
import 'package:yawele_app/providers/city_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/activity_model.dart';
import 'activity_form_autocomplete.dart';
import 'activity_form_image_picker.dart';

class ActivityForm extends StatefulWidget {
  final String cityName;
  const ActivityForm({super.key, required this.cityName});

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late FocusNode _priceFocusNode;
  late FocusNode _urlFocusNode;
  late FocusNode _addressFocusNode;
  late String? _nameInputAsync;
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool isLoading = false;

  late Activity _newActivity;

  FormState? get form {
    return formKey.currentState;
  }

  @override
  void initState() {
    // TODO: implement initState
    _newActivity = Activity(
      city: widget.cityName,
      name: '',
      price: 0,
      image: '',
      location: LocationActivity(
        address: null,
        latitude: null,
        longitude: null,
      ),
      status: ActivityStatus.ongoing,
    );
    _priceFocusNode = FocusNode();
    _urlFocusNode = FocusNode();
    _addressFocusNode = FocusNode();
    _addressFocusNode.addListener(() async {
      if (_addressFocusNode.hasFocus) {
        var location = await showInputAutocomplete(context);
        _newActivity.location = location;
        setState(() {
          _addressController.text = location?.address ?? "";
        });

        _urlFocusNode.requestFocus();
      } else {
        print('no focus');
      }
    });

    super.initState();
  }

  void updateUrlField(String url) {
    setState(() {
      _urlController.text = url;
    });
  }

  void _getCurrentLocation() async {
    try {
      LocationData userLocation = await Location().getLocation();
      String? address = await getAddressFromCoordinates(
        lat: userLocation.latitude!,
        lng: userLocation.longitude!,
      );
      _newActivity.location = LocationActivity(
        address: address ?? 'Unknown Address',
        latitude: userLocation.latitude!, // Replace with actual latitude
        longitude: userLocation.longitude!, // Replace with actual longitude
      );
      setState(() {
        _addressController.text = address ?? 'Unknown Address';
      });
    } catch (e) {
      rethrow;
    }

    _urlFocusNode.requestFocus();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _urlController.dispose();
    _priceFocusNode.dispose();
    _urlFocusNode.dispose();
    _addressFocusNode.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    try {
      CityProvider cityProvider = Provider.of<CityProvider>(
        context,
        listen: false,
      );
      // Save the form state before proceeding
      formKey.currentState?.save();
      // Set loading state to true
      setState(() => isLoading = true);
      // Check if the activity name is unique asynchronously
      _nameInputAsync = await cityProvider.verifyIfActivityNameIsUnique(
        widget.cityName,
        _newActivity.name,
      );

      // Validate the form fields after async check
      if (form!.validate()) {
        // Add the activity to the city using the provider
        await cityProvider.addActivityToCity(_newActivity);
        // Return to previous screen
        Navigator.pop(context);
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      // Handle any exceptions that occur during form submission
      print('Error: $e');
      // Always stop loading after the process
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              autofocus: true,
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Remplissez le nom';
                } else if (_nameInputAsync != null) {
                  return _nameInputAsync;
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nom',
                labelStyle: TextStyle(
                  color: Colors.orangeAccent,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
              cursorColor: Colors.green,
              onSaved: (newValue) => _newActivity.name = newValue!,
            ),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) return 'Remplissez le prix';
                return null;
              },
              focusNode: _priceFocusNode,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Prix',
                labelStyle: TextStyle(
                  color: Colors.orangeAccent,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
              cursorColor: Colors.green,
              onSaved: (newValue) =>
                  _newActivity.price = double.parse(newValue!),
            ),
            const SizedBox(height: 25),
            TextFormField(
              focusNode: _addressFocusNode,
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Adresse de la ville',
                labelStyle: TextStyle(
                  color: Colors.orangeAccent,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
              onSaved: (newValue) => _newActivity.location!.address = newValue!,
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              icon: const Icon(Icons.gps_fixed, color: Colors.orangeAccent),
              label: const Text('Utiliser ma position actuelle'),
              onPressed: _getCurrentLocation,
            ),
            const SizedBox(height: 15),
            TextFormField(
              keyboardType: TextInputType.url,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Remplissez l\'url de l\'image';
                }
                return null;
              },
              focusNode: _urlFocusNode,
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Url de l\'image',
                labelStyle: TextStyle(
                  color: Colors.orangeAccent,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
              cursorColor: Colors.green,
              onSaved: (newValue) => _newActivity.image = newValue!,
            ),
            const SizedBox(height: 10),
            ActivityFormImagePicker(
              updateUrl: updateUrlField,
            ),
            const SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Annuler',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.orangeAccent),
                  ),
                  onPressed: isLoading ? null : submitForm,
                  child: isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Enregistrer',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
