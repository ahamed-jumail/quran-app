import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_styles.dart';
import '../../../models/juz_index_entry.dart';

/// A single Juz row. Unlike [SurahTile], there's no menu — the whole card
/// is one tap target that jumps straight to that Juz's starting page.
class JuzTile extends StatelessWidget {
  const JuzTile({super.key, required this.entry, required this.onTap});

  final JuzIndexEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Material(
      color: AppColors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.gold.withValues(alpha: 0.08),
        highlightColor: AppColors.gold.withValues(alpha: 0.04),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.surfaceRaised,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.10)),
          ),
          child: Row(
            children: <Widget>[
              Container(
                height: 42.r,
                width: 42.r,
                decoration: BoxDecoration(
                  color: AppColors.surfaceOverlay,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.28)),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${entry.number}',
                  style: textTheme.manrope14Bold.copyWith(color: AppColors.gold),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Juz ${entry.number}',
                      style: textTheme.manrope12SemiBold.copyWith(
                        color: AppColors.gold,
                        letterSpacing: 0.6,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      entry.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.fraunces18SemiBold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Starts at page ${entry.startPage}',
                      style: textTheme.manrope12Regular.copyWith(
                        color: AppColors.textSecondary.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Container(
                height: 30.r,
                width: 30.r,
                decoration: BoxDecoration(
                  color: AppColors.surfaceOverlay,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                ),
                child: Icon(Icons.arrow_forward_rounded, color: AppColors.gold, size: 15.r),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
