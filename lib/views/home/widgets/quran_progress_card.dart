import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_styles.dart';

class QuranProgressCard extends StatelessWidget {
  const QuranProgressCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.progress = 0.0,
    this.progressLabel = 'Begin',
  });

  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final double progress;
  final String progressLabel;

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
        splashColor: AppColors.surfaceOverlay.withValues(alpha: 0.10),
        highlightColor: AppColors.surfaceOverlay.withValues(alpha: 0.05),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 12.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
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
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.45)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.28),
                blurRadius: 24.r,
                offset: Offset(0, 12.h),
              ),
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.18),
                blurRadius: 18.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool compact = constraints.maxHeight < 100;

              final double ringSize = compact ? 34.r : 46.r;
              final double arrowSize = compact ? 26.r : 34.r;

              return Row(
                children: <Widget>[
                  SizedBox(
                    height: ringSize,
                    width: ringSize,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          strokeWidth: compact ? 3.r : 3.5.r,
                          backgroundColor: AppColors.surfaceOverlay.withValues(
                            alpha: 0.18,
                          ),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.surfaceOverlay,
                          ),
                        ),
                        Text(
                          progressLabel,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: textTheme.manrope10Medium.copyWith(
                            color: AppColors.surfaceOverlay,
                            fontSize: compact ? 7.5.sp : 9.5.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // Title. FittedBox rather than ellipsis so the full
                        // title always reads, just scaled down if the row
                        // (shared with the ring and arrow button) is tight.
                        SizedBox(
                          width: double.infinity,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              title,
                              maxLines: 1,
                              softWrap: false,
                              style: textTheme.fraunces20SemiBold.copyWith(
                                color: AppColors.surfaceOverlay,
                                fontSize: compact ? 15.sp : 19.sp,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: compact ? 2.h : 4.h),
                        // Subtitle.
                        SizedBox(
                          width: double.infinity,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              subtitle,
                              maxLines: 1,
                              softWrap: false,
                              style: textTheme.manrope13Regular.copyWith(
                                color: AppColors.surfaceOverlay.withValues(
                                  alpha: 0.72,
                                ),
                                fontSize: compact ? 10.5.sp : 13.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Container(
                    height: arrowSize,
                    width: arrowSize,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceOverlay,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.gold,
                      size: compact ? 16.r : 18.r,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
