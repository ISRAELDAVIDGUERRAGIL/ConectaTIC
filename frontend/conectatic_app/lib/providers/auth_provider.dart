import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

/// Provider que gestiona el estado de autenticación global.
class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  String? _token;
  bool _isLoading = false;

  UserModel? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString(AppConstants.authTokenKey);
    final savedUser = prefs.getString(AppConstants.authUserKey);

    if (savedToken != null && savedUser != null) {
      _token = savedToken;
      _user = UserModel.fromJson(jsonDecode(savedUser) as Map<String, dynamic>);
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> login({
    required String correo,
    required String password,
  }) async {
    _setLoading(true);
    final result = await AuthService.login(correo: correo, password: password);

    if (result['success'] == true) {
      final data = result['data'] as Map<String, dynamic>;
      _token = data['token'] as String;
      _user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
      await _saveSession();
      _setLoading(false);
      return result;
    }

    _setLoading(false);
    return result;
  }

  Future<Map<String, dynamic>> register({
    required String nombre,
    required String correo,
    required String password,
  }) async {
    _setLoading(true);
    final result = await AuthService.register(
      nombre: nombre,
      correo: correo,
      password: password,
    );

    _setLoading(false);
    return result;
  }

  /// Actualizar progreso del usuario en la base de datos
  Future<bool> updateProgress(int incremento) async {
    if (_token == null) return false;

    final result = await UserService.updateProgress(
      token: _token!,
      incremento: incremento,
    );

    if (result['success'] == true) {
      // Actualizar el progreso local
      if (_user != null) {
        final nuevoProgreso = result['data']['progreso'] as int? ?? _user!.progreso;
        _user = UserModel(
          id: _user!.id,
          nombre: _user!.nombre,
          correo: _user!.correo,
          progreso: nuevoProgreso,
        );
        await _saveSession();
        notifyListeners();
      }
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.authTokenKey);
    await prefs.remove(AppConstants.authUserKey);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.authTokenKey, _token ?? '');
    await prefs.setString(
        AppConstants.authUserKey, jsonEncode(_user?.toJson()));
  }
}
