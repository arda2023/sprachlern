import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/navigation/bottom_nav_shell.dart';
import 'package:sprachlern/providers/auth_provider.dart';
import 'package:sprachlern/screens/account_screen.dart';
import 'package:sprachlern/screens/add_words_screen.dart';
import 'package:sprachlern/screens/custom_stack_screen.dart';
import 'package:sprachlern/screens/content_screen.dart';
import 'package:sprachlern/screens/exercise_screen.dart';
import 'package:sprachlern/screens/grammar_explanation_screen.dart';
import 'package:sprachlern/screens/grammar_list_screen.dart';
import 'package:sprachlern/screens/grammar_exercise_screen.dart';
import 'package:sprachlern/screens/home_screen.dart';
import 'package:sprachlern/screens/knowledge_center_screen.dart';
import 'package:sprachlern/screens/learn_screen.dart';
import 'package:sprachlern/screens/login_screen.dart';
import 'package:sprachlern/screens/progress_screen.dart';
import 'package:sprachlern/screens/register_screen.dart';
import 'package:sprachlern/screens/settings_screen.dart';
import 'package:sprachlern/screens/stack_detail_screen.dart';
import 'package:sprachlern/screens/stack_list_screen.dart';
import 'package:sprachlern/screens/stack_revue_screen.dart';
import 'package:sprachlern/screens/text_exercise_screen.dart';
import 'package:sprachlern/screens/texts_screen.dart';
import 'package:sprachlern/screens/word_list_screen.dart';

/// Routes reachable without a session.
const _publicLocations = {'/login', '/register'};

/// Signed-out users may only see the auth screens; signed-in users skip them.
String? _authRedirect({
  required bool isAuthenticated,
  required String location,
}) {
  final onAuthScreen = _publicLocations.contains(location);
  if (!isAuthenticated) return onAuthScreen ? null : '/login';
  return onAuthScreen ? '/home' : null;
}

/// The router lives in a provider so its redirect can read the auth state.
///
/// It is built once: recreating it on every auth change would throw away the
/// navigation stack. Instead a [ValueNotifier] mirrors the auth state and is
/// passed as `refreshListenable`, so go_router re-runs the redirect on login
/// and logout.
final routerProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ValueNotifier(ref.read(isAuthenticatedProvider));
  ref.listen(
    isAuthenticatedProvider,
    (_, next) => isAuthenticated.value = next,
  );

  final router = GoRouter(
    initialLocation: '/home',
    refreshListenable: isAuthenticated,
    redirect: (_, state) => _authRedirect(
      isAuthenticated: isAuthenticated.value,
      location: state.matchedLocation,
    ),
    routes: [
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) =>
            BottomNavShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/content',
                builder: (_, _) => const ContentScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/learn', builder: (_, _) => const LearnScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/progress',
                builder: (_, _) => const ProgressScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/account',
                builder: (_, _) => const AccountScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(path: '/exercise', builder: (_, _) => const ExerciseScreen()),
      GoRoute(
        path: '/grammar-exercise',
        builder: (_, _) => const GrammarExerciseScreen(),
      ),
      GoRoute(
        path: '/grammar-list',
        builder: (_, _) => const GrammarListScreen(),
      ),
      GoRoute(
        path: '/grammar-topics',
        builder: (_, _) => const GrammarExplanationScreen(),
        routes: [
          // The light explanation page is its own screen (design.md 6 and 9).
          GoRoute(
            path: ':id',
            builder: (_, state) => GrammarExplanationDetailScreen(
              topicId: state.pathParameters['id']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/knowledge-center',
        builder: (_, _) => const KnowledgeCenterScreen(),
      ),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
      GoRoute(
        path: '/stacks',
        builder: (_, _) => const StackListScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (_, state) =>
                StackDetailScreen(stackId: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: '/stack-revue',
        builder: (_, _) => const StackRevueScreen(),
      ),
      GoRoute(
        path: '/custom-stack',
        builder: (_, _) => const CustomStackScreen(),
        routes: [
          GoRoute(path: 'add', builder: (_, _) => const AddWordsScreen()),
        ],
      ),
      GoRoute(
        path: '/texts',
        builder: (_, _) => const TextsScreen(),
        routes: [
          GoRoute(
            path: ':id/exercise',
            builder: (_, state) =>
                TextExerciseScreen(textId: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(path: '/word-list', builder: (_, _) => const WordListScreen()),
    ],
  );

  ref.onDispose(() {
    router.dispose();
    isAuthenticated.dispose();
  });
  return router;
});
