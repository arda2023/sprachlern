import 'package:flutter/material.dart';

/// Design system color tokens from design.md (Sections 1.1–1.5).
abstract final class AppColors {
  // 1.1 Basis (Dark Theme)
  static const Color bg = Color(0xFF12222E);
  static const Color surface = Color(0xFF2C3143);
  static const Color surface2 = Color(0xFF424960);
  static const Color surface3 = Color(0xFF3B3F58);
  static const Color field = Color(0xFF344557);
  static const Color flagBorder = Color(0xFF3A475F);
  static const Color scrim = Color.fromRGBO(255, 255, 255, 0.33);
  static const Color white = Color(0xFFFFFFFF);

  // 1.2 Akzente
  static const Color cyan = Color(0xFF6CD5E5);
  static const Color cyanDark = Color(0xFF5293A3);
  static const Color cyanIcon = Color(0xFF63E1E7);
  static const Color cyanFillSoft = Color(0xFF84EBEE);
  static const Color tealPill = Color(0xFF037889);
  static const Color lilac = Color(0xFFE2B4FF);
  static const Color lilacSoft = Color(0xFFDDC3F4);
  static const Color purple = Color(0xFFAC6ED1);
  static const Color purpleCover = Color(0xFFBC99D8);
  static const Color periwinkle = Color(0xFF8EA3EE);
  static const Color orange = Color(0xFFFAAA5A);
  static const Color blueLink = Color(0xFF00B8FF);

  // 1.3 Semantik / Status
  static const Color success = Color(0xFF43D281);
  static const Color successDark = Color(0xFF378262);
  static const Color error = Color(0xFFFE5C55);
  static const Color trackOff = Color(0xFF323D48);

  // 1.4 Text & Icons
  static const Color text = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFFB2B8CB);
  static const Color textOnLight = Color(0xFF2C3143);
  static const Color textEn = Color(0xFF6CD5E5);
  static const Color iconDim = Color(0xFF565A68);
  static const Color iconBolt = Color(0xFFA0A6AB);
  static const Color iconBoltOff = Color(0xFF414E58);

  // 1.5 Helles Theme (Grammatik-Erklärung)
  static const Color lightBg = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF333B44);
  static const Color lightEn = Color(0xFF338C99);
  static const Color lightBorder = Color(0xFFCECECE);
}
