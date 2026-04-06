import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFFB79975); // Bronze accent
  static const Color primaryContainer = Color(0xFF191A1A);
  static const Color onPrimary = Color(0xFF0E0E0E);
  static const Color onPrimaryContainer = Color(0xFFDABA94);
  static const Color primaryFixed = Color(0xFFDABA94);
  static const Color primaryFixedDim = Color(0xFFC8C6C5);

  // Secondary
  static const Color secondary = Color(0xFFB79975); // Muted Bronze accent
  static const Color secondaryContainer = Color(0xFF4D371B);
  static const Color onSecondary = Color(0xFF0E0E0E);
  static const Color onSecondaryContainer = Color(0xFFDABA94);
  static const Color secondaryFixed = Color(0xFFDABA94);

  // Tertiary
  static const Color tertiary = Color(0xFFACABAA);
  static const Color tertiaryContainer = Color(0xFF1F2020);
  static const Color onTertiary = Color(0xFF0E0E0E);
  static const Color onTertiaryContainer = Color(0xFFACABAA);

  // Error
  static const Color error = Color(0xFFF2B8B5);
  static const Color errorContainer = Color(0xFF8C1D18);
  static const Color onError = Color(0xFF601410);
  static const Color onErrorContainer = Color(0xFFF9DEDC);

  // Surface
  static const Color surface = Color(0xFF131313);
  static const Color surfaceBright = Color(0xFF1F2020);
  static const Color surfaceDim = Color(0xFF0E0E0E);
  static const Color surfaceContainer = Color(0xFF191A1A);
  static const Color surfaceContainerLow = Color(0xFF131313);
  static const Color surfaceContainerLowest = Color(0xFF0E0E0E);
  static const Color surfaceContainerHigh = Color(0xFF1F2020);
  static const Color surfaceContainerHighest = Color(0xFF252626); // Adjusted for distinction
  static const Color surfaceVariant = Color(0xFF1F2020);
  static const Color surfaceTint = Color(0xFFB79975);

  // On Surface
  static const Color onSurface = Color(0xFFE7E5E5);
  static const Color onSurfaceVariant = Color(0xFFACABAA);
  static const Color onBackground = Color(0xFFE7E5E5);
  static const Color background = Color(0xFF0E0E0E);

  // Outline
  static const Color outline = Color(0xFF484848);
  static const Color outlineVariant = Color(0x33484848); // Outline Variant at ~20% opacity for Ghost Borders

  // Inverse
  static const Color inverseSurface = Color(0xFFE7E5E5);
  static const Color inverseOnSurface = Color(0xFF131313);
  static const Color inversePrimary = Color(0xFF131313);

  // Semantic
  static const Color success = Color(0xFF16A34A);
  static const Color successContainer = Color(0xFFDCFCE7);

  // Leather gradient for CTAs (Machined Metal finish per theme)
  static const LinearGradient leatherGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFC8C6C5), Color(0xFFBAB8B8)], // primary to primary-dim
  );
}
