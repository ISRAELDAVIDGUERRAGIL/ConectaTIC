import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/progress_provider.dart';

/// ============================================================
/// PANTALLA: LessonExerciseScreen
/// PROPÓSITO: Ejercicios interactivos tipo Duolingo
/// ESTILO: Gamificado, moderno, feedback inmediato
/// ============================================================

class LessonExerciseScreen extends StatefulWidget {
  final String moduleTitle;
  final List<Map<String, dynamic>>? exercises;
  
  const LessonExerciseScreen({
    super.key,
    required this.moduleTitle,
    this.exercises,
  });

  @override
  State<LessonExerciseScreen> createState() => _LessonExerciseScreenState();
}

class _LessonExerciseScreenState extends State<LessonExerciseScreen> {
  int _currentExercise = 0;
  int _completedCount = 0;
  bool _hasAnswered = false;
  bool _isCorrect = false;
  int? _selectedOption;
  List<int>? _orderSelection;
  List<int>? _matchSelection;
  String? _completeInput;

  // Usar ejercicios del módulo si existen, si no usar genéricos
  List<Map<String, dynamic>> get _exercises => widget.exercises ?? _defaultExercises;

  // Ejercicios por defecto (genéricos)
  final List<Map<String, dynamic>> _defaultExercises = [
    {'type': 'multiple_choice', 'question': '¿Qué es tecnología?', 'options': ['Un juego', 'Herramientas digitales', 'Un libro', 'Una canción'], 'correct': 1, 'explanation': 'La tecnología son herramientas que usamos con dispositivos digitales'},
    {'type': 'true_false', 'question': 'Se puede aprender tecnología con el celular.', 'options': ['Verdadero', 'Falso'], 'correct': 0, 'explanation': 'El celular es una herramienta muy útil para aprender'},
    {'type': 'order', 'question': 'Ordena: Usar el celular', 'words': ['Encender', 'celular', 'Usar'], 'correctOrder': [0, 2, 1], 'explanation': 'Primero enciendes el celular, luego lo usas'},
    {'type': 'multiple_choice', 'question': '¿Qué significa aprender?', 'options': ['Jugando', 'Adquiriendo conocimientos', 'Durmiendo', 'Comiendo'], 'correct': 1, 'explanation': 'Aprender es adquirir nuevos conocimientos'},
    {'type': 'true_false', 'question': 'La práctica ayuda a aprender.', 'options': ['Verdadero', 'Falso'], 'correct': 0, 'explanation': 'Practicar es la mejor forma de aprender'},
    {'type': 'multiple_choice', 'question': '¿Qué es una app?', 'options': ['Un programa en el celular', 'Un juego', 'Una cámara', 'Un mensaje'], 'correct': 0, 'explanation': 'Una app es un programa que se instala en el celular'},
  ];

  int get _totalExercises => _exercises.length;
  Map<String, dynamic> get _current => _exercises[_currentExercise];

  void _checkAnswer() {
    if (_hasAnswered) return;
    
    setState(() {
      _hasAnswered = true;
      final type = _current['type'];
      
      if (type == 'multiple_choice' || type == 'true_false') {
        _isCorrect = _selectedOption == _current['correct'];
      } 
      else if (type == 'order') {
        final userOrder = _orderSelection ?? [];
        final correct = _current['correctOrder'] as List;
        _isCorrect = userOrder.length == correct.length && 
                     userOrder.asMap().entries.every((e) => e.value == correct[e.key]);
      }
      
      if (_isCorrect) _completedCount++;
    });
  }

  void _nextExercise() {
    if (_currentExercise < _totalExercises - 1) {
      setState(() {
        _currentExercise++;
        _hasAnswered = false;
        _isCorrect = false;
        _selectedOption = null;
        _orderSelection = null;
        _matchSelection = null;
        _completeInput = null;
      });
    } else {
      _showSummary();
    }
  }

