import 'dart:io';

/// Valores constantes y configuración global de la aplicación.
class AppConstants {
  AppConstants._();

  // URL base para el backend según plataforma.
  static String get apiBaseUrl {
    if (Platform.isAndroid) {
      return 'http://192.168.1.4:3000/api';
    }
    return 'http://127.0.0.1:3000/api';
  }

  // Claves para SharedPreferences.
  static const authTokenKey = 'conectatic_auth_token';
  static const authUserKey = 'conectatic_auth_user';
}
