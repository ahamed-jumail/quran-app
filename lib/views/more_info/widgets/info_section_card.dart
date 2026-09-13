import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_styles.dart';

/// A titled card used to group related content on the About Quran / Waqf
/// Rules pages — matches the "SUMMARY" card style already used on
/// [SurahInfoPage].
class InfoSectionCard extends StatelessWidget {
  const InfoSectionCard({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
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
            title.toUpperCase(),
            style: textTheme.manrope12SemiBold.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

/// A single "label / value" fact row, stacked so long values wrap cleanly.
class FactRow extends StatelessWidget {
  const FactRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: textTheme.manrope12SemiBold.copyWith(color: AppColors.gold),
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: textTheme.manrope13Regular.copyWith(
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A small pill chip, used for stats and name lists.
class InfoChip extends StatelessWidget {
  const InfoChip({super.key, required this.label, this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 8.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surfaceOverlay,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.22)),
      ),
      child: value == null
          ? Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.manrope12Medium.copyWith(color: AppColors.textPrimary),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  value!,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: textTheme.fraunces18SemiBold.copyWith(color: AppColors.gold),
                ),
                SizedBox(height: 2.h),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.manrope10Regular.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
    );
  }
}

/// Lays out [itemCount] equal-width cells, [columns] per row, filling the
/// available width. A trailing incomplete row is centred rather than
/// stretched, so its cells stay the same width as a full row's.
class EqualWidthGrid extends StatelessWidget {
  const EqualWidthGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.columns,
    this.spacing = 8,
    this.runSpacing = 8,
  });

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final int columns;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double totalSpacing = spacing * (columns - 1);
        final double cellWidth = (constraints.maxWidth - totalSpacing) / columns;

        final List<Widget> rows = <Widget>[];
        for (int i = 0; i < itemCount; i += columns) {
          final int end = (i + columns) > itemCount ? itemCount : i + columns;
          rows.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (int j = i; j < end; j++) ...<Widget>[
                  if (j > i) SizedBox(width: spacing),
                  SizedBox(width: cellWidth, child: itemBuilder(context, j)),
                ],
              ],
            ),
          );
          if (end < itemCount) {
            rows.add(SizedBox(height: runSpacing));
          }
        }
        return Column(children: rows);
      },
    );
  }
}
