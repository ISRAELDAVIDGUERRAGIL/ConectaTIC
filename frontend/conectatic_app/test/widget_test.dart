// Prueba básica de widgets para la app ConectaTIC.
// Aquí se validan la pantalla de bienvenida y la navegación al formulario.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:conectatic_app/main.dart';

void main() {
  // Prueba 1: asegura que la pantalla inicial muestra los elementos esperados.
  testWidgets('Splash screen shows ConectaTIC and Comenzar button',
      (WidgetTester tester) async {
    // Construye la aplicación y renderiza el primer frame.
    await tester.pumpWidget(const ConectaTICApp());

    // Busca el texto principal de la pantalla de bienvenida.
    expect(find.text('ConectaTIC'), findsOneWidget);

    // Busca la descripción de la pantalla de inicio.
    expect(
        find.text(
            'Aprende a usar tu celular, WhatsApp, correo e Internet paso a paso.'),
        findsOneWidget);

    // Busca el botón que inicia la navegación.
    expect(find.text('Comenzar'), findsOneWidget);

    // Busca el ícono de teléfono en la pantalla de bienvenida.
    expect(find.byIcon(Icons.phone_android_rounded), findsOneWidget);
  });

  // Prueba 2: comprueba que al tocar el botón "Comenzar" se navega al registro.
  testWidgets('Tap Comenzar navigates to RegisterUserScreen',
      (WidgetTester tester) async {
    // Construye la aplicación de nuevo para esta prueba aislada.
    await tester.pumpWidget(const ConectaTICApp());

    // Simula un tap en el botón con texto 'Comenzar'.
    await tester.tap(find.text('Comenzar'));

    // Espera a que terminen todas las animaciones y la navegación.
    await tester.pumpAndSettle();

    // Verifica que la pantalla de registro se haya mostrado correctamente.
    expect(find.text('Registro rápido'), findsOneWidget);

    // Verifica que el texto de introducción del registro aparezca.
    expect(
        find.text('Antes de empezar, cuéntanos quién eres.'), findsOneWidget);

    // Verifica que exista el campo de texto para el nombre completo.
    expect(
        find.widgetWithText(TextFormField, 'Nombre completo'), findsOneWidget);

    // Verifica que exista el campo de texto para el correo.
    expect(find.widgetWithText(TextFormField, 'Correo (si tienes)'),
        findsOneWidget);

    // Verifica que exista el campo de texto para la contraseña.
    expect(find.widgetWithText(TextFormField, 'Contraseña sencilla'),
        findsOneWidget);
  });
}
