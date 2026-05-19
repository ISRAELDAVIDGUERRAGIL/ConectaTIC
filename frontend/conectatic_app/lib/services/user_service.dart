import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

/// Servicio para gestionar datos del usuario
class UserService {
  UserService._();

  /// Actualizar progreso del usuario
  /// Returns: { success: bool, data: { progreso: number }, message: string }
  static Future<Map<String, dynamic>> updateProgress({
    required String token,
    required int incremento,
  }) async {
    final response = await ApiService.put(
      '/usuarios/progreso',
      body: {'incremento': incremento},
      token: token,
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return {
        'success': true,
        'data': decoded['data'] ?? decoded,
        'message': decoded['message'] ?? 'Progreso actualizado',
      };
    }

    return {
      'success': false,
      'message': decoded['message'] ?? 'Error al actualizar progreso',
    };
  }
}