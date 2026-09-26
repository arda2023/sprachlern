import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:sprachlern/router/app_router.dart';
import 'package:sprachlern/theme/app_colors.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sprachlern',
      routerConfig: appRouter,
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
