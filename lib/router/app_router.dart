import 'package:go_router/go_router.dart';
import 'package:sprachlern/navigation/bottom_nav_shell.dart';
import 'package:sprachlern/screens/account_screen.dart';
import 'package:sprachlern/screens/content_screen.dart';
import 'package:sprachlern/screens/exercise_screen.dart';
import 'package:sprachlern/screens/home_screen.dart';
import 'package:sprachlern/screens/learn_screen.dart';
import 'package:sprachlern/screens/progress_screen.dart';

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
  ],
);
