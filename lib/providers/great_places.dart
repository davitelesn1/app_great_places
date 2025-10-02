import 'dart:io';

import 'package:app_great_places/models/place.dart';
import 'package:app_great_places/utils/db_util.dart';
import 'package:app_great_places/utils/location_util.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GreatPlaces with ChangeNotifier {
  final List<Place> _items = [];

  Future<void> loadPlaces() async {
    final dataList = await DbUtil.getData('places');

    _items.clear();
    _items.addAll(
      dataList.map(
        (item) {
          final lat = item['lat'];
          final lng = item['lng'];
          final address = item['address'];

          PlaceLocation? location;
          if (lat != null && lng != null && address != null) {
            location = PlaceLocation(
              latitude: (lat as num).toDouble(),
              longitude: (lng as num).toDouble(),
              address: address as String,
            );
          }

          return Place(
            id: item['id'] as String,
            title: item['title'] as String,
            image: File(item['image'] as String),
            location: location,
          );
        },
      ),
    );

    notifyListeners();
  }

  List<Place> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Place itemByIndex(int index) {
    return _items[index];
  }

  Future<void> addPlace(String title, File image, LatLng position) async {

    String address = await LocationUtil.getAddressFrom(position);

    final newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      image: image,
      location: PlaceLocation(latitude: position.latitude, longitude: position.longitude, address: address),
    );

    _items.add(newPlace);

    await DbUtil.insert('places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': position.latitude,
      'lng': position.longitude,
      'address': address,
    });

    notifyListeners();
  }

  Future<void> deletePlace(String id) async {
    _items.removeWhere((p) => p.id == id);
    notifyListeners();
    await DbUtil.delete('places', id);
  }

  Future<void> updatePlace({
    required String id,
    String? title,
    LatLng? position,
  }) async {
    final index = _items.indexWhere((p) => p.id == id);
    if (index < 0) return;

    var current = _items[index];
    String newTitle = title ?? current.title;

    PlaceLocation? newLocation = current.location;
    String? address;
    if (position != null) {
      address = await LocationUtil.getAddressFrom(position);
      newLocation = PlaceLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      );
    }

    final updated = Place(
      id: current.id,
      title: newTitle,
      image: current.image,
      location: newLocation,
    );
    _items[index] = updated;
    notifyListeners();

    await DbUtil.update('places', {
      'id': updated.id,
      'title': updated.title,
      'image': updated.image.path,
      'lat': updated.location?.latitude,
      'lng': updated.location?.longitude,
      'address': updated.location?.address,
    });
  }
}
