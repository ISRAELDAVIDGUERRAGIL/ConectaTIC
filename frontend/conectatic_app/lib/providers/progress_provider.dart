import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

class ModuleProgress {
  final String moduleTitle;
  int lessonIndex;
  bool lessonCompleted;
  bool quizCompleted;
  DateTime? lastAccessed;

  ModuleProgress({
    required this.moduleTitle,
    this.lessonIndex = 0,
    this.lessonCompleted = false,
    this.quizCompleted = false,
    this.lastAccessed,
  });

  Map<String, dynamic> toJson() => {
        'moduleTitle': moduleTitle,
        'lessonIndex': lessonIndex,
        'lessonCompleted': lessonCompleted,
        'quizCompleted': quizCompleted,
        'lastAccessed': lastAccessed?.toIso8601String(),
      };

  factory ModuleProgress.fromJson(Map<String, dynamic> json) => ModuleProgress(
        moduleTitle: json['moduleTitle'] as String,
        lessonIndex: json['lessonIndex'] as int? ?? 0,
        lessonCompleted: json['lessonCompleted'] as bool? ?? false,
        quizCompleted: json['quizCompleted'] as bool? ?? false,
        lastAccessed: json['lastAccessed'] != null
            ? DateTime.tryParse(json['lastAccessed'] as String)
            : null,
      );
}

class ProgressProvider extends ChangeNotifier {
  static const String _storageKey = 'module_progress';
  Map<String, ModuleProgress> _progressMap = {};

  Map<String, ModuleProgress> get progressMap => _progressMap;

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_storageKey);
    if (saved != null) {
      final Map<String, dynamic> decoded = jsonDecode(saved);
      _progressMap = decoded.map((key, value) => MapEntry(
          key, ModuleProgress.fromJson(value as Map<String, dynamic>)));
      notifyListeners();
    }
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> toSave =
        _progressMap.map((key, value) => MapEntry(key, value.toJson()));
    await prefs.setString(_storageKey, jsonEncode(toSave));
  }

  ModuleProgress? getModuleProgress(String moduleTitle) {
    return _progressMap[moduleTitle];
  }

  bool hasStartedModule(String moduleTitle) {
    final progress = _progressMap[moduleTitle];
    return progress != null &&
        (progress.lessonIndex > 0 ||
            progress.lessonCompleted ||
            progress.quizCompleted);
  }

  bool isModuleCompleted(String moduleTitle) {
    final progress = _progressMap[moduleTitle];
    return progress?.quizCompleted ?? false;
  }

  Future<void> updateLessonIndex(String moduleTitle, int index) async {
    if (_progressMap[moduleTitle] == null) {
      _progressMap[moduleTitle] = ModuleProgress(moduleTitle: moduleTitle);
    }
    _progressMap[moduleTitle]!.lessonIndex = index;
    _progressMap[moduleTitle]!.lastAccessed = DateTime.now();
    await _saveProgress();
    notifyListeners();
  }

  Future<void> completeLesson(String moduleTitle) async {
    if (_progressMap[moduleTitle] == null) {
      _progressMap[moduleTitle] = ModuleProgress(moduleTitle: moduleTitle);
    }
    _progressMap[moduleTitle]!.lessonCompleted = true;
    _progressMap[moduleTitle]!.lastAccessed = DateTime.now();
    await _saveProgress();
    notifyListeners();
  }

  Future<void> completeQuiz(String moduleTitle) async {
    if (_progressMap[moduleTitle] == null) {
      _progressMap[moduleTitle] = ModuleProgress(moduleTitle: moduleTitle);
    }
    _progressMap[moduleTitle]!.quizCompleted = true;
    _progressMap[moduleTitle]!.lessonIndex = 4;
    _progressMap[moduleTitle]!.lastAccessed = DateTime.now();
    await _saveProgress();

    // 🔄 SINCRONIZAR CON SERVIDOR cuando completa módulo
    await _syncProgressToServer(moduleTitle);

    notifyListeners();
  }

  /// 🔄 Sincroniza el progreso del módulo al servidor
  Future<void> _syncProgressToServer(String moduleTitle) async {
    try {
      // Calcular porcentaje de progreso (0-100)
      int progressPercentage = 0;
      final progress = _progressMap[moduleTitle];

      if (progress != null) {
        if (progress.quizCompleted) {
          progressPercentage = 100; // Módulo completado = 100%
        } else if (progress.lessonCompleted) {
          progressPercentage = 75; // Lecciones completadas = 75%
        } else if (progress.lessonIndex > 0) {
          progressPercentage =
              (progress.lessonIndex * 20); // Avance proporcional
        }
      }

      // Enviar al servidor
      await ApiService.instance.updateUserProgress(progressPercentage);

      if (kDebugMode) {
        print('✅ Progreso sincronizado: $moduleTitle ($progressPercentage%)');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error sincronizando progreso: $e');
      }
      // No bloquear la app si falla la sincronización
    }
  }

  /// 📊 Obtiene progreso general (suma de todos los módulos)
  int getOverallProgress() {
    if (_progressMap.isEmpty) return 0;

    int totalProgress = 0;
    for (var progress in _progressMap.values) {
      if (progress.quizCompleted) {
        totalProgress += 100;
      } else if (progress.lessonCompleted) {
        totalProgress += 75;
      } else if (progress.lessonIndex > 0) {
        totalProgress += (progress.lessonIndex * 20);
      }
    }

    return (totalProgress / _progressMap.length).round();
  }

  Future<void> resetModule(String moduleTitle) async {
    _progressMap[moduleTitle] = ModuleProgress(moduleTitle: moduleTitle);
    await _saveProgress();
    notifyListeners();
  }

  List<String> getInProgressModules() {
    return _progressMap.entries
        .where((e) => !e.value.quizCompleted && e.value.lessonIndex > 0)
        .map((e) => e.key)
        .toList();
  }

  List<String> getCompletedModules() {
    return _progressMap.entries
        .where((e) => e.value.quizCompleted)
        .map((e) => e.key)
        .toList();
  }
}
