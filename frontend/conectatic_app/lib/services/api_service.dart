import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';

/// Servicio HTTP que centraliza las llamadas al backend.
class ApiService {
  ApiService._();

  static final _client = http.Client();

  // Instancia singleton
  static late ApiService _instance;

  static ApiService get instance {
    _instance = ApiService._();
    return _instance;
  }

  static Future<http.Response> post(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final cleanedPath = path.startsWith('/') ? path.substring(1) : path;
    final uri = Uri.parse('${AppConstants.apiBaseUrl}/$cleanedPath');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    return await _client
        .post(
          uri,
          headers: headers,
          body: jsonEncode(body ?? {}),
        )
        .timeout(const Duration(seconds: 30));
  }

  static Future<http.Response> put(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final cleanedPath = path.startsWith('/') ? path.substring(1) : path;
    final uri = Uri.parse('${AppConstants.apiBaseUrl}/$cleanedPath');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    return await _client
        .put(
          uri,
          headers: headers,
          body: jsonEncode(body ?? {}),
        )
        .timeout(const Duration(seconds: 30));
  }

  /// 📊 Actualiza el progreso del usuario en el servidor
  Future<void> updateUserProgress(int progressPercentage) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Token no encontrado');
      }

      final response = await put(
        'usuarios/progreso',
        body: {'progreso': progressPercentage},
        token: token,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error actualizando progreso: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
