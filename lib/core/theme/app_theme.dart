import 'package:flutter/material.dart';
import 'map_controls_theme.dart';

class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F766E),
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),

      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Color(0xFFF8FAFC),
        foregroundColor: Color(0xFF0F172A),
      ),

      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[
        MapControlsTheme(
          backgroundColor: colorScheme.primary.withValues(alpha: 0.9),
          foregroundColor: colorScheme.onPrimary,
          borderColor: colorScheme.onPrimary.withValues(alpha: 0.18),
          dividerColor: colorScheme.onPrimary.withValues(alpha: 0.35),
          shadowOpacity: 0.18,
        ),
      ],
    );
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF14B8A6),
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF020617),

      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Color(0xFF020617),
        foregroundColor: Color(0xFFE5E7EB),
      ),

      cardTheme: CardThemeData(
        color: const Color(0xFF0F172A),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF1E293B)),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF0F172A),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[
        MapControlsTheme(
          backgroundColor: colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.9,
          ),
          foregroundColor: colorScheme.onSurface,
          borderColor: colorScheme.outlineVariant.withValues(alpha: 0.35),
          dividerColor: colorScheme.outlineVariant.withValues(alpha: 0.55),
          shadowOpacity: 0.28,
        ),
      ],
    );
  }
}
