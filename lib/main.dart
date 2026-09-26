import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:sprachlern/config/supabase_config.dart';
import 'package:sprachlern/router/app_router.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // Supabase restores a stored session from platform storage before the first
  // frame, so the router's redirect starts from the right auth state.
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabasePublishableKey,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Sprachlern',
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) =>
          FTheme(data: FTheme.neutral.dark.touch, child: child!),
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: ColorScheme.dark(
          primary: AppColors.lilac,
          surface: AppColors.surface,
          onSurface: AppColors.text,
        ),
      ),
    );
  }
}
