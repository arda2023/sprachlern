import 'package:go_router/go_router.dart';
import 'package:sprachlern/navigation/bottom_nav_shell.dart';
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
import 'package:sprachlern/screens/progress_screen.dart';
import 'package:sprachlern/screens/settings_screen.dart';
import 'package:sprachlern/screens/stack_detail_screen.dart';
import 'package:sprachlern/screens/stack_list_screen.dart';
import 'package:sprachlern/screens/stack_revue_screen.dart';
import 'package:sprachlern/screens/text_exercise_screen.dart';
import 'package:sprachlern/screens/texts_screen.dart';
import 'package:sprachlern/screens/word_list_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
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
            GoRoute(path: '/content', builder: (_, _) => const ContentScreen()),
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
            GoRoute(path: '/account', builder: (_, _) => const AccountScreen()),
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
    GoRoute(path: '/stack-revue', builder: (_, _) => const StackRevueScreen()),
    GoRoute(
      path: '/custom-stack',
      builder: (_, _) => const CustomStackScreen(),
      routes: [GoRoute(path: 'add', builder: (_, _) => const AddWordsScreen())],
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
