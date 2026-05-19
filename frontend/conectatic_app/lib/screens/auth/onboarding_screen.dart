import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// ============================================================
/// PANTALLA: OnboardingScreen
/// PROPÓSITO: Pantalla de instrucciones para nuevos usuarios
/// ESTILO: Gamificado, moderno, limpio
/// ============================================================

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Página actual del onboarding
  int _currentPage = 0;
  
  // Controlador de página
  final PageController _pageController = PageController();

  // Lista de páginas del onboarding
  final List<Map<String, dynamic>> _pages = [
    {
      'title': '¡Bienvenido a ConectaTIC! 🎉',
      'description': 'La app que te enseña a usar la tecnología de manera fácil y divertida.',
      'icon': Icons.school_rounded,
      'color': const Color(0xFF58CC02),
      'image': null,
    },
    {
      'title': 'Aprende a tu ritmo 🐢',
      'description': 'Cada lección está diseñada para que aprendas paso a paso, sin prisa.',
      'icon': Icons.timer_rounded,
      'color': const Color(0xFF1CB0F6),
      'image': null,
    },
    {
      'title': 'Sigue tu progreso 📊',
      'description': 'Mira cuánto has avanzado y ganarás XP por cada lección completada.',
      'icon': Icons.trending_up_rounded,
      'color': const Color(0xFFFFC800),
      'image': null,
    },
    {
      'title': '¡Empieza ahora! 🚀',
      'description': 'Crea tu cuenta y comienza a aprender tecnología hoy.',
      'icon': Icons.rocket_launch_rounded,
      'color': const Color(0xFFFF4B4B),
      'image': null,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Cambiar a la siguiente página
  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Ir a la pantalla de autenticación
      context.go('/auth');
    }
  }

  /// Ir a una página específica
  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isWide = screenWidth > 350;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            // Botón de saltar onboarding
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(isWide ? 16 : 12),
                child: TextButton(
                  onPressed: () => context.go('/auth'),
                  child: Text(
                    'Saltar',
                    style: TextStyle(
                      fontSize: isWide ? 16 : 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF58CC02),
                    ),
                  ),
                ),
              ).animate().fade(duration: 300.ms),
            ),

            // PagesView con las páginas
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index], index, isWide);
                },
              ),
            ),

            // Indicadores de página
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => _buildDot(index, isWide),
                ),
              ),
            ),

            // Botón de siguiente
            Padding(
              padding: EdgeInsets.all(isWide ? 24 : 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    _currentPage == _pages.length - 1 
                        ? '¡Empezar!' 
                        : 'Siguiente',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construir una página del onboarding
  Widget _buildPage(Map<String, dynamic> pageData, int index, bool isWide) {
    final iconSize = isWide ? 140.0 : 100.0;
    final iconInnerSize = isWide ? 72.0 : 56.0;
    
    return Padding(
      padding: EdgeInsets.all(isWide ? 32 : 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icono grande con animación
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: (pageData['color'] as Color).withOpacity(0.15),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              pageData['icon'] as IconData,
              size: iconInnerSize,
              color: pageData['color'] as Color,
            ),
          )
              .animate(key: ValueKey(index))
              .fade(duration: 500.ms)
              .scale(duration: 500.ms, curve: Curves.elasticOut),

          const SizedBox(height: 48),

          // Título
          Text(
            pageData['title'] as String,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3C3C3C),
            ),
            textAlign: TextAlign.center,
          ).animate()
              .fade(delay: 200.ms, duration: 400.ms)
              .slideY(begin: 0.2, end: 0),

          const SizedBox(height: 16),

          // Descripción
          Text(
            pageData['description'] as String,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF3C3C3C).withOpacity(0.7),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ).animate()
              .fade(delay: 300.ms, duration: 400.ms)
              .slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }

  /// Construir indicador de página (punto)
  Widget _buildDot(int index, bool isWide) {
    final isActive = _currentPage == index;
    final dotWidth = isActive ? (isWide ? 32 : 24) : (isWide ? 12 : 10);
    final dotHeight = isWide ? 12.0 : 10.0;
    
    return GestureDetector(
      onTap: () => _goToPage(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(horizontal: isWide ? 6 : 4),
        width: dotWidth.toDouble(),
        height: dotHeight,
        decoration: BoxDecoration(
          color: isActive 
              ? const Color(0xFF58CC02) 
              : const Color(0xFF58CC02).withOpacity(0.25),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}