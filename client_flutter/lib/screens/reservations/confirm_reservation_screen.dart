import 'package:flutter/material.dart';

import '../../models/place_model.dart';

class ConfirmReservationScreen extends StatelessWidget {
  const ConfirmReservationScreen({super.key, required this.place});

  final PlaceModel place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reserva fuera de alcance')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'La reserva completa no forma parte de esta entrega. Se dejó una vista rápida para sostener la demo desde resultados hacia adelante: ${place.name}.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
