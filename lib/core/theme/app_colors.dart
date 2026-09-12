import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // Surfaces (elevation hierarchy, deep desaturated emerald-black)
  static const Color surfaceBase = Color(0xFF0E1613); // scaffold background
  static const Color surfaceRaised = Color(0xFF152420); // cards, app bar, bottom nav
  static const Color surfaceOverlay = Color(0xFF1C2F29); // dialogs, sheets, popovers

  // Reserved for later phase: the parchment "reading pane" surface for Quran
  // text, deliberately warm/light against the dark shell (mushaf-page-under-
  // lamp feel).
  static const Color surfaceReading = Color(0xFFF3E9D2);

  // Brand
  static const Color emerald = Color(0xFF1F6F54); // primary
  static const Color emeraldLight = Color(0xFF2E8F6E); // hover/pressed states
  static const Color gold = Color(0xFFC9A24B); // secondary / CTA
  static const Color goldLight = Color(0xFFE3C888); // tertiary / focus rings

  // Text (on dark surfaces)
  static const Color textPrimary = Color(0xFFF3E9D2); // parchment
  static const Color textSecondary = Color(0xFFA9B8B2); // muted sage
  static const Color textDisabled = Color(0xFF5C6B65);

  // Structure
  static const Color divider = Color(0xFF2A3B35);

  // Semantic
  static const Color error = Color(0xFFE4756B); // warm coral, not cold red
  static const Color success = Color(0xFF6FCF97);
  static const Color warning = Color(0xFFE8B75D);
  static const Color info = Color(0xFF5FB8B0);

  static const Color transparent = Color(0x00000000);
  static const Color shadow = Color(0x33000000);

  // Aliases consumed by lib/shared_components/tabs/*.dart.
  static const Color tabTrack = surfaceRaised;
  static const Color tabSelectedSurface = surfaceOverlay;
  static const Color tabSelectedLabel = textPrimary;
  static const Color tabUnselectedLabel = textSecondary;
  static const Color tabIndicator = gold;
  static const Color tabShadow = shadow;
}
