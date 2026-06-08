import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../models/place_model.dart';

class PlaceService {
  PlaceService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  Future<List<PlaceModel>> searchPlaces({
    required String city,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guests,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.searchPlaces,
        data: {
          'search': city,
          'ciudad': city,
          'fechaInicio': _formatDate(checkIn),
          'fechaFin': _formatDate(checkOut),
          'cantPersonas': guests,
          'huespedes': guests,
        },
      );

      final items = _extractList(response.data);
      return items
          .whereType<Map>()
          .map((item) => item.map((k, v) => MapEntry(k.toString(), v)))
          .map(PlaceModel.fromJson)
          .toList();
    } on DioException catch (error) {
      final data = error.response?.data;
      if (data is String && data.contains('<html')) {
        throw Exception(
          'La búsqueda no respondió correctamente. Intenta con otra ciudad o verifica la API.',
        );
      }
      throw Exception('No se pudo completar la búsqueda en este momento.');
    }
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) {
      return data;
    }

    if (data is Map) {
      final normalized = data.map(
        (key, value) => MapEntry(key.toString(), value),
      );
      final candidate =
          normalized['data'] ??
          normalized['results'] ??
          normalized['lugares'] ??
          normalized['places'];
      if (candidate is List) {
        return candidate;
      }
    }

    return const [];
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
