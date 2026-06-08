import 'package:flutter/material.dart';

import '../../models/place_model.dart';
import '../../services/place_service.dart';
import 'list_places_screen.dart';

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({
    super.key,
    required this.city,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
  });

  final String city;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  final PlaceService _placeService = PlaceService();
  late Future<List<PlaceModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<PlaceModel>> _load() {
    return _placeService.searchPlaces(
      city: widget.city,
      checkIn: widget.checkIn,
      checkOut: widget.checkOut,
      guests: widget.guests,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultados')),
      body: FutureBuilder<List<PlaceModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ResultStateView(
              icon: Icons.cloud_off_rounded,
              title: 'No pudimos cargar los resultados',
              message: snapshot.error.toString().replaceFirst(
                'Exception: ',
                '',
              ),
              actionLabel: 'Reintentar',
              onPressed: () => setState(() => _future = _load()),
            );
          }

          final places = snapshot.data ?? const [];
          if (places.isEmpty) {
            return ResultStateView(
              icon: Icons.search_off_rounded,
              title: 'Sin resultados',
              message:
                  'No encontramos lugares para ${widget.city}. Prueba otra ciudad o cambia las fechas.',
              actionLabel: 'Volver',
              onPressed: () => Navigator.of(context).pop(),
            );
          }

          return PlaceResultsList(
            places: places,
            city: widget.city,
            guests: widget.guests,
          );
        },
      ),
    );
  }
}
