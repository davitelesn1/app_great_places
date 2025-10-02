import 'package:app_great_places/models/place.dart';
import 'package:app_great_places/providers/great_places.dart';
import 'package:app_great_places/widgets/location.input.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class PlaceEditScreen extends StatefulWidget {
  const PlaceEditScreen({super.key, required this.place});
  final Place place;

  @override
  State<PlaceEditScreen> createState() => _PlaceEditScreenState();
}

class _PlaceEditScreenState extends State<PlaceEditScreen> {
  late TextEditingController _titleController;
  LatLng? _pickedPosition;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.place.title);
    if (widget.place.location != null) {
      _pickedPosition = LatLng(
        widget.place.location!.latitude,
        widget.place.location!.longitude,
      );
    }
  }

  bool get _isValid => _titleController.text.trim().isNotEmpty;

  void _onSelectLocation(LatLng pos) {
    setState(() {
      _pickedPosition = pos;
    });
  }

  Future<void> _save() async {
    if (!_isValid) return;
    await Provider.of<GreatPlaces>(context, listen: false).updatePlace(
      id: widget.place.id,
      title: _titleController.text.trim(),
      position: _pickedPosition,
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Place'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _isValid ? _save : null,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            LocationInput(onSelectLocation: _onSelectLocation),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Save'),
              onPressed: _isValid ? _save : null,
            )
          ],
        ),
      ),
    );
  }
}
