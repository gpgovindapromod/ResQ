import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/routes/app_router.dart';
import '../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate loading of core systems, then navigate to Auth
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, AppRouter.auth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.health_and_safety, // Shield with heart/cross approximation
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            // Title
            Text(
              'ResQ',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 12),
            // Subtitle
            Text(
              'Predict. Respond. Recover.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textPrimary,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 64),
            // Loading Spinner
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeWidth: 3,
            ),
            const SizedBox(height: 24),
            // Loading Text
            Text(
              'INITIALIZING CORE SYSTEMS',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Loading predictive models...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
