import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ResQ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Using the new light theme
      initialRoute: AppRouter.splash, // Start at splash screen
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
