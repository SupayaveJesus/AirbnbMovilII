import 'photo_model.dart';

class PlaceModel {
  const PlaceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.guestCapacity,
    required this.pricePerNight,
    required this.photoUrls,
  });

  final int id;
  final String name;
  final String description;
  final String city;
  final int guestCapacity;
  final double pricePerNight;
  final List<String> photoUrls;

  String get firstPhotoUrl => photoUrls.isNotEmpty ? photoUrls.first : '';

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    final rawPhotos =
        json['fotos'] ?? json['photos'] ?? json['imagenes'] ?? json['images'];
    final photoUrls = <String>[];

    if (rawPhotos is List) {
      for (final item in rawPhotos) {
        final photo = PhotoModel.fromDynamic(item);
        if (photo.url.isNotEmpty) {
          photoUrls.add(photo.url);
        }
      }
    } else if (rawPhotos != null) {
      final photo = PhotoModel.fromDynamic(rawPhotos);
      if (photo.url.isNotEmpty) {
        photoUrls.add(photo.url);
      }
    }

    final description =
        _stringOf(json['descripcion'] ?? json['description']) ??
        'Sin descripción disponible.';

    return PlaceModel(
      id: _intOf(json['id']) ?? 0,
      name: _stringOf(json['nombre'] ?? json['name']) ?? 'Lugar sin nombre',
      description: description,
      city: _stringOf(json['ciudad'] ?? json['city']) ?? 'Ciudad no disponible',
      guestCapacity:
          _intOf(
            json['cantPersonas'] ?? json['capacidad'] ?? json['guestCapacity'],
          ) ??
          0,
      pricePerNight:
          _doubleOf(
            json['precioNoche'] ?? json['pricePerNight'] ?? json['precio'],
          ) ??
          0,
      photoUrls: photoUrls,
    );
  }

  static int? _intOf(dynamic value) {
    if (value is int) {
      return value;
    }
    return int.tryParse(value?.toString() ?? '');
  }

  static double? _doubleOf(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '');
  }

  static String? _stringOf(dynamic value) {
    final parsed = value?.toString().trim();
    return (parsed == null || parsed.isEmpty) ? null : parsed;
  }
}
