import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/place_model.dart';
import '../../widgets/place_card.dart';

class PlaceResultsList extends StatelessWidget {
  const PlaceResultsList({
    super.key,
    required this.places,
    required this.city,
    required this.guests,
  });

  final List<PlaceModel> places;
  final String city;
  final int guests;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        GlassCard(
          child: Row(
            children: [
              const Icon(Icons.place_outlined, color: AppTheme.secondary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '$city · $guests huéspedes · ${places.length} resultados',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        ...places.map(
          (place) => Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: PlaceCard(place: place),
          ),
        ),
      ],
    );
  }
}

class ResultStateView extends StatelessWidget {
  const ResultStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: GlassCard(
          highlighted: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 42, color: AppTheme.secondary),
              const SizedBox(height: 16),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 18),
              FilledButton(onPressed: onPressed, child: Text(actionLabel)),
            ],
          ),
        ),
      ),
    );
  }
}
