import 'package:flutter/material.dart';

class SpexColors {
  // Professional SPEX.AI Palette
  static const Color spexBg = Color(0xFF050508);
  static const Color spexSurface = Color.fromRGBO(255, 255, 255, 0.03);
  static const Color spexYellow = Color(0xFFfcee0a); // Primary Accent
  static const Color spexCyan = Color(0xFF00f0ff); // Secondary Accent
  static const Color spexWhite = Color(0xFFFFFFFF);
  static const Color spexBorder = Color.fromRGBO(255, 255, 255, 0.1);
  static const Color spexTextSecondary = Color.fromRGBO(255, 255, 255, 0.5);

  // Message Bubbles
  static const Color botMessageBg = Color(0xFF11111a);
  static const Color userMessageBg = Color.fromRGBO(255, 255, 255, 0.05);

  // Gradients
  static const List<Color> backgroundGradient = [
    Color(0xFF11111a),
    Color(0xFF050508),
  ];

  // Interactive States
  static const Color activeChip = Color.fromRGBO(0, 240, 255, 0.1);
  static const Color yellowButton = spexYellow;

  static const Color spexDarkBg = Color(0xFF0A0A0F);
  static const Color spexCardBg = Color(0xFF11111A);
  static const Color spexInputBg = Color(0xFF1A1A24);
  static const Color spexPurpleAccent = Color(0xFF9D4EDD);
  static const Color spexPinkAccent = Color(0xFFFF006E);
  static const Color spexGreenAccent = Color(0xFF00FF88);
  static const Color spexBlueAccent = Color(0xFF00BBF9);
  static const Color spexTextDim = Color(0xFF8A8A9D);

  // Gradient colors
  static const List<Color> purplePinkGradient = [
    Color(0xFF9D4EDD),
    Color(0xFFFF006E),
  ];

  static const List<Color> blueGreenGradient = [
    Color(0xFF00BBF9),
    Color(0xFF00FF88),
  ];
}

class SpexTheme {
  static ThemeData get theme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: SpexColors.spexBg,
      colorScheme: ColorScheme.dark(
        primary: SpexColors.spexYellow,
        secondary: SpexColors.spexCyan,
        background: SpexColors.spexBg,
        surface: SpexColors.spexSurface,
        onBackground: SpexColors.spexWhite,
        onSurface: SpexColors.spexWhite,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Orbitron',
          fontSize: 36,
          fontWeight: FontWeight.w800,
          color: SpexColors.spexWhite,
          letterSpacing: -1,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w300,
          color: SpexColors.spexWhite,
          height: 1.6,
          letterSpacing: 0.2,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: SpexColors.spexTextSecondary,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Orbitron',
          fontSize: 10,
          letterSpacing: 2.0,
          fontWeight: FontWeight.w500,
          color: SpexColors.spexWhite,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w600,
          color: SpexColors.spexTextSecondary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        hintStyle: TextStyle(
          color: SpexColors.spexWhite.withOpacity(0.3),
          fontWeight: FontWeight.w300,
          fontSize: 14,
        ),
      ),
    );
  }

  // Glass Effect Box Decoration
  static BoxDecoration get glassBox => BoxDecoration(
    color: SpexColors.spexSurface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: SpexColors.spexBorder, width: 1),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.4),
        blurRadius: 30,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration get gradientBorderCard => BoxDecoration(
    color: SpexColors.spexCardBg,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        SpexColors.spexPurpleAccent.withOpacity(0.1),
        SpexColors.spexPinkAccent.withOpacity(0.1),
      ],
    ),
  );
  static BoxDecoration get neonGlowBorder => BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: SpexColors.spexPurpleAccent, width: 1.5),
    boxShadow: [
      BoxShadow(
        color: SpexColors.spexPurpleAccent.withOpacity(0.3),
        blurRadius: 10,
        spreadRadius: 2,
      ),
    ],
  );
  // Cyan Glow Border
  static BoxDecoration get cyanGlowBorder => BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: SpexColors.spexCyan.withOpacity(0.5), width: 1),
    boxShadow: [
      BoxShadow(color: SpexColors.spexCyan.withOpacity(0.15), blurRadius: 15),
    ],
  );

  // Status Badge
  static BoxDecoration get statusBadge => BoxDecoration(
    color: SpexColors.spexCyan.withOpacity(0.05),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: SpexColors.spexCyan.withOpacity(0.2), width: 1),
  );

  // Quick Action Chip
  static BoxDecoration get actionChip => BoxDecoration(
    color: SpexColors.userMessageBg,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: SpexColors.spexBorder, width: 1),
  );

  // Active Chip (Hover State)
  static BoxDecoration get activeActionChip => BoxDecoration(
    color: SpexColors.activeChip,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: SpexColors.spexCyan.withOpacity(0.5), width: 1),
  );
}
