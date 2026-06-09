/// Valores constantes y configuración global de la aplicación.
class AppConstants {
  AppConstants._();

  // URL base para el backend (producción con Railway).
  static String get apiBaseUrl {
    return 'https://conectatic-production.up.railway.app/api';
  }

  // Claves para SharedPreferences.
  static const authTokenKey = 'conectatic_auth_token';
  static const authUserKey = 'conectatic_auth_user';
}
