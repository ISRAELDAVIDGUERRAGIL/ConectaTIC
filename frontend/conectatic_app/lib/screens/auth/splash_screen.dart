import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

/// ============================================================
/// PANTALLA: SplashScreen (Pantalla de carga)
/// PROPÓSITO: Pantalla inicial mientras carga la app
/// ESTILO: Gamificado, moderno, limpio
/// ============================================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navegar después de 2 segundos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        
        // Verificar si el usuario ya está autenticado
        final authProvider = context.read<AuthProvider>();
        if (authProvider.isAuthenticated) {
          context.go('/home');
          return;
        }
        
        // Si no está autenticado,-ir al onboarding o auth
        // Por ahora vamos directo a auth
        context.go('/auth');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF58CC02),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo animado
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.school_rounded,
                size: 80,
                color: Colors.white,
              ),
            )
                .animate()
                .fade(duration: 600.ms)
                .scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut),
            
            const SizedBox(height: 32),
            
            // Nombre de la app
            Text(
              'ConectaTIC',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ).animate()
                .fade(duration: 500.ms, delay: 400.ms)
                .slideY(begin: 0.3, end: 0),
            
            const SizedBox(height: 12),
            
            // Subtítulo
            Text(
              'Aprende tecnología desde cero',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withOpacity(0.85),
                fontSize: 16,
              ),
            ).animate()
                .fade(duration: 500.ms, delay: 600.ms),
            
            const SizedBox(height: 48),
            
            // Indicador de carga
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: Colors.white.withOpacity(0.7),
                strokeWidth: 3,
              ),
            ).animate()
                .fade(duration: 400.ms, delay: 800.ms),
          ],
        ),
      ),
    );
  }
}