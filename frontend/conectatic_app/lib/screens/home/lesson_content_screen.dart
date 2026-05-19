import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/progress_provider.dart';

/// ============================================================
/// PANTALLA: LessonContentScreen
/// PROPÓSITO: Lecciones visuales paso a paso tipo carrusel
/// ESTILO: Muy visual, lenguaje simple, para zonas rurales
/// ============================================================

class LessonContentScreen extends StatefulWidget {
  final String moduleTitle;
  final List<Map<String, dynamic>>? content;
  final List<Map<String, dynamic>>? exercises;
  
  const LessonContentScreen({
    super.key,
    required this.moduleTitle,
    this.content,
    this.exercises,
  });

  @override
  State<LessonContentScreen> createState() => _LessonContentScreenState();
}

class _LessonContentScreenState extends State<LessonContentScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedProgress();
    });
  }

  void _loadSavedProgress() {
    final progressProvider = context.read<ProgressProvider>();
    final progress = progressProvider.getModuleProgress(widget.moduleTitle);
    if (progress != null && progress.lessonIndex > 0 && progress.lessonIndex < _totalPages) {
      setState(() {
        _currentPage = progress.lessonIndex;
      });
      _pageController.jumpToPage(_currentPage);
    }
  }

  // Contenido por defecto muy básico
  List<Map<String, dynamic>> get _lessonContent {
    if (widget.content != null && widget.content!.isNotEmpty) {
      return widget.content!;
    }
    return _defaultContent;
  }

  final List<Map<String, dynamic>> _defaultContent = [
    {
      'title': '¡Bienvenido!',
      'content': 'En esta lección aprenderás paso a paso.',
      'icon': Icons.school_rounded,
    },
    {
      'title': 'Mira con atención',
      'content': 'Cada paso es importante para aprender.',
      'icon': Icons.visibility_rounded,
    },
    {
      'title': 'Practica',
      'content': 'No te preocupes si no entendiste, puedes repetir.',
      'icon': Icons.refresh_rounded,
    },
    {
      'title': '¡Listo!',
      'content': 'Ahora podemos hacer los ejercicios juntos.',
      'icon': Icons.check_circle_rounded,
    },
  ];

  int get _totalPages => _lessonContent.length;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 350;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: Text(widget.moduleTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => _showExitDialog(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Indicador de progreso
            _buildProgressIndicator(isWide),
            
            // Carrusel de lecciones
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() => _currentPage = page);
                  context.read<ProgressProvider>().updateLessonIndex(widget.moduleTitle, page);
                },
                itemCount: _totalPages,
                itemBuilder: (context, index) {
                  return _buildLessonPage(_lessonContent[index], isWide, index);
                },
              ),
            ),
            
            // Botones de navegación
            _buildNavigationButtons(isWide),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(bool isWide) {
    return Container(
      padding: EdgeInsets.all(isWide ? 20 : 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lección ${_currentPage + 1} de $_totalPages',
                style: TextStyle(
                  fontSize: isWide ? 16 : 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF3C3C3C),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: isWide ? 12 : 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF58CC02).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${((_currentPage + 1) * 100 ~/ _totalPages)}%',
                  style: TextStyle(
                    fontSize: isWide ? 14 : 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF58CC02),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isWide ? 12 : 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (_currentPage + 1) / _totalPages,
              minHeight: isWide ? 10 : 8,
              backgroundColor: const Color(0xFFE5E5E5),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF58CC02)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonPage(Map<String, dynamic> lesson, bool isWide, int index) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isWide ? 28 : 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Imagen grande / Icono
          Container(
            width: isWide ? 180 : 140,
            height: isWide ? 180 : 140,
            decoration: BoxDecoration(
              color: const Color(0xFF58CC02).withOpacity(0.15),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              lesson['icon'] as IconData? ?? Icons.lightbulb_rounded,
              size: isWide ? 80 : 64,
              color: const Color(0xFF58CC02),
            ),
          )
              .animate()
              .fade(duration: 500.ms)
              .scale(duration: 500.ms, curve: Curves.elasticOut),
          
          SizedBox(height: isWide ? 40 : 28),
          
          // Título grande
          Text(
            lesson['title'] as String,
            style: TextStyle(
              fontSize: isWide ? 28 : 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3C3C3C),
            ),
            textAlign: TextAlign.center,
          ).animate().fade(delay: 200.ms, duration: 400.ms),
          
          SizedBox(height: isWide ? 20 : 16),
          
          // Contenido con texto grande
          Container(
            padding: EdgeInsets.all(isWide ? 24 : 18),
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
            child: Text(
              lesson['content'] as String,
              style: TextStyle(
                fontSize: isWide ? 20 : 17,
                color: const Color(0xFF3C3C3C),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ).animate().fade(delay: 300.ms, duration: 400.ms),
          
          // Si tiene pasos, mostrarlos
          if (lesson['steps'] != null) ...[
            SizedBox(height: isWide ? 24 : 16),
            ...(lesson['steps'] as List).asMap().entries.map((entry) {
              final stepIndex = entry.key;
              final step = entry.value as Map<String, dynamic>;
              return Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: isWide ? 16 : 12),
                padding: EdgeInsets.all(isWide ? 18 : 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E5E5)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: isWide ? 36 : 28,
                      height: isWide ? 36 : 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFF58CC02),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          '${stepIndex + 1}',
                          style: TextStyle(
                            fontSize: isWide ? 16 : 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: isWide ? 16 : 12),
                    Expanded(
                      child: Text(
                        step['text'] as String,
                        style: TextStyle(
                          fontSize: isWide ? 17 : 15,
                          color: const Color(0xFF3C3C3C),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fade(delay: (400 + stepIndex * 100).ms, duration: 300.ms);
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(bool isWide) {
    return Container(
      padding: EdgeInsets.all(isWide ? 24 : 16),
      child: Row(
        children: [
          // Botón anterior
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                },
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Atrás'),
              ),
            )
          else
            const Expanded(child: SizedBox()),
          
          SizedBox(width: isWide ? 16 : 12),
          
          // Botón siguiente / terminar
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                if (_currentPage < _totalPages - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                } else {
                  // Ir al quiz
                  _goToQuiz();
                }
              },
              icon: Icon(
                _currentPage < _totalPages - 1 
                    ? Icons.arrow_forward_rounded 
                    : Icons.quiz_rounded,
              ),
              label: Text(
                _currentPage < _totalPages - 1 
                    ? 'Siguiente' 
                    : 'Hacer ejercicios',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _goToQuiz() {
    final progressProvider = context.read<ProgressProvider>();
    progressProvider.completeLesson(widget.moduleTitle);
    progressProvider.updateLessonIndex(widget.moduleTitle, _totalPages);
    context.push('/lesson', extra: {
      'titulo': widget.moduleTitle,
      'exercises': widget.exercises,
    });
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('¿Salir de la lección?'),
        content: const Text('Puedes volver a ver las lecciones después.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Continuar')),
          TextButton(
            onPressed: () { Navigator.pop(ctx); context.go('/home'); },
            child: const Text('Salir', style: TextStyle(color: Color(0xFFFF4B4B))),
          ),
        ],
      ),
    );
  }
}