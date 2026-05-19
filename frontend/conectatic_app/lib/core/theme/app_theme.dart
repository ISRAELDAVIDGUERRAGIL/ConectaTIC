import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ============================================================
/// ARCHIVO: app_theme.dart
/// PROPÓSITO: Tema global de ConectaTIC con estilo moderno gamificado
/// ESTILO: Inspirado en Duolingo, Platzi, Notion, Coursera
/// COLORES: Verde educativo, acentos azules, amarillo XP
/// ============================================================

class AppTheme {
  AppTheme._();

  // ============================================================
  // PALETA DE COLORES OFICIAL
  // ============================================================
  
  /// Verde primario - Color principal de la marca
  static const Color primaryGreen = Color(0xFF58CC02);
  
  /// Verde oscuro - Para estados activos y énfasis
  static const Color darkGreen = Color(0xFF46A302);
  
  /// Azul acento - Para secundarios y acentos
  static const Color blueAccent = Color(0xFF1CB0F6);
  
  /// Color de fondo - Fondo general de la app
  static const Color backgroundColor = Color(0xFFF7F7F7);
  
  /// Color de tarjetas - Fondo blanco para cards
  static const Color surfaceColor = Color(0xFFFFFFFF);
  
  /// Color de texto principal - Gris oscuro para texto
  static const Color textColor = Color(0xFF3C3C3C);
  
  /// Color de error - Rojo para errores y alertas
  static const Color errorRed = Color(0xFFFF4B4B);
  
  /// Amarillo XP - Para puntos y logros
  static const Color xpYellow = Color(0xFFFFC800);
  
  /// Color primario legacy (mantener compatibilidad)
  static const Color primaryColor = primaryGreen;
  static const Color secondaryColor = blueAccent;

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          bodyLarge: TextStyle(color: textColor, fontSize: 18),
          bodyMedium: TextStyle(color: textColor, fontSize: 16),
          bodySmall: TextStyle(color: textColor, fontSize: 14),
          headlineLarge: TextStyle(color: textColor, fontSize: 28),
          headlineMedium: TextStyle(color: textColor, fontSize: 24),
          headlineSmall: TextStyle(color: textColor, fontSize: 22),
          titleLarge: TextStyle(color: textColor, fontSize: 22),
          titleMedium: TextStyle(color: textColor, fontSize: 18),
          titleSmall: TextStyle(color: textColor, fontSize: 16),
          labelLarge: TextStyle(color: textColor, fontSize: 16),
          labelMedium: TextStyle(color: textColor, fontSize: 14),
          labelSmall: TextStyle(color: textColor, fontSize: 12),
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: surfaceColor,
        foregroundColor: textColor,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(size: 26),
      ),
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size.fromHeight(56),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGreen,
          side: const BorderSide(color: primaryGreen, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size.fromHeight(56),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE5E5E5), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE5E5E5), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),
        labelStyle: TextStyle(fontSize: 16, color: textColor.withOpacity(0.7)),
        hintStyle: TextStyle(fontSize: 16, color: textColor.withOpacity(0.4)),
      ),
      iconTheme: const IconThemeData(size: 24),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: primaryGreen,
        contentTextStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
