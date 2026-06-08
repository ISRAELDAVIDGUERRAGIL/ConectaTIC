import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../screens/auth/auth_choice_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/onboarding_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/home/main_menu_screen.dart';
import '../screens/home/module_detail_screen.dart';
import '../screens/home/video_intro_screen.dart';
import '../screens/home/lesson_content_screen.dart';
import '../screens/home/lesson_exercise_screen.dart';
import '../screens/home/progress_screen.dart';

/// Genera el enrutador de la aplicación usando GoRouter.
class AppRouter {
  AppRouter._();

  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: authProvider.isAuthenticated ? '/home' : '/auth',
      refreshListenable: authProvider, // ✅ ESCUCHAR CAMBIOS EN EL PROVIDER
      redirect: (context, state) {
        final isLoggedIn = authProvider.isAuthenticated;
        final isOnAuth = state.matchedLocation == '/auth' ||
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/register' ||
            state.matchedLocation == '/onboarding' ||
            state.matchedLocation == '/splash';

        if (!isLoggedIn && !isOnAuth) {
          return '/auth';
        }
        if (isLoggedIn && isOnAuth) {
          return '/home';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/auth',
          builder: (context, state) => const AuthChoiceScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const MainMenuScreen(),
        ),
        GoRoute(
          path: '/progress',
          builder: (context, state) => const ProgressScreen(),
        ),
        GoRoute(
          path: '/module',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return ModuleDetailScreen(
              titulo: extra?['titulo']?.toString() ?? 'Módulo',
              descripcion: extra?['descripcion']?.toString() ?? '',
              content: extra?['content'] != null
                  ? List<Map<String, dynamic>>.from(extra!['content'])
                  : null,
              exercises: extra?['exercises'] != null
                  ? List<Map<String, dynamic>>.from(extra!['exercises'])
                  : null,
              videoPath: extra?['videoPath']?.toString(),
            );
          },
        ),
        GoRoute(
          path: '/lesson',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return LessonExerciseScreen(
              moduleTitle: extra?['titulo']?.toString() ?? 'Lección',
              exercises: extra?['exercises'] != null
                  ? List<Map<String, dynamic>>.from(extra!['exercises'])
                  : null,
            );
          },
        ),
        GoRoute(
          path: '/lesson-content',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return LessonContentScreen(
              moduleTitle: extra?['titulo']?.toString() ?? 'Lección',
              content: extra?['content'] != null
                  ? List<Map<String, dynamic>>.from(extra!['content'])
                  : null,
              exercises: extra?['exercises'] != null
                  ? List<Map<String, dynamic>>.from(extra!['exercises'])
                  : null,
            );
          },
        ),
        GoRoute(
          path: '/video-intro',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return VideoIntroScreen(
              moduleTitle: extra?['titulo']?.toString() ?? 'Módulo',
              videoPath: extra?['videoPath']?.toString() ?? '',
              content: extra?['content'] != null
                  ? List<Map<String, dynamic>>.from(extra!['content'])
                  : null,
              exercises: extra?['exercises'] != null
                  ? List<Map<String, dynamic>>.from(extra!['exercises'])
                  : null,
            );
          },
        ),
      ],
    );
  }
}
