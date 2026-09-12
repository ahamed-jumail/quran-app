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
          padding: EdgeInsets.all(AppSpacing.lg),
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
              final bool compact = constraints.maxHeight < 190;

              final double iconSize = compact ? 48.r : 54.r;
              final double arrowSize = compact ? 34.r : 38.r;

              return Stack(
                children: <Widget>[
                  // Small ornamental glow.
                  Positioned(
                    right: 20.r,
                    top: 18.r,
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: AppColors.surfaceOverlay.withValues(alpha: 0.3),
                      size: 18.r,
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Top row.
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: iconSize,
                            width: iconSize,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceOverlay,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              border: Border.all(
                                color: AppColors.gold.withValues(alpha: 0.25),
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: AppColors.gold.withValues(alpha: 0.22),
                                  blurRadius: 14.r,
                                  offset: Offset(0, 5.h),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.menu_book_rounded,
                              color: AppColors.gold,
                              size: compact ? 24.r : 27.r,
                            ),
                          ),

                          const Spacer(),

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
                              size: compact ? 17.r : 19.r,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: compact ? 7.h : 10.h),

                      // Bismillah.
                      SizedBox(
                        width: double.infinity,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                            textDirection: TextDirection.rtl,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(
                              fontSize: compact ? 16.sp : 18.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.surfaceOverlay,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: compact ? 2.h : 4.h),

                      // Title.
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.fraunces20SemiBold.copyWith(
                          color: AppColors.surfaceOverlay,
                          fontSize: compact ? 19.sp : 20.sp,
                          height: 1.1,
                        ),
                      ),

                      SizedBox(height: compact ? 2.h : 4.h),

                      // Subtitle.
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.manrope13Regular.copyWith(
                          color: AppColors.surfaceOverlay.withValues(
                            alpha: 0.72,
                          ),
                          fontSize: compact ? 12.sp : 13.sp,
                        ),
                      ),

                      SizedBox(height: compact ? 7.h : 11.h),

                      // Progress indicator.
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              height: compact ? 2.5.h : 3.h,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceOverlay.withValues(
                                  alpha: 0.16,
                                ),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: progress.clamp(0.0, 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceOverlay,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: AppSpacing.sm),
                          Text(
                            progressLabel,
                            style: textTheme.manrope10Medium.copyWith(
                              color: AppColors.surfaceOverlay.withValues(
                                alpha: 0.72,
                              ),
                              fontSize: compact ? 10.sp : 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
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
