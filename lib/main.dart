import 'package:app_great_places/providers/great_places.dart';
import 'package:app_great_places/screens/place_detail_screen.dart';
import 'package:app_great_places/screens/place_form_screen.dart';
import 'package:app_great_places/screens/places_list_screen.dart';
import 'package:app_great_places/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => GreatPlaces()..loadPlaces(),
      child: MaterialApp(
        title: 'App Great Places',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 18, 118, 143),
          secondaryHeaderColor: const Color.fromARGB(255, 70, 162, 185),
          appBarTheme: const AppBarTheme(centerTitle: true),
        ),
        home: const PlacesListScreen(),
        routes: {
          AppRoutes.PLACE_FORM: (ctx) => const PlaceFormScreen(),
          AppRoutes.PLACE_DETAIL: (ctx) => const PlaceDetailScreen(),
        }
      ),
    );
  }
}
