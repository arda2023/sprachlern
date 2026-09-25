import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Design system typography tokens from design.md (Section 2).
///
/// UI / German text uses "Figtree" (Sans).
/// English learning content uses "Source Serif 4" (Serif).
abstract final class AppTextStyles {
  /// Display: 24 / 28, Sans 500
  /// Used for: Large page titles ("Inhalte", stack title, sheet title)
  static final TextStyle display = GoogleFonts.figtree(
    fontSize: 24,
    height: 28 / 24,
    fontWeight: FontWeight.w500,
  );

  /// Nav Title: 17 / 22, Sans 400
  /// Used for: Centered title of the top bar ("Stapel", "Grammatik")
  static final TextStyle navTitle = GoogleFonts.figtree(
    fontSize: 17,
    height: 22 / 17,
    fontWeight: FontWeight.w400,
  );

  /// Section: 15 / 20, Sans 400 (UPPERCASE)
  /// Used for: Section headers ("HEUTIGES ZIEL", "MEINE FORTSCHRITTE")
  static final TextStyle section = GoogleFonts.figtree(
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w400,
  );

  /// Title: 17 / 22, Sans 500
  /// Used for: Card titles, list titles, button labels, large nav labels
  static final TextStyle title = GoogleFonts.figtree(
    fontSize: 17,
    height: 22 / 17,
    fontWeight: FontWeight.w500,
  );

  /// Body: 16 / 20, Sans 400
  /// Used for: Body text in cards and sheets
  static final TextStyle body = GoogleFonts.figtree(
    fontSize: 16,
    height: 20 / 16,
    fontWeight: FontWeight.w400,
  );

  /// Body Small: 14 / 16, Sans 400
  /// Used for: Descriptions (settings), stat labels, subtitles
  static final TextStyle bodySm = GoogleFonts.figtree(
    fontSize: 14,
    height: 16 / 14,
    fontWeight: FontWeight.w400,
  );

  /// Meta: 13 / 16, Sans 400
  /// Used for: "Zuletzt gesehen …", "Grammatik | Level 1"
  static final TextStyle meta = GoogleFonts.figtree(
    fontSize: 13,
    height: 16 / 13,
    fontWeight: FontWeight.w400,
  );

  /// Caption: 12 / 14, Sans 400
  /// Used for: Labels of the bottom navigation
  static final TextStyle caption = GoogleFonts.figtree(
    fontSize: 12,
    height: 14 / 12,
    fontWeight: FontWeight.w400,
  );

  /// Stat: 18 / 24, Sans 400
  /// Used for: Numbers in stat cards
  static final TextStyle stat = GoogleFonts.figtree(
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w400,
  );

  /// Stat Large: 24 / 28, Sans 400
  /// Used for: Values on the right of sheet rows ("1.456")
  static final TextStyle statLg = GoogleFonts.figtree(
    fontSize: 24,
    height: 28 / 24,
    fontWeight: FontWeight.w400,
  );

  /// Sentence: 28 / 36, Serif 400, cyan
  /// Used for: Fill-in-the-blank sentence on the practice card
  static final TextStyle sentence = GoogleFonts.sourceSerif4(
    fontSize: 28,
    height: 36 / 28,
    fontWeight: FontWeight.w400,
    color: AppColors.cyan,
  );

  /// English Headword: 24 / 28, Serif 400, cyan
  /// Used for: Word in word list, word in info sheet
  static final TextStyle enHeadword = GoogleFonts.sourceSerif4(
    fontSize: 24,
    height: 28 / 24,
    fontWeight: FontWeight.w400,
    color: AppColors.cyan,
  );

  /// English Line: 20 / 22, Serif 400, cyan
  /// Used for: Example sentences, answer options
  static final TextStyle enLine = GoogleFonts.sourceSerif4(
    fontSize: 20,
    height: 22 / 20,
    fontWeight: FontWeight.w400,
    color: AppColors.cyan,
  );

  /// Read: 20 / 36, Sans 400
  /// Used for: Reading text of the text exercise (deliberately airy)
  static final TextStyle read = GoogleFonts.figtree(
    fontSize: 20,
    height: 36 / 20,
    fontWeight: FontWeight.w400,
  );
}
