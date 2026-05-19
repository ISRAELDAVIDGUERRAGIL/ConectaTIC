import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';

/// Servicio HTTP que centraliza las llamadas al backend.
class ApiService {
  ApiService._();

  static final _client = http.Client();

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

    return await _client.post(
      uri,
      headers: headers,
      body: jsonEncode(body ?? {}),
    ).timeout(const Duration(seconds: 30));
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

    return await _client.put(
      uri,
      headers: headers,
      body: jsonEncode(body ?? {}),
    ).timeout(const Duration(seconds: 30));
  }
}
