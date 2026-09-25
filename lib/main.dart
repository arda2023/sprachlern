import 'package:flutter/material.dart';
import 'package:sprachlern/router/app_router.dart';
import 'package:sprachlern/theme/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sprachlern',
      routerConfig: appRouter,
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