  void _showSummary() async {
    final xpEarned = _completedCount * 10;
    
    // Calcular incremento de progreso (cada módulo completado = 25%)
    final progresoIncremento = (_completedCount * 25 ~/ _totalExercises);
    
    // Guardar progreso en la base de datos
    if (mounted) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.updateProgress(progresoIncremento);
    }
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC800).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.emoji_events_rounded, size: 56, color: Color(0xFFFFC800)),
              ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
              const SizedBox(height: 24),
              Text('¡Lección Completada! 🎉', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Text('$_completedCount de $_totalExercises ejercicios correctos', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: const Color(0xFF3C3C3C).withOpacity(0.7)), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(color: const Color(0xFF58CC02), borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, color: Color(0xFFFFC800), size: 28),
                    const SizedBox(width: 8),
                    Text('+$xpEarned XP', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () {
                  context.read<ProgressProvider>().completeQuiz(widget.moduleTitle);
                  Navigator.pop(ctx);
                  context.go('/home');
                }, child: const Text('Continuar')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 350;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: Text(widget.moduleTitle),
        leading: IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => _showExitDialog()),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(isWide),
            Expanded(child: _buildExercise(isWide)),
            if (_hasAnswered) _buildNextButton(isWide),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(bool isWide) {
    return Container(
      padding: EdgeInsets.all(isWide ? 16 : 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ejercicio ${_currentExercise + 1} de $_totalExercises', style: TextStyle(fontSize: isWide ? 16 : 14, fontWeight: FontWeight.w600, color: const Color(0xFF3C3C3C))),
              Container(
                padding: EdgeInsets.symmetric(horizontal: isWide ? 12 : 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF58CC02).withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, size: isWide ? 18 : 14, color: const Color(0xFF58CC02)),
                    SizedBox(width: isWide ? 4 : 2),
                    Text('+${(_currentExercise + 1) * 10} XP', style: TextStyle(fontSize: isWide ? 14 : 12, fontWeight: FontWeight.bold, color: const Color(0xFF58CC02))),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isWide ? 12 : 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(value: (_currentExercise + 1) / _totalExercises, minHeight: isWide ? 10 : 8, backgroundColor: const Color(0xFFE5E5E5), valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF58CC02))),
          ),
        ],
      ),
    );
  }

  Widget _buildExercise(bool isWide) {
    final type = _current['type'];
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(isWide ? 24 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isWide ? 24 : 18),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
            child: Text(_current['question'] as String, style: TextStyle(fontSize: isWide ? 20 : 17, fontWeight: FontWeight.bold, color: const Color(0xFF3C3C3C))),
          ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0),
          
          SizedBox(height: isWide ? 24 : 16),
          
          if (type == 'multiple_choice' || type == 'true_false')
            _buildMultipleChoice(isWide)
          else if (type == 'order')
            _buildOrderExercise(isWide),
          
          if (_hasAnswered) ...[
            SizedBox(height: isWide ? 24 : 16),
            _buildFeedback(isWide),
          ],
        ],
      ),
    );
  }

  Widget _buildMultipleChoice(bool isWide) {
    final options = _current['options'] as List;
    
    return Column(
      children: options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final isSelected = _selectedOption == index;
        final isCorrectAnswer = index == _current['correct'];
        
        Color? bgColor, borderColor;
        
        if (_hasAnswered) {
          if (isCorrectAnswer) { bgColor = const Color(0xFF58CC02).withOpacity(0.15); borderColor = const Color(0xFF58CC02); }
          else if (isSelected) { bgColor = const Color(0xFFFF4B4B).withOpacity(0.15); borderColor = const Color(0xFFFF4B4B); }
        } else if (isSelected) { bgColor = const Color(0xFF58CC02).withOpacity(0.1); borderColor = const Color(0xFF58CC02); }
        
        return GestureDetector(
          onTap: _hasAnswered ? null : () { setState(() => _selectedOption = index); _checkAnswer(); },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: isWide ? 14 : 10),
            padding: EdgeInsets.all(isWide ? 18 : 14),
            decoration: BoxDecoration(color: bgColor ?? Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor ?? Colors.grey.shade300, width: isSelected ? 2.5 : 1.5), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)]),
            child: Row(
              children: [
                Container(
                  width: isWide ? 36 : 28, height: isWide ? 36 : 28,
                  decoration: BoxDecoration(color: isSelected || (_hasAnswered && isCorrectAnswer) ? (borderColor ?? const Color(0xFF58CC02)) : const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(10)),
                  child: Center(child: Text(String.fromCharCode(65 + index), style: TextStyle(fontSize: isWide ? 16 : 14, fontWeight: FontWeight.bold, color: isSelected || (_hasAnswered && isCorrectAnswer) ? Colors.white : Colors.grey.shade600))),
                ),
                SizedBox(width: isWide ? 16 : 12),
                Expanded(child: Text(option, style: TextStyle(fontSize: isWide ? 17 : 15, color: const Color(0xFF3C3C3C)))),
                if (_hasAnswered && isCorrectAnswer) const Icon(Icons.check_circle_rounded, color: Color(0xFF58CC02), size: 24)
                else if (_hasAnswered && isSelected && !isCorrectAnswer) const Icon(Icons.cancel_rounded, color: Color(0xFFFF4B4B), size: 24),
              ],
            ),
          ),
        ).animate().fade(delay: (index * 100).ms, duration: 300.ms);
      }).toList(),
    );
  }

  Widget _buildOrderExercise(bool isWide) {
    final words = _current['words'] as List;
    _orderSelection ??= [];
    
    return Column(
      children: [
        Text('Toca las palabras en orden:', style: TextStyle(fontSize: isWide ? 16 : 14, color: const Color(0xFF3C3C3C).withOpacity(0.7))),
        SizedBox(height: isWide ? 16 : 12),
        if (_orderSelection!.isNotEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isWide ? 16 : 12),
            margin: EdgeInsets.only(bottom: isWide ? 16 : 12),
            decoration: BoxDecoration(color: const Color(0xFF58CC02).withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF58CC02))),
            child: Wrap(
              spacing: 8, runSpacing: 8,
              children: _orderSelection!.asMap().entries.map((e) => Chip(label: Text(words[e.value], style: TextStyle(fontSize: isWide ? 16 : 14)), backgroundColor: const Color(0xFF58CC02).withOpacity(0.2))).toList(),
            ),
          ),
        Wrap(
          spacing: isWide ? 10 : 8, runSpacing: isWide ? 10 : 8,
          children: words.asMap().entries.map((entry) {
            final isUsed = _orderSelection!.contains(entry.key);
            return GestureDetector(
              onTap: _hasAnswered || isUsed ? null : () => setState(() => _orderSelection!.add(entry.key)),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: isWide ? 16 : 12, vertical: isWide ? 12 : 10),
                decoration: BoxDecoration(color: isUsed ? Colors.grey.shade300 : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isUsed ? Colors.grey.shade400 : Colors.grey.shade300)),
                child: Text(entry.value, style: TextStyle(fontSize: isWide ? 16 : 14, color: isUsed ? Colors.grey : const Color(0xFF3C3C3C))),
              ),
            );
          }).toList(),
        ),
        if (!_hasAnswered && _orderSelection!.isNotEmpty) ...[
          SizedBox(height: isWide ? 16 : 12),
          ElevatedButton(onPressed: _checkAnswer, child: const Text('Verificar')),
        ],
      ],
    );
  }

  Widget _buildFeedback(bool isWide) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isWide ? 20 : 16),
      decoration: BoxDecoration(
        color: _isCorrect ? const Color(0xFF58CC02).withOpacity(0.1) : const Color(0xFFFF4B4B).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _isCorrect ? const Color(0xFF58CC02) : const Color(0xFFFF4B4B), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded, color: _isCorrect ? const Color(0xFF58CC02) : const Color(0xFFFF4B4B), size: isWide ? 28 : 24),
              SizedBox(width: isWide ? 12 : 8),
              Text(_isCorrect ? '¡Correcto! 🎉' : '¡No es correcto! 😅', style: TextStyle(fontSize: isWide ? 18 : 16, fontWeight: FontWeight.bold, color: _isCorrect ? const Color(0xFF58CC02) : const Color(0xFFFF4B4B))),
            ],
          ),
          SizedBox(height: isWide ? 12 : 8),
          Text(_current['explanation'] as String, style: TextStyle(fontSize: isWide ? 15 : 13, color: const Color(0xFF3C3C3C).withOpacity(0.8), height: 1.4)),
        ],
      ),
    ).animate().fade(duration: 300.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildNextButton(bool isWide) {
    return Padding(
      padding: EdgeInsets.all(isWide ? 24 : 16),
      child: SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _nextExercise, child: Text(_currentExercise < _totalExercises - 1 ? 'Siguiente' : 'Terminar lección'))),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('¿Salir de la lección?'),
        content: const Text('Si sales, perderás tu progreso.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Continuar')),
          TextButton(onPressed: () { Navigator.pop(ctx); context.go('/home'); }, child: const Text('Salir', style: TextStyle(color: Color(0xFFFF4B4B)))),
        ],
      ),
    );
  }
}