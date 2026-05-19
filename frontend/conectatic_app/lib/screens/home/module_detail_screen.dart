import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../providers/progress_provider.dart';

/// ============================================================
/// PANTALLA: ModuleDetailScreen
/// PROPÓSITO: Mostrar detalles de un módulo con opciones de continuar
/// ESTILO: Gamificado, moderno, limpio
/// ============================================================

class ModuleDetailScreen extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final List<Map<String, dynamic>>? content;
  final List<Map<String, dynamic>>? exercises;
  final String? videoPath;

  const ModuleDetailScreen({
    super.key,
    required this.titulo,
    required this.descripcion,
    this.content,
    this.exercises,
    this.videoPath,
  });

  @override
  Widget build(BuildContext context) {
    final moduleInfo = _getModuleInfo(titulo);

    return Consumer<ProgressProvider>(
      builder: (context, progressProvider, child) {
        final progress = progressProvider.getModuleProgress(titulo);
        final hasProgress = progress != null && progress.lessonIndex > 0;
        final isCompleted = progressProvider.isModuleCompleted(titulo);

        return Scaffold(
          backgroundColor: const Color(0xFFF7F7F7),
          appBar: AppBar(
            title: Text(titulo),
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
                _buildModuleHeader(context, moduleInfo, isCompleted)
                    .animate()
                    .fade(duration: 400.ms)
                    .slideY(begin: 0.1, end: 0),
                
                const SizedBox(height: 28),

                if (isCompleted)
                  _buildCompletedBadge()
                else if (hasProgress)
                  _buildProgressIndicator(progress!, moduleInfo)
                    .animate()
                    .fade(delay: 100.ms, duration: 400.ms),

                if (!isCompleted) ...[
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    title: '¿Qué aprenderás?',
                    icon: Icons.lightbulb_outline_rounded,
                    child: Text(
                      descripcion,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF3C3C3C).withOpacity(0.8),
                        height: 1.5,
                      ),
                    ),
                  ).animate().fade(delay: 150.ms, duration: 400.ms),

                  if (videoPath != null) ...[
                    const SizedBox(height: 24),
                    _buildVideoButton(context)
                        .animate()
                        .fade(delay: 180.ms, duration: 400.ms),
                  ],
                  
                  const SizedBox(height: 24),
                  _buildLessonsList(context, progress)
                      .animate()
                      .fade(delay: 200.ms, duration: 400.ms),
                ],

                const SizedBox(height: 32),
                _buildActionButtons(context, progressProvider, hasProgress, isCompleted)
                    .animate()
                    .fade(delay: 300.ms, duration: 400.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompletedBadge() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF58CC02).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF58CC02), width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events_rounded, color: Color(0xFFFFC800), size: 32),
          const SizedBox(width: 12),
          const Text(
            '¡Módulo completado!',
            style: TextStyle(
              color: Color(0xFF58CC02),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(ModuleProgress progress, Map<String, dynamic> moduleInfo) {
    final lessons = moduleInfo['lessons'] as List<String>;
    final currentLesson = progress.lessonIndex.clamp(0, lessons.length - 1);
    final percentage = (currentLesson / lessons.length * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tu progreso',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF3C3C3C),
                ),
              ),
              Text(
                '$percentage%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF58CC02),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: currentLesson / lessons.length,
              minHeight: 10,
              backgroundColor: const Color(0xFFEDF1F3),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF58CC02)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Lección ${currentLesson + 1} de ${lessons.length}: ${lessons[currentLesson]}',
            style: const TextStyle(
              color: Color(0xFF787979),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ProgressProvider progressProvider, bool hasProgress, bool isCompleted) {
    return Column(
      children: [
        if (isCompleted) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                progressProvider.resetModule(titulo);
              },
              icon: const Icon(Icons.replay_rounded, size: 24),
              label: const Text('Repetir módulo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC800),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
        ] else ...[
          if (hasProgress) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _startModule(context, progressProvider, continueFromSaved: true),
                icon: const Icon(Icons.play_arrow_rounded, size: 24),
                label: const Text('Continuar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF58CC02),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _startModule(context, progressProvider, continueFromSaved: false),
              icon: Icon(
                hasProgress ? Icons.replay_rounded : Icons.play_arrow_rounded,
                size: 24,
              ),
              label: Text(hasProgress ? 'Comenzar de nuevo' : 'Comenzar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF58CC02),
                side: const BorderSide(color: Color(0xFF58CC02), width: 2),
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: () => context.go('/home'),
            icon: const Icon(Icons.schedule_rounded, size: 20),
            label: const Text('Más tarde'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF787979),
            ),
          ),
        ),
      ],
    );
  }

  void _startModule(BuildContext context, ProgressProvider progressProvider, {required bool continueFromSaved}) {
    if (!continueFromSaved) {
      progressProvider.updateLessonIndex(titulo, 0);
    }

    // Ir directamente a las lecciones (video deshabilitado por compatibilidad)
    context.push('/lesson-content', extra: {
      'titulo': titulo,
      'content': content,
      'exercises': exercises,
    });
  }

  Widget _buildVideoButton(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push('/video-intro', extra: {
          'titulo': titulo,
          'videoPath': videoPath,
          'content': content,
          'exercises': exercises,
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF58CC02), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF58CC02).withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF58CC02).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.play_circle_filled_rounded,
                color: Color(0xFF58CC02),
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ver video introductorio',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF3C3C3C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Aprende lo básico viendo este video',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF3C3C3C).withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF58CC02),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  String? _getVideoPath(String title) {
    switch (title.toLowerCase()) {
      case 'uso del celular':
        return 'assets/videos/modulo1.mp4';
      case 'whatsapp':
        return 'assets/videos/modulo2.mp4';
      default:
        return null;
    }
  }

  Map<String, dynamic> _getModuleInfo(String title) {
    switch (title.toLowerCase()) {
      case 'uso del celular':
        return {
          'icon': Icons.phone_android_rounded,
          'color': const Color(0xFF58CC02),
          'lessons': ['Encender y apagar', 'Navegar por pantalla', 'Ajustes básicos', 'Seguridad'],
        };
      case 'whatsapp':
        return {
          'icon': Icons.chat_bubble_rounded,
          'color': const Color(0xFF25D366),
          'lessons': ['Instalar WhatsApp', 'Enviar mensajes', 'Enviar fotos', 'Notas de voz'],
        };
      case 'correo electrónico':
        return {
          'icon': Icons.email_rounded,
          'color': const Color(0xFF1CB0F6),
          'lessons': ['Crear cuenta', 'Leer correos', 'Responder', 'Adjuntar archivos'],
        };
      case 'internet':
        return {
          'icon': Icons.language_rounded,
          'color': const Color(0xFFFFC800),
          'lessons': ['Qué es internet', 'Navegador', 'Buscar información', 'WiFi'],
        };
      default:
        return {
          'icon': Icons.school_rounded,
          'color': const Color(0xFF58CC02),
          'lessons': ['Lección 1', 'Lección 2', 'Lección 3'],
        };
    }
  }

  Widget _buildModuleHeader(BuildContext context, Map<String, dynamic> moduleInfo, bool isCompleted) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (moduleInfo['color'] as Color),
            (moduleInfo['color'] as Color).withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (moduleInfo['color'] as Color).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              moduleInfo['icon'] as IconData,
              size: 64,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            descripcion,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, color: Color(0xFFFFC800), size: 22),
                const SizedBox(width: 6),
                Text(
                  isCompleted ? '✓ Completado' : '+50 XP',
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

  Widget _buildSection(BuildContext context, {required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF58CC02), size: 24),
              const SizedBox(width: 10),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF3C3C3C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildLessonsList(BuildContext context, ModuleProgress? progress) {
    final lessons = content?.map((c) => c['title']?.toString() ?? '').toList() ?? 
        ['Lección 1', 'Lección 2', 'Lección 3', 'Lección 4'];
    final currentIndex = progress?.lessonIndex ?? 0;

    return _buildSection(
      context,
      title: 'Lecciones',
      icon: Icons.play_circle_outline_rounded,
      child: Column(
        children: lessons.asMap().entries.map((entry) {
          final index = entry.key;
          final lesson = entry.value;
          final isCompleted = progress?.lessonCompleted == true && index < currentIndex;
          final isCurrent = index == currentIndex;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isCurrent 
                  ? const Color(0xFF58CC02).withOpacity(0.1)
                  : const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(14),
              border: isCurrent 
                  ? Border.all(color: const Color(0xFF58CC02), width: 2)
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isCompleted 
                        ? const Color(0xFF58CC02)
                        : const Color(0xFF58CC02).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Color(0xFF58CC02),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    lesson,
                    style: TextStyle(
                      color: const Color(0xFF3C3C3C),
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                if (isCurrent)
                  const Icon(Icons.play_circle_filled, color: Color(0xFF58CC02), size: 22),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}