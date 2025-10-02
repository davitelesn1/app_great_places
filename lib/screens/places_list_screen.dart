import 'package:app_great_places/providers/great_places.dart';
import 'package:app_great_places/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('My Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.PLACE_FORM);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false).loadPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator())
            : Consumer <GreatPlaces>(
          child: const Center(
            child: Text('No places added yet. Start adding some!'),
          ),
          builder: (ctx, greatPlaces, ch) => greatPlaces.itemsCount == 0
              ? ch!
              : ListView.separated(
                  itemCount: greatPlaces.itemsCount,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final place = greatPlaces.itemByIndex(i);
                    return Dismissible(
                      key: ValueKey(place.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        color: Colors.red.shade700,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Remover este lugar?'),
                            content: const Text('Esta ação não pode ser desfeita.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: const Text('Remover'),
                              ),
                            ],
                          ),
                        ) ?? false;
                      },
                      onDismissed: (_) {
                        Provider.of<GreatPlaces>(context, listen: false)
                            .deletePlace(place.id);
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: FileImage(place.image),
                        ),
                        title: Text(place.title),
                        subtitle: Text(
                          place.location?.address ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.PLACE_DETAIL,
                            arguments: place,
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}