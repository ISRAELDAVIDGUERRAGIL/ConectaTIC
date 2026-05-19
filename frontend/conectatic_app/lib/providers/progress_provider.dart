import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      _progressMap = decoded.map((key, value) => 
        MapEntry(key, ModuleProgress.fromJson(value as Map<String, dynamic>))
      );
      notifyListeners();
    }
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> toSave = _progressMap.map(
      (key, value) => MapEntry(key, value.toJson())
    );
    await prefs.setString(_storageKey, jsonEncode(toSave));
  }

  ModuleProgress? getModuleProgress(String moduleTitle) {
    return _progressMap[moduleTitle];
  }

  bool hasStartedModule(String moduleTitle) {
    final progress = _progressMap[moduleTitle];
    return progress != null && (progress.lessonIndex > 0 || progress.lessonCompleted || progress.quizCompleted);
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
    notifyListeners();
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