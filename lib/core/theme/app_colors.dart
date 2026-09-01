import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF041E42); // Deep Dark Blue
  static const Color secondary = Color(0xFF0D3B73); 
  static const Color background = Color(0xFFF4F6F9); // Light off-white grey
  static const Color surface = Color(0xFFFFFFFF); // White cards
  static const Color error = Color(0xFFCF6679);
  
  static const Color textPrimary = Color(0xFF1F2937); // Dark gray text
  static const Color textSecondary = Color(0xFF6B7280); // Muted text
  static const Color border = Color(0xFFE5E7EB); // Light border
  
  // Gradients for premium look (if needed later)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF041E42), Color(0xFF0D3B73)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
