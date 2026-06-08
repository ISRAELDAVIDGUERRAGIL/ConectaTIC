// Prueba básica de widgets para la app ConectaTIC.
// Aquí se validan la pantalla de bienvenida y la navegación al formulario.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:conectatic_app/main.dart';
import 'package:conectatic_app/providers/auth_provider.dart';
import 'package:conectatic_app/providers/progress_provider.dart';

void main() {
  // Prueba 1: asegura que la pantalla inicial muestra los elementos esperados.
  testWidgets('Splash screen shows ConectaTIC and authentication buttons',
      (WidgetTester tester) async {
    // Create providers similar to main.dart (without awaiting async init for test simplicity)
    final authProvider = AuthProvider();
    // Don't await loadSession() in tests to avoid platform channel issues
    // authProvider.loadSession(); // Skip for now
    
    final progressProvider = ProgressProvider();
    // progressProvider.loadProgress(); // Skip for now

    // Construye la aplicación con los providers necesarios
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<ProgressProvider>.value(value: progressProvider),
      ],
      child: const ConectaTICApp(),
    ));

    // Busca el texto principal de la pantalla de bienvenida.
    expect(find.text('ConectaTIC'), findsOneWidget);

    // Busca la descripción de la pantalla de inicio (texto actual de la app).
    expect(
        find.text(
            'Tu guía digital para aprender tecnología desde cero'),
        findsOneWidget);

    // Busca los botones de autenticación.
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Crear cuenta'), findsOneWidget);

    // Busca la descripción inferior.
    expect(
        find.text(
            'Aprende a usar tu celular, WhatsApp, correo electrónico e internet de forma fácil y divertida'),
        findsOneWidget);

    // Busca el ícono principal.
    expect(find.byIcon(Icons.school_rounded), findsOneWidget);
  });

  // Prueba 2: comprueba que al tocar el botón "Crear cuenta" se navega al registro.
  testWidgets('Tap Crear cuenta navigates to RegisterScreen',
      (WidgetTester tester) async {
    // Create providers for this test
    final authProvider = AuthProvider();
    // Don't await loadSession() in tests to avoid platform channel issues
    // authProvider.loadSession(); // Skip for now
    
    final progressProvider = ProgressProvider();
    // progressProvider.loadProgress(); // Skip for now

    // Construye la aplicación de nuevo para esta prueba aislada con providers
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<ProgressProvider>.value(value: progressProvider),
      ],
      child: const ConectaTICApp(),
    ));

    // Simula un tap en el botón con texto 'Crear cuenta'.
    await tester.tap(find.text('Crear cuenta'));

    // Espera a que terminen todas las animaciones y la navegación.
    await tester.pumpAndSettle();

    // Verifica que la pantalla de registro se haya mostrado correctamente.
    expect(find.text('¡Únete a ConectaTIC! 🎉'), findsOneWidget);

    // Verifica que el subtítulo de registro aparezca.
    expect(
        find.text('Crea tu cuenta para empezar a aprender'),
        findsOneWidget);

    // Verifica que exista el campo de texto para el nombre completo.
    expect(
        find.widgetWithText(TextFormField, 'Nombre completo'), findsOneWidget);

    // Verifica que exista el campo de texto para el correo.
    expect(find.widgetWithText(TextFormField, 'Correo electrónico'),
        findsOneWidget);

    // Verifica que exista el campo de texto para la contraseña.
    expect(find.widgetWithText(TextFormField, 'Contraseña'),
        findsOneWidget);
  });
}
