import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// ============================================================
/// PANTALLA: AuthChoiceScreen (Bienvenida)
/// PROPÓSITO: Pantalla inicial de autenticación
/// ESTILO: Gamificado, moderno, limpio
/// ============================================================

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo / Icono principal con animación
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF58CC02).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  size: 64,
                  color: Color(0xFF58CC02),
                ),
              )
                  .animate()
                  .fade(duration: 600.ms)
                  .scale(delay: 200.ms, duration: 400.ms),
              
              const SizedBox(height: 32),
              
              // Título principal
              Text(
                'ConectaTIC',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF3C3C3C),
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fade(delay: 300.ms, duration: 500.ms)
                  .slideY(begin: 0.3, end: 0),
              
              const SizedBox(height: 12),
              
              // Subtítulo
              Text(
                'Tu guía digital para aprender tecnología desde cero',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF3C3C3C).withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fade(delay: 400.ms, duration: 500.ms),
              
              const SizedBox(height: 48),
              
              // Botón primario - Iniciar sesión
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.login_rounded, size: 24),
                  label: const Text('Iniciar sesión'),
                  onPressed: () => context.go('/login'),
                ),
              )
                  .animate()
                  .fade(delay: 500.ms, duration: 400.ms)
                  .slideY(begin: 0.3, end: 0),
              
              const SizedBox(height: 16),
              
              // Botón secundario - Crear cuenta
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.person_add_rounded, size: 24),
                  label: const Text('Crear cuenta'),
                  onPressed: () => context.go('/register'),
                ),
              )
                  .animate()
                  .fade(delay: 600.ms, duration: 400.ms)
                  .slideY(begin: 0.3, end: 0),
              
              const SizedBox(height: 40),
              
              // Descripción inferior
              Text(
                'Aprende a usar tu celular, WhatsApp, correo electrónico e internet de forma fácil y divertida',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF3C3C3C).withOpacity(0.6),
                ),
              )
                  .animate()
                  .fade(delay: 700.ms, duration: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}
