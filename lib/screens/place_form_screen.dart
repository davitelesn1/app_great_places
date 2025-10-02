import 'dart:io';
import 'package:app_great_places/widgets/image_input.dart';
import 'package:app_great_places/widgets/location.input.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:app_great_places/providers/great_places.dart';

class PlaceFormScreen extends StatefulWidget {
  const PlaceFormScreen({super.key});


  @override
  State<PlaceFormScreen> createState() => _PlaceFormScreenState();
}

class _PlaceFormScreenState extends State<PlaceFormScreen> {
  final _titleController = TextEditingController();
  File? _pickedImage;
  LatLng? _pickedPosition;

  void _selectImage(File pickedImage) {
    setState(() {
      _pickedImage = pickedImage;
    });
  }

  void _selectLocation(LatLng position) {
    setState(() {
    _pickedPosition = position;
      
    });
  }

  bool _isValidLocation() {
    return _titleController.text.isNotEmpty && _pickedImage != null && _pickedPosition != null;
  }

  void _submitForm() {
    if (!_isValidLocation()) {
      return;
    }
    Provider.of<GreatPlaces>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage!, _pickedPosition!);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('New Place'),
      ),

      body: Column(

        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(height: 10),
                    ImageInput(onSelectImage: _selectImage),
                    SizedBox(height: 10),
                    LocationInput(onSelectLocation: _selectLocation),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _isValidLocation() ? _submitForm : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              elevation: 0,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Add Place'),
          ),
        ],
      ),
    );
  }
}
