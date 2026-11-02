import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette - Coral / Salmon Pink (from user design)
  static const Color primary = Color(0xFFFF6E6E); // Coral Pink
  static const Color primaryLight = Color(0xFFFF8E8E); // Light Coral
  static const Color primaryDark = Color(0xFFE85050); // Deep Coral

  // Header Wavy Colors
  static const Color headerTop = Color(0xFFFF8585);
  static const Color headerBottom = Color(0xFFFF6868);

  // Secondary / Accent
  static const Color secondary = Color(0xFFFFA07A); // Light Salmon
  static const Color accent = Color(0xFFFF5252);

  // Backgrounds & Surfaces
  static const Color background = Color(0xFFFFFFFF); // Clean white as in image
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B); // Dark slate
  static const Color textSecondary = Color(0xFF64748B); // Slate 500
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400
  static const Color textLight = Color(0xFFFFFFFF);

  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderFocused = Color(0xFFFF6E6E);
  static const Color inputFill = Colors.transparent;
  static const Color underlineInactive = Color(0xFFE0E0E0);
  static const Color underlineActive = Color(0xFFFF6E6E);

  // Status & Feedback
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color info = Color(0xFF3B82F6); // Blue 500

  // Gradients
  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFFFF8888), Color(0xFFFF6565)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF7E7E), Color(0xFFFF6060)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFFFF5F5), Color(0xFFFFFFFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
