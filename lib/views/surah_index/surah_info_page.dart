import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_styles.dart';
import '../../models/surah_index_entry.dart';

class SurahInfoPage extends StatelessWidget {
  const SurahInfoPage({super.key, required this.entry});

  final SurahIndexEntry entry;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Surah Info'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color(0xFFA9803E),
                    AppColors.gold,
                    Color(0xFFF6E7BE),
                    AppColors.gold,
                    Color(0xFF8F6B32),
                  ],
                  stops: <double>[0.0, 0.28, 0.5, 0.72, 1.0],
                ),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.gold.withValues(alpha: 0.45)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.shadow.withValues(alpha: 0.28),
                    blurRadius: 24.r,
                    offset: Offset(0, 12.h),
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 48.r,
                    width: 48.r,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceOverlay,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surfaceOverlay.withValues(alpha: 0.5)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${entry.number}',
                      style: textTheme.manrope16Bold.copyWith(color: AppColors.gold),
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    entry.arabicName,
                    textDirection: TextDirection.rtl,
                    style: textTheme.fraunces32Bold.copyWith(color: AppColors.surfaceOverlay),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    entry.name,
                    style: textTheme.fraunces22SemiBold.copyWith(color: AppColors.surfaceOverlay),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    entry.nameMeaning,
                    style: textTheme.manrope13Regular.copyWith(
                      color: AppColors.surfaceOverlay.withValues(alpha: 0.72),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: <Widget>[
                _MetaChip(icon: Icons.public_rounded, label: entry.revelationType),
                _MetaChip(
                  icon: Icons.format_list_numbered_rounded,
                  label: '${entry.numberOfAyah} Ayahs',
                ),
                _MetaChip(icon: Icons.menu_book_rounded, label: 'Page ${entry.startPage}'),
              ],
            ),
            SizedBox(height: AppSpacing.lg),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surfaceRaised,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.gold.withValues(alpha: 0.12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'SUMMARY',
                    style: textTheme.manrope12SemiBold.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    entry.surahSummary,
                    style: textTheme.manrope14Regular.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => context.push('/quran-reader', extra: entry.startPage),
                icon: const Icon(Icons.menu_book_rounded),
                label: const Text('Read this Surah'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14.r, color: AppColors.gold),
          SizedBox(width: 6.w),
          Text(
            label,
            style: textTheme.manrope12Medium.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
