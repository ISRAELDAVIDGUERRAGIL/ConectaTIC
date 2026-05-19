import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

/// Servicio de autenticación que conecta con el backend.
class AuthService {
  AuthService._();

  static Future<Map<String, dynamic>> login({
    required String correo,
    required String password,
  }) async {
    try {
      final response = await ApiService.post(
        '/auth/login',
        body: {
          'correo': correo,
          'password': password,
        },
      );

      return _parseResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'No se pudo conectar al servidor. Intenta de nuevo.',
        'error': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> register({
    required String nombre,
    required String correo,
    required String password,
  }) async {
    try {
      final response = await ApiService.post(
        '/auth/register',
        body: {
          'nombre': nombre,
          'correo': correo,
          'password': password,
        },
      );

      return _parseResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'No se pudo conectar al servidor. Intenta de nuevo.',
        'error': e.toString(),
      };
    }
  }

  static Map<String, dynamic> _parseResponse(http.Response response) {
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return {
        'success': true,
        'data': decoded['data'] ?? decoded,
        'message': decoded['message'] ?? 'Operación exitosa',
      };
    }

    return {
      'success': false,
      'message': decoded['message'] ?? 'Error en el servidor',
      'errors': decoded['errors'],
    };
  }
}
