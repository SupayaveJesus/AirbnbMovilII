import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/place_model.dart';

class DetailPlacesScreen extends StatelessWidget {
  const DetailPlacesScreen({super.key, required this.place});

  final PlaceModel place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vista rápida')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: AspectRatio(
              aspectRatio: 1.3,
              child: place.firstPhotoUrl.isEmpty
                  ? Container(
                      color: const Color(0xFF182544),
                      alignment: Alignment.center,
                      child: Text(
                        place.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    )
                  : Image.network(
                      place.firstPhotoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFF182544),
                        alignment: Alignment.center,
                        child: Text(
                          place.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 20),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(place.description),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _InfoChip(icon: Icons.place_outlined, label: place.city),
                    _InfoChip(
                      icon: Icons.group_outlined,
                      label: '${place.guestCapacity} huéspedes',
                    ),
                    _InfoChip(
                      icon: Icons.attach_money_rounded,
                      label: '${place.pricePerNight.toStringAsFixed(0)}/noche',
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  'Pantalla resumida para la demo. El detalle completo queda fuera del primer slice.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: AppTheme.glassBoxDecoration(
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.secondary),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
