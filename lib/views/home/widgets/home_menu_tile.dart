import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_styles.dart';

class HomeMenuTile extends StatelessWidget {
  const HomeMenuTile({
    super.key,
    required this.icon,
    required this.label,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Material(
      color: AppColors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.surfaceRaised,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: AppColors.gold.withValues(alpha: 0.10),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.22),
                blurRadius: 18.r,
                offset: Offset(0, 8.h),
              ),
            ],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 48.r,
                  width: 48.r,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceOverlay,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.18),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.06),
                        blurRadius: 12.r,
                        spreadRadius: 1.r,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: AppColors.gold, size: 23.r),
                ),
                SizedBox(height: 8.h),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: textTheme.manrope12Medium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: textTheme.manrope10Regular.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
