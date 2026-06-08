import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../models/place_model.dart';
import '../screens/places/detail_places_screen.dart';
import '../screens/reservations/confirm_reservation_screen.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard({super.key, required this.place});

  final PlaceModel place;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => DetailPlacesScreen(place: place),
          ),
        );
      },
      child: Container(
        decoration: AppTheme.glassBoxDecoration(
          borderRadius: BorderRadius.circular(28),
          highlighted: true,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: AspectRatio(
                aspectRatio: 1.45,
                child: place.firstPhotoUrl.isEmpty
                    ? _FallbackImage(title: place.name)
                    : Image.network(
                        place.firstPhotoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _FallbackImage(title: place.name),
                      ),
              ),
            ),
            const SizedBox(height: 14),
            Text(place.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              place.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.group_outlined,
                  size: 18,
                  color: AppTheme.secondary,
                ),
                const SizedBox(width: 6),
                Text('${place.guestCapacity} huéspedes'),
                const Spacer(),
                Text(
                  '\$${place.pricePerNight.toStringAsFixed(0)}/noche',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ConfirmReservationScreen(place: place),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                side: BorderSide(
                  color: AppTheme.secondary.withValues(alpha: 0.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              icon: const Icon(Icons.visibility_outlined),
              label: const Text('Ver lugar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FallbackImage extends StatelessWidget {
  const _FallbackImage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF172033), Color(0xFF24314B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
