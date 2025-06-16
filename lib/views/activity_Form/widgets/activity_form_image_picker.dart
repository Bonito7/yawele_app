import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yawele_app/providers/city_provider.dart';
import 'package:provider/provider.dart';

class ActivityFormImagePicker extends StatefulWidget {
  final Function updateUrl;
  const ActivityFormImagePicker({super.key, required this.updateUrl});

  @override
  State<ActivityFormImagePicker> createState() =>
      _ActivityFormImagePickerState();
}

class _ActivityFormImagePickerState extends State<ActivityFormImagePicker> {
  File? _deviceImage; // Nullable File object

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();

    try {
      final XFile? pickedFile = await imagePicker.pickImage(source: source);

      if (pickedFile != null) {
        final url = await Provider.of<CityProvider>(context, listen: false)
            .uploadImage(File(pickedFile.path));
        print('url final $url');
        widget.updateUrl(url);
        setState(() {
          _deviceImage = File(pickedFile.path); // Assign the picked file
        });
        print('Image picked: ${pickedFile.path}');
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Error picking image: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              TextButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(
                  Icons.photo,
                  color: Colors.green,
                ),
                label: const Text(
                  'Galerie',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(
                  Icons.photo_camera,
                  color: Colors.green,
                ),
                label: const Text(
                  'Caméra',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.green),
            ),
            child: _deviceImage != null
                ? Image.file(_deviceImage!,
                    fit: BoxFit.cover) // Display selected image
                : const Text('Aucune Image sélectionnée',
                    textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
