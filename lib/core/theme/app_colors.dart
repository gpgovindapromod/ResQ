import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // --- Light Theme Colors ---
  static const Color primary = Color(0xFF041E42); // Deep Navy Blue
  static const Color secondary = Color(0xFF0D3B73); // Royal Slate Blue
  static const Color background = Color(0xFFF4F6F9); // Light Gray Background
  static const Color surface = Color(0xFFFFFFFF); // Pure White Surface
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1F2937); // Dark Slate Text
  static const Color textSecondary = Color(0xFF6B7280); // Muted Gray Text
  static const Color border = Color(0xFFE5E7EB); // Light Gray Border
  static const Color divider = Color(0xFFC4C6CF);

  // Status & Alerts (Light Mode)
  static const Color error = Color(0xFFBA1A1A); // Deep Emergency Red
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  static const Color warning = Color(0xFFF59E0B); // Alert Orange/Amber
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color warningText = Color(0xFFB45309);

  static const Color success = Color(0xFF10B981); // Safety Green
  static const Color successBg = Color(0xFFD1FAE5);
  static const Color successText = Color(0xFF065F46);

  static const Color info = Color(0xFF002045); // Deep Blue Info
  static const Color infoBg = Color(0xFFD6E3FF);
  static const Color infoText = Color(0xFF2D476F);

  static const Color navBarBg = Color(0xFFFFFFFF);
  static const Color chipSelectedBg = Color(0xFFD6E3FF);

  // Accent & Neutral Tokens (Light)
  static const Color overlayDark = Color(0x8C000000); // 55% Black
  static const Color shadow = Color(0x0D000000); // 5% Black

  // --- Dark Theme Colors ---
  static const Color darkPrimary = Color(0xFF38BDF8); // Vibrant Sky Blue Accent
  static const Color darkSecondary = Color(0xFF0284C7);
  static const Color darkBackground = Color(0xFF0F172A); // Dark Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800 Surface
  static const Color darkCardBg = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Off-White Text
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Muted Slate Text
  static const Color darkBorder = Color(0xFF334155); // Slate 700 Border
  static const Color darkDivider = Color(0xFF334155);

  // Status & Alerts (Dark Mode)
  static const Color darkError = Color(0xFFBA1A1A);
  static const Color darkErrorContainer = Color(0xFF450A0A);
  static const Color darkOnErrorContainer = Color(0xFFFCA5A5);

  static const Color darkWarning = Color(0xFFFBBF24);
  static const Color darkWarningBg = Color(0xFF451A03);
  static const Color darkWarningText = Color(0xFFFBBF24);

  static const Color darkSuccess = Color(0xFF34D399);
  static const Color darkSuccessBg = Color(0xFF064E3B);
  static const Color darkSuccessText = Color(0xFF6EE7B7);

  static const Color darkInfo = Color(0xFF38BDF8);
  static const Color darkInfoBg = Color(0xFF1E3A8A);
  static const Color darkInfoText = Color(0xFF93C5FD);

  static const Color darkNavBarBg = Color(0xFF1E293B);
  static const Color darkChipSelectedBg = Color(0xFF1E3A8A);

  // --- Gradients ---
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkPrimaryGradient = LinearGradient(
    colors: [darkBackground, darkSurface],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- Semantic Theme Context Helpers ---
  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color getPrimary(BuildContext context) => isDark(context) ? darkPrimary : primary;
  static Color getOnPrimary(BuildContext context) => isDark(context) ? const Color(0xFF0F172A) : Colors.white;
  static Color getBackground(BuildContext context) => isDark(context) ? darkBackground : background;
  static Color getSurface(BuildContext context) => isDark(context) ? darkSurface : surface;
  static Color getCardBg(BuildContext context) => isDark(context) ? darkCardBg : cardBg;
  static Color getCardBackground(BuildContext context) => isDark(context) ? darkCardBg : cardBg;
  static Color getTextPrimary(BuildContext context) => isDark(context) ? darkTextPrimary : textPrimary;
  static Color getTextSecondary(BuildContext context) => isDark(context) ? darkTextSecondary : textSecondary;
  static Color getBorder(BuildContext context) => isDark(context) ? darkBorder : border;
  static Color getDivider(BuildContext context) => isDark(context) ? darkDivider : divider;
  static Color getNavBarBg(BuildContext context) => isDark(context) ? darkNavBarBg : navBarBg;
  static Color getNavBarSelected(BuildContext context) => isDark(context) ? darkPrimary : primary;

  static Color getError(BuildContext context) => isDark(context) ? darkError : error;
  static Color getOnError(BuildContext context) => Colors.white;
  static Color getErrorBg(BuildContext context) => isDark(context) ? darkErrorContainer : errorContainer;
  static Color getErrorContainer(BuildContext context) => isDark(context) ? darkErrorContainer : errorContainer;
  static Color getOnErrorContainer(BuildContext context) => isDark(context) ? darkOnErrorContainer : onErrorContainer;

  static Color getWarning(BuildContext context) => isDark(context) ? darkWarning : warning;
  static Color getWarningBg(BuildContext context) => isDark(context) ? darkWarningBg : warningBg;
  static Color getWarningText(BuildContext context) => isDark(context) ? darkWarningText : warningText;

  static Color getSuccess(BuildContext context) => isDark(context) ? darkSuccess : success;
  static Color getSuccessBg(BuildContext context) => isDark(context) ? darkSuccessBg : successBg;
  static Color getSuccessText(BuildContext context) => isDark(context) ? darkSuccessText : successText;

  static Color getInfo(BuildContext context) => isDark(context) ? darkInfo : info;
  static Color getInfoBg(BuildContext context) => isDark(context) ? darkInfoBg : infoBg;
  static Color getInfoText(BuildContext context) => isDark(context) ? darkInfoText : infoText;
}

