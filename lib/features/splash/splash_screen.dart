import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/routes/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      bool loggedIn = await AuthService.isLoggedIn();
      if (mounted) {
        if (loggedIn) {
          Navigator.pushReplacementNamed(context, AppRouter.home);
        } else {
          Navigator.pushReplacementNamed(context, AppRouter.auth);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = AppColors.getPrimary(context);
    final primaryTextColor = AppColors.getTextPrimary(context);
    final cardBgColor = AppColors.getCardBackground(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                Icons.health_and_safety,
                size: 64,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'ResQ',
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 32,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Predict. Respond. Recover.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: primaryTextColor,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 64),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              strokeWidth: 3,
            ),
            const SizedBox(height: 24),
            Text(
              'INITIALIZING CORE SYSTEMS',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Loading predictive models...',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                color: AppColors.getTextSecondary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

