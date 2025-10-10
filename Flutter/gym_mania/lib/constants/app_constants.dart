import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppConstants {
  // Colors
  static const Color primaryColor = Color(0xFF1A1A1A);
  static const Color secondaryColor = Color(0xFFFF6B35);
  static const Color accentColor = Color(0xFF4ECDC4);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color successColor = Color(0xFF00B894);
  static const Color warningColor = Color(0xFFFFB347);
  static const Color errorColor = Color(0xFFE17055);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1A1A1A), Color(0xFF2D3436)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text Styles
  static TextStyle get headingLarge => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static TextStyle get headingMedium => GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static TextStyle get headingSmall => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  // App Theme
  static ThemeData get lightTheme => ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: GoogleFonts.inter().fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    cardTheme: CardTheme(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusM),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusM),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );

  // Difficulty Colors
  static Color getDifficultyColor(String? difficulty) {
    switch (difficulty?.toLowerCase()) {
      case 'beginner':
        return successColor;
      case 'intermediate':
        return warningColor;
      case 'advanced':
        return errorColor;
      default:
        return textSecondary;
    }
  }

  // Category Icons
  static IconData getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'strength':
        return Icons.fitness_center;
      case 'cardio':
        return Icons.directions_run;
      case 'abs':
        return Icons.self_improvement;
      default:
        return Icons.sports_gymnastics;
    }
  }

  // Muscle Group Icons
  static IconData getMuscleGroupIcon(String muscleGroupName) {
    switch (muscleGroupName.toLowerCase()) {
      case 'chest':
        return Icons.fitness_center;
      case 'legs':
        return Icons.accessibility_new;
      case 'arms':
        return Icons.sports_martial_arts;
      case 'back':
        return Icons.fitness_center;
      case 'abs':
        return Icons.self_improvement;
      case 'shoulders':
        return Icons.sports_gymnastics;
      default:
        return Icons.fitness_center;
    }
  }
}
