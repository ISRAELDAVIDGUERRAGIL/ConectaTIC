import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../providers/auth_provider.dart';

/// ============================================================
/// PANTALLA: ProgressScreen
/// PROPÓSITO: Mostrar el progreso del usuario
/// ESTILO: Gamificado, moderno, limpio
/// ============================================================

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener usuario del provider
    final user = context.watch<AuthProvider>().user;
    final progreso = user?.progreso ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text('Mi progreso'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título principal
            Text(
              '¡Mira tu avance! 📊',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3C3C3C),
              ),
            ).animate().fade(duration: 400.ms),
            
            const SizedBox(height: 32),

            // Card de progreso principal
            _buildMainProgressCard(context, progreso)
                .animate()
                .fade(delay: 100.ms, duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
            
            const SizedBox(height: 32),

            // Título de logros
            Row(
              children: [
                const Icon(Icons.emoji_events_rounded, 
                  color: Color(0xFFFFC800), size: 28),
                const SizedBox(width: 10),
                Text(
                  'Logros',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3C3C3C),
                  ),
                ),
              ],
            ).animate().fade(delay: 200.ms, duration: 400.ms),
            
            const SizedBox(height: 16),

            // Grid de logros
            _buildAchievementsGrid(context, progreso)
                .animate()
                .fade(delay: 300.ms, duration: 400.ms),
            
            const SizedBox(height: 32),

            // Mensaje motivacional
            _buildMotivationalCard(context, progreso)
                .animate()
                .fade(delay: 400.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }

  /// Card principal de progreso
  Widget _buildMainProgressCard(BuildContext context, int progreso) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF58CC02), Color(0xFF46A302)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF58CC02).withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icono grande de trofeo
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              size: 64,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          
          // Porcentaje grande
          Text(
            '$progreso%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'de progreso completado',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          
          // Barra de progreso
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progreso / 100,
              minHeight: 14,
              backgroundColor: Colors.white.withOpacity(0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          
          // XP ganado
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, color: Color(0xFFFFC800), size: 24),
                const SizedBox(width: 8),
                Text(
                  '+${progreso * 10} XP ganados',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Grid de logros
  Widget _buildAchievementsGrid(BuildContext context, int progreso) {
    final achievements = [
      {
        'title': 'Primer paso',
        'icon': Icons.flag_rounded,
        'unlocked': progreso > 0,
        'color': const Color(0xFF58CC02),
      },
      {
        'title': 'Mitad camino',
        'icon': Icons.trending_up_rounded,
        'unlocked': progreso >= 50,
        'color': const Color(0xFF1CB0F6),
      },
      {
        'title': 'Casi listo',
        'icon': Icons.school_rounded,
        'unlocked': progreso >= 75,
        'color': const Color(0xFFFFC800),
      },
      {
        'title': 'Completado',
        'icon': Icons.emoji_events_rounded,
        'unlocked': progreso >= 100,
        'color': const Color(0xFF58CC02),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.3,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        final unlocked = achievement['unlocked'] as bool;
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: unlocked 
                ? (achievement['color'] as Color).withOpacity(0.15)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: unlocked 
                  ? (achievement['color'] as Color)
                  : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                achievement['icon'] as IconData,
                size: 36,
                color: unlocked 
                    ? (achievement['color'] as Color)
                    : Colors.grey.shade400,
              ),
              const SizedBox(height: 8),
              Text(
                achievement['title'] as String,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: unlocked 
                      ? const Color(0xFF3C3C3C)
                      : Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Icon(
                unlocked ? Icons.check_circle : Icons.lock_outline,
                size: 18,
                color: unlocked 
                    ? const Color(0xFF58CC02)
                    : Colors.grey.shade400,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Card motivacional
  Widget _buildMotivationalCard(BuildContext context, int progreso) {
    String message;
    IconData icon;
    
    if (progreso == 0) {
      message = '¡Comienza tu viaje de aprendizaje! Tu primera lección te espera.';
      icon = Icons.rocket_launch_rounded;
    } else if (progreso < 25) {
      message = '¡Buen inicio! Estás en el camino correcto. Continúa así 🚀';
      icon = Icons.thumb_up_rounded;
    } else if (progreso < 50) {
      message = '¡Excelente progreso! Estás muy bien. Sigue adelante 💪';
      icon = Icons.trending_up_rounded;
    } else if (progreso < 75) {
      message = '¡Muy bien! Ya pasaste la mitad. El esfuerzo vale la pena 🌟';
      icon = Icons.star_rounded;
    } else if (progreso < 100) {
      message = '¡Casi llegas! Un último esfuerzo para completar todo 🎯';
      icon = Icons.flag_rounded;
    } else {
      message = '¡Felicidades! Has completado todos los módulos. ¡Eres un experto! 🎉';
      icon = Icons.celebration_rounded;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF58CC02).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF58CC02), size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF3C3C3C),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}