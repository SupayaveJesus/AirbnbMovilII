import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../models/auth_result.dart';
import '../models/user_model.dart';

class AuthService {
  AuthService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.clientLogin,
        data: {'email': email, 'password': password},
      );

      return _parseAuthResult(
        response.data,
        fallbackUser: UserModel(email: email),
        fallbackMessage: 'Inicio de sesión exitoso.',
      );
    } on DioException catch (error) {
      throw Exception(
        _readableError(error, fallback: 'No se pudo iniciar sesión.'),
      );
    }
  }

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.clientRegister,
        data: {
          'nombrecompleto': name,
          'telefono': phone,
          'email': email,
          'password': password,
          'name': name,
          'phone': phone,
        },
      );

      return _parseAuthResult(
        response.data,
        fallbackUser: UserModel(name: name, email: email, phone: phone),
        fallbackMessage: 'Registro exitoso.',
      );
    } on DioException catch (error) {
      throw Exception(
        _readableError(error, fallback: 'No se pudo completar el registro.'),
      );
    }
  }

  AuthResult _parseAuthResult(
    dynamic data, {
    required UserModel fallbackUser,
    required String fallbackMessage,
  }) {
    final map = _normalizeMap(data);
    final userMap = _normalizeMap(
      map['user'] ?? map['cliente'] ?? map['data'] ?? map['usuario'],
    );

    final user = userMap.isNotEmpty
        ? UserModel.fromJson(userMap)
        : fallbackUser;
    final token = (map['token'] ?? map['access_token'] ?? map['jwt'] ?? '')
        .toString();
    final message = (map['message'] ?? map['mensaje'] ?? fallbackMessage)
        .toString();

    return AuthResult(
      user: UserModel(
        id: user.id ?? fallbackUser.id,
        name: user.name ?? fallbackUser.name,
        email: user.email ?? fallbackUser.email,
        phone: user.phone ?? fallbackUser.phone,
      ),
      token: token,
      message: message,
    );
  }

  Map<String, dynamic> _normalizeMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    return <String, dynamic>{};
  }

  String _readableError(DioException error, {required String fallback}) {
    final data = error.response?.data;
    if (data is Map) {
      final normalized = data.map(
        (key, value) => MapEntry(key.toString(), value),
      );
      final message = normalized['message'] ?? normalized['mensaje'];
      if (message != null && message.toString().trim().isNotEmpty) {
        return message.toString();
      }

      final fieldMessages = <String>[];
      for (final value in normalized.values) {
        if (value is List && value.isNotEmpty) {
          fieldMessages.add(value.first.toString());
        } else if (value is String && value.trim().isNotEmpty) {
          fieldMessages.add(value);
        }
      }
      if (fieldMessages.isNotEmpty) {
        return fieldMessages.first;
      }
    }

    if (data is String && !data.contains('<html')) {
      return data;
    }

    return fallback;
  }
}
