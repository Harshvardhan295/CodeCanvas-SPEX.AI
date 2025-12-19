// lib/utils/AppColors.dart
import 'package:flutter/material.dart';

class AppColors {
  // lib/utils/AppColors.dart
  // Add these to your existing AppColors class

  // Chat Preview Specific
  static const Color chatUserQuestion = navyBlue;
  static const Color chatBotResponse = charcoal;
  static const Color chatSourceBackground = Color(0xFFF0F9FF);
  static const Color chatBorder = Color(0xFFE3F2FD);

  // Enterprise Badge
  static const Color enterpriseBadge = Color(0xFF673AB7);
  static const Color enterpriseBadgeLight = Color(0xFFF3E5F5);

  // Section Backgrounds
  static const Color sectionBackgroundLight = Color(0xFFF8F9FA);
  static const Color sectionBackgroundAlt = Color(0xFFF5F7FA);

  // Primary Colors
  static const Color navyBlue = Color(0xFF0B3C5D);
  static const Color teal = Color(0xFF1ECAD3);
  static const Color softGreen = Color(0xFF4CAF50);

  // Navy Blue Variants (for gradients and shades)
  static const Color navyBlueLight = Color(0xFF1A4C6D);
  static const Color navyBlueDark = Color(0xFF092D4A);
  static const Color navyBlueExtraDark = Color(0xFF071E32);

  // Teal Variants
  static const Color tealLight = Color(0xFF3AE4ED);
  static const Color tealDark = Color(0xFF18AAB3);
  static const Color tealExtraLight = Color(0xFFE8F9FA);

  // Soft Green Variants
  static const Color softGreenLight = Color(0xFF6BCF6F);
  static const Color softGreenDark = Color(0xFF3B9E40);
  static const Color softGreenExtraLight = Color(0xFFE8F5E9);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFFAFAFA);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color gray = Color(0xFF9E9E9E);
  static const Color darkGray = Color(0xFF616161);
  static const Color charcoal = Color(0xFF333333);
  static const Color black = Color(0xFF000000);

  // Semantic Colors (from UI preview analysis)
  static const Color success = softGreen;
  static const Color info = teal;
  static const Color warning = Color(0xFFFFB74D);
  static const Color error = Color(0xFFEF5350);

  // Background Colors
  static const Color background = white;
  static const Color backgroundAlt = offWhite;
  static const Color surface = Color(0xFFF8F9FA);
  static const Color cardBackground = white;

  // Text Colors
  static const Color textPrimary = charcoal;
  static const Color textSecondary = darkGray;
  static const Color textTertiary = gray;
  static const Color textInverse = white;
  static const Color textLink = navyBlue;
  static const Color textLinkHover = teal;

  // Border Colors
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderMedium = Color(0xFFBDBDBD);
  static const Color borderFocus = teal;

  // Shadow Colors (for subtle shadows)
  static const Color shadowLight = Color(0x1A000000); // 10% opacity
  static const Color shadowMedium = Color(0x33000000); // 20% opacity
  static const Color shadowDark = Color(0x66000000); // 40% opacity

  // Interactive States
  static const Color buttonPrimary = navyBlue;
  static const Color buttonPrimaryHover = navyBlueLight;
  static const Color buttonPrimaryActive = navyBlueDark;
  static const Color buttonSecondary = teal;
  static const Color buttonSecondaryHover = tealLight;
  static const Color buttonSecondaryActive = tealDark;

  // Chat UI Specific Colors (from preview)
  static const Color chatUserBubble = tealExtraLight;
  static const Color chatBotBubble = Color(0xFFF0F7FF);
  static const Color chatSourceTag = Color(0xFFE3F2FD);
  static const Color chatSourceText = Color(0xFF1976D2);

  // Feature Card Colors (for Key Features section)
  static const Color featureCard1 = Color(0xFFE8F5E9); // Green tint
  static const Color featureCard2 = Color(0xFFE3F2FD); // Blue tint
  static const Color featureCard3 = Color(0xFFF3E5F5); // Purple tint
  static const Color featureCard4 = Color(0xFFFFF3E0); // Orange tint
  static const Color featureCard5 = Color(0xFFFCE4EC); // Pink tint
  static const Color featureCard6 = Color(0xFFE8EAF6); // Indigo tint

  // Industry Section Colors (from Built for Every Industry)
  static const Color industryGovernment = Color(0xFFE8F5E9);
  static const Color industryEducation = Color(0xFFE3F2FD);
  static const Color industryEnterprise = Color(0xFFFFF3E0);
  static const Color industryStartup = Color(0xFFF3E5F5);

  // Step Indicator Colors (for How It Works section)
  static const Color stepActive = teal;
  static const Color stepCompleted = softGreen;
  static const Color stepUpcoming = Color(0xFFE0E0E0);

  // Gradient Combinations
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [navyBlue, navyBlueLight],
  );

  static const LinearGradient tealGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [teal, tealLight],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF8F9FA), Color(0xFFE8F5E9)],
  );

  // Chip/Category Colors
  static const Color chipBackground = Color(0xFFE8F5E9);
  static const Color chipText = softGreenDark;
  static const Color tagBackground = tealExtraLight;
  static const Color tagText = tealDark;

  // Transparent Overlays
  static const Color overlayLight = Color(0x0A000000); // 4% opacity
  static const Color overlayMedium = Color(0x1A000000); // 10% opacity
  static const Color overlayDark = Color(0x66000000); // 40% opacity

  // Accessibility
  static Color get textPrimaryAccessible => navyBlueExtraDark;
  static Color get textOnPrimary => white;
  static Color get textOnTeal => navyBlueExtraDark;
  static Color get focusRing => teal.withOpacity(0.5);

  // Utility method to get industry color by index
  static Color getIndustryColor(int index) {
    final colors = [
      industryGovernment,
      industryEducation,
      industryEnterprise,
      industryStartup,
    ];
    return colors[index % colors.length];
  }

  // Utility method to get feature card color by index
  static Color getFeatureCardColor(int index) {
    final colors = [
      featureCard1,
      featureCard2,
      featureCard3,
      featureCard4,
      featureCard5,
      featureCard6,
    ];
    return colors[index % colors.length];
  }

  // Dark mode colors (optional - for future theming)
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFE0E0E0);
}
