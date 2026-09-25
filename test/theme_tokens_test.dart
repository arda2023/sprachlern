import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('AppColors', () {
    test('1.1 Basis colors match design.md', () {
      expect(AppColors.bg, const Color(0xFF12222E));
      expect(AppColors.surface, const Color(0xFF2C3143));
      expect(AppColors.surface2, const Color(0xFF424960));
      expect(AppColors.surface3, const Color(0xFF3B3F58));
      expect(AppColors.field, const Color(0xFF344557));
      expect(AppColors.scrim, const Color.fromRGBO(255, 255, 255, 0.33));
      expect(AppColors.white, const Color(0xFFFFFFFF));
    });

    test('1.2 Akzente match design.md', () {
      expect(AppColors.cyan, const Color(0xFF6CD5E5));
      expect(AppColors.cyanDark, const Color(0xFF5293A3));
      expect(AppColors.cyanIcon, const Color(0xFF63E1E7));
      expect(AppColors.cyanFillSoft, const Color(0xFF84EBEE));
      expect(AppColors.tealPill, const Color(0xFF037889));
      expect(AppColors.lilac, const Color(0xFFE2B4FF));
      expect(AppColors.lilacSoft, const Color(0xFFDDC3F4));
      expect(AppColors.purple, const Color(0xFFAC6ED1));
      expect(AppColors.purpleCover, const Color(0xFFBC99D8));
      expect(AppColors.periwinkle, const Color(0xFF8EA3EE));
      expect(AppColors.orange, const Color(0xFFFAAA5A));
      expect(AppColors.blueLink, const Color(0xFF00B8FF));
    });

    test('1.3 Semantik / Status match design.md', () {
      expect(AppColors.success, const Color(0xFF43D281));
      expect(AppColors.successDark, const Color(0xFF378262));
      expect(AppColors.error, const Color(0xFFFE5C55));
      expect(AppColors.trackOff, const Color(0xFF323D48));
    });

    test('1.4 Text & Icons match design.md', () {
      expect(AppColors.text, const Color(0xFFFFFFFF));
      expect(AppColors.textMuted, const Color(0xFFB2B8CB));
      expect(AppColors.textOnLight, const Color(0xFF2C3143));
      expect(AppColors.textEn, const Color(0xFF6CD5E5));
      expect(AppColors.iconDim, const Color(0xFF565A68));
      expect(AppColors.iconBolt, const Color(0xFFA0A6AB));
      expect(AppColors.iconBoltOff, const Color(0xFF414E58));
    });

    test('1.5 Helles Theme match design.md', () {
      expect(AppColors.lightBg, const Color(0xFFFFFFFF));
      expect(AppColors.lightText, const Color(0xFF333B44));
      expect(AppColors.lightEn, const Color(0xFF338C99));
      expect(AppColors.lightBorder, const Color(0xFFCECECE));
    });
  });

  group('AppTextStyles', () {
    test('14 styles exist and match specification', () {
      // display (24 / 28, Sans 500)
      expect(AppTextStyles.display.fontSize, 24);
      expect(AppTextStyles.display.height, 28 / 24);
      expect(AppTextStyles.display.fontWeight, FontWeight.w500);
      expect(AppTextStyles.display.color, isNull);

      // navTitle (17 / 22, Sans 400)
      expect(AppTextStyles.navTitle.fontSize, 17);
      expect(AppTextStyles.navTitle.height, 22 / 17);
      expect(AppTextStyles.navTitle.fontWeight, FontWeight.w400);
      expect(AppTextStyles.navTitle.color, isNull);

      // section (15 / 20, Sans 400)
      expect(AppTextStyles.section.fontSize, 15);
      expect(AppTextStyles.section.height, 20 / 15);
      expect(AppTextStyles.section.fontWeight, FontWeight.w400);
      expect(AppTextStyles.section.color, isNull);

      // title (17 / 22, Sans 500)
      expect(AppTextStyles.title.fontSize, 17);
      expect(AppTextStyles.title.height, 22 / 17);
      expect(AppTextStyles.title.fontWeight, FontWeight.w500);
      expect(AppTextStyles.title.color, isNull);

      // body (16 / 20, Sans 400)
      expect(AppTextStyles.body.fontSize, 16);
      expect(AppTextStyles.body.height, 20 / 16);
      expect(AppTextStyles.body.fontWeight, FontWeight.w400);
      expect(AppTextStyles.body.color, isNull);

      // bodySm (14 / 16, Sans 400)
      expect(AppTextStyles.bodySm.fontSize, 14);
      expect(AppTextStyles.bodySm.height, 16 / 14);
      expect(AppTextStyles.bodySm.fontWeight, FontWeight.w400);
      expect(AppTextStyles.bodySm.color, isNull);

      // meta (13 / 16, Sans 400)
      expect(AppTextStyles.meta.fontSize, 13);
      expect(AppTextStyles.meta.height, 16 / 13);
      expect(AppTextStyles.meta.fontWeight, FontWeight.w400);
      expect(AppTextStyles.meta.color, isNull);

      // caption (12 / 14, Sans 400)
      expect(AppTextStyles.caption.fontSize, 12);
      expect(AppTextStyles.caption.height, 14 / 12);
      expect(AppTextStyles.caption.fontWeight, FontWeight.w400);
      expect(AppTextStyles.caption.color, isNull);

      // stat (18 / 24, Sans 400)
      expect(AppTextStyles.stat.fontSize, 18);
      expect(AppTextStyles.stat.height, 24 / 18);
      expect(AppTextStyles.stat.fontWeight, FontWeight.w400);
      expect(AppTextStyles.stat.color, isNull);

      // statLg (24 / 28, Sans 400)
      expect(AppTextStyles.statLg.fontSize, 24);
      expect(AppTextStyles.statLg.height, 28 / 24);
      expect(AppTextStyles.statLg.fontWeight, FontWeight.w400);
      expect(AppTextStyles.statLg.color, isNull);

      // sentence (28 / 36, Serif 400, cyan)
      expect(AppTextStyles.sentence.fontSize, 28);
      expect(AppTextStyles.sentence.height, 36 / 28);
      expect(AppTextStyles.sentence.fontWeight, FontWeight.w400);
      expect(AppTextStyles.sentence.color, AppColors.cyan);

      // enHeadword (24 / 28, Serif 400, cyan)
      expect(AppTextStyles.enHeadword.fontSize, 24);
      expect(AppTextStyles.enHeadword.height, 28 / 24);
      expect(AppTextStyles.enHeadword.fontWeight, FontWeight.w400);
      expect(AppTextStyles.enHeadword.color, AppColors.cyan);

      // enLine (20 / 22, Serif 400, cyan)
      expect(AppTextStyles.enLine.fontSize, 20);
      expect(AppTextStyles.enLine.height, 22 / 20);
      expect(AppTextStyles.enLine.fontWeight, FontWeight.w400);
      expect(AppTextStyles.enLine.color, AppColors.cyan);

      // read (20 / 36, Sans 400)
      expect(AppTextStyles.read.fontSize, 20);
      expect(AppTextStyles.read.height, 36 / 20);
      expect(AppTextStyles.read.fontWeight, FontWeight.w400);
      expect(AppTextStyles.read.color, isNull);
    });
  });

  group('AppSpacing', () {
    test('Spacing scale values match design.md 3.1', () {
      expect(AppSpacing.s4, 4.0);
      expect(AppSpacing.s8, 8.0);
      expect(AppSpacing.s12, 12.0);
      expect(AppSpacing.s16, 16.0);
      expect(AppSpacing.s24, 24.0);
      expect(AppSpacing.s32, 32.0);
      expect(AppSpacing.s40, 40.0);
    });

    test('Corner radii values match design.md 3.3', () {
      expect(AppSpacing.small, 8.0);
      expect(AppSpacing.radiusSmall, 8.0);
      expect(AppSpacing.medium, 12.0);
      expect(AppSpacing.radiusMedium, 12.0);
      expect(AppSpacing.sheet, 16.0);
      expect(AppSpacing.radiusSheet, 16.0);
      expect(AppSpacing.pill, 9999.0);
      expect(AppSpacing.radiusPill, 9999.0);
      expect(AppSpacing.radiusXs, 4.0);
      expect(AppSpacing.radiusBadge, 6.0);
    });
  });
}
