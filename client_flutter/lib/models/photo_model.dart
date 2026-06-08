import '../core/constants/api_constants.dart';

class PhotoModel {
  const PhotoModel({required this.url});

  final String url;

  factory PhotoModel.fromDynamic(dynamic value) {
    if (value is Map<String, dynamic>) {
      final raw =
          value['url'] ?? value['foto'] ?? value['path'] ?? value['imagen'];
      return PhotoModel(url: _normalizeUrl(raw?.toString() ?? ''));
    }
    return PhotoModel(url: _normalizeUrl(value?.toString() ?? ''));
  }

  static String _normalizeUrl(String raw) {
    if (raw.isEmpty) {
      return '';
    }
    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return raw;
    }
    if (raw.startsWith('/')) {
      return '${ApiConstants.mediaHost}$raw';
    }
    return '${ApiConstants.mediaHost}/$raw';
  }
}
