import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/home_screen.dart';
import '../screens/religion_detail_screen.dart';
import '../screens/board_screen.dart';
import '../screens/board_detail_screen.dart';
import '../screens/board_general_screen.dart';
import '../screens/board_general_detail_screen.dart';
import '../screens/support_screen.dart';
import '../screens/terms_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const religionDetail = '/religion/:id';
  static const board = '/board';
  static const boardDetail = '/board/:id';
  static const boardGeneral = '/board-general';
  static const boardGeneralDetail = '/board-general/:id';
  static const support = '/support';
  static const terms = '/terms';

  static String religionDetailPath(String id) => '/religion/$id';
  static String boardDetailPath(String id) => '/board/$id';
  static String boardGeneralDetailPath(String id) => '/board-general/$id';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
    GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
    GoRoute(path: AppRoutes.onboarding, builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: AppRoutes.home, builder: (_, __) => const HomeScreen()),
    GoRoute(
      path: '/religion/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return ReligionDetailScreen(religionId: id);
      },
    ),
    GoRoute(path: AppRoutes.board, builder: (_, __) => const BoardScreen()),
    GoRoute(
      path: '/board/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return BoardDetailScreen(postId: id);
      },
    ),
    GoRoute(path: AppRoutes.boardGeneral, builder: (_, __) => const BoardGeneralScreen()),
    GoRoute(
      path: '/board-general/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return BoardGeneralDetailScreen(postId: id);
      },
    ),
    GoRoute(path: AppRoutes.support, builder: (_, __) => const SupportScreen()),
    GoRoute(path: AppRoutes.terms, builder: (_, __) => const TermsScreen()),
  ],
);
