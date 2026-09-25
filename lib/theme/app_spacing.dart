/// Spacing, layout metrics, and corner radii from design.md (Section 3).
abstract final class AppSpacing {
  // --- 3.1 Spacing Scale (px) ---
  // All spacing in the layout is a multiple of 4.
  static const double s4 = 4.0;
  static const double s8 = 8.0;
  static const double s12 = 12.0;
  static const double s16 = 16.0;
  static const double s24 = 24.0;
  static const double s32 = 32.0;
  static const double s40 = 40.0;

  // --- Semantic Layout Spacing (3.1 & 3.2) ---
  /// Page horizontal margin everywhere (16 px)
  static const double pageMargin = 16.0;

  /// Card internal padding (16 px)
  static const double cardPadding = 16.0;

  /// Gap between stacked list cards (8 px)
  static const double listGap = 8.0;

  /// Text horizontal margin in bottom sheets, space before section headers (24 px)
  static const double sheetMargin = 24.0;

  /// Distance between major sections (32 px)
  static const double sectionGap = 32.0;

  /// Mobile base screen width (375 px)
  static const double screenWidth = 375.0;

  /// Standard content width (343 px = 375 - 2 * 16)
  static const double contentWidth = 343.0;

  // --- 3.3 Corner Radii ---
  /// Small radius: 8 px (small cards, list cards, tiles, search field, text fields, wide buttons)
  static const double small = 8.0;
  static const double radiusSmall = 8.0;

  /// Medium radius: 12 px (large content cards, cards, answer field, cover)
  static const double medium = 12.0;
  static const double radiusMedium = 12.0;

  /// Sheet radius: 16 px (bottom sheet top corners)
  static const double sheet = 16.0;
  static const double radiusSheet = 16.0;

  /// Fully rounded pill radius: 9999 px (pills, progress bars, toggle, status dots, round play buttons)
  static const double pill = 9999.0;
  static const double radiusPill = 9999.0;

  /// Extra small radius: 4 px (gap, icon tiles, badges)
  static const double radiusXs = 4.0;

  /// Badge / gap radius: 6 px (gap in sentence, weekday tile, A1 badge)
  static const double radiusBadge = 6.0;
}
