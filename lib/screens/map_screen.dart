import 'package:app_great_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isReadonly;

  const MapScreen({
    super.key,
    this.initialLocation = const PlaceLocation(
      latitude: 37.7749,
      longitude: -122.4194,
      address: '',
    ),
    this.isReadonly = false,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedPosition;

  void _selectPosition(LatLng position) {
    setState(() {
      _pickedPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecione...'),
        actions: [
          if (!widget.isReadonly)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed:
                  _pickedPosition == null
                      ? null
                      : () {
                          Navigator.of(context).pop(
                            PlaceLocation(
                              latitude: _pickedPosition!.latitude,
                              longitude: _pickedPosition!.longitude,
                              address: '',
                            ),
                          );
                        },
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 13,
        ),
        onTap: widget.isReadonly ? null : _selectPosition,
        markers:
            _pickedPosition == null && !widget.isReadonly
                ? <Marker>{}
                : {
                  Marker(
                    markerId: const MarkerId('p1'),
                    position: _pickedPosition ?? widget.initialLocation.latLng,
                  ),
                },
      ),
    );
  }
}
