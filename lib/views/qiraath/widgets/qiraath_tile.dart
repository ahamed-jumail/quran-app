import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/bloc/qiraath/qiraath_cubit.dart';
import '../../../core/bloc/qiraath/qiraath_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_styles.dart';
import '../../../models/quran_reader_route_args.dart';
import '../../../models/surah_index_entry.dart';

/// A single Surah row on the Quran Qirath list. Tapping the row body opens
/// the Quran reader at that Surah's start page (qirath keeps playing in the
/// background); tapping the trailing button plays this Surah, or toggles
/// play/pause if it's already the one active.
///
/// Main content and trailing control are siblings, each in their own
/// Material/InkWell, matching SurahTile — nesting them causes the gesture
/// arena to resolve the winner non-deterministically.
class QiraathTile extends StatelessWidget {
  const QiraathTile({super.key, required this.entry});

  final SurahIndexEntry entry;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Material(
              color: AppColors.transparent,
              child: InkWell(
                onTap: () => context.push(
                  '/quran-reader',
                  extra: QuranReaderRouteArgs(initialPage: entry.startPage),
                ),
                splashColor: AppColors.gold.withValues(alpha: 0.08),
                highlightColor: AppColors.gold.withValues(alpha: 0.04),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12.h),
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
                              entry.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.fraunces18SemiBold.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              '${entry.numberOfAyah} Ayahs',
                              style: textTheme.manrope12Regular.copyWith(
                                color: AppColors.textSecondary.withValues(alpha: 0.75),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.md),
            child: BlocBuilder<QiraathCubit, QiraathState>(
              builder: (BuildContext context, QiraathState state) {
                final bool isCurrent = state.currentSurahNumber == entry.number;
                final bool isPlaying = isCurrent && state.isPlaying;
                return Material(
                  color: AppColors.transparent,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      final QiraathCubit cubit = context.read<QiraathCubit>();
                      if (isCurrent) {
                        cubit.togglePlayPause();
                      } else {
                        cubit.playSurah(entry.number);
                      }
                    },
                    child: Container(
                      height: 36.r,
                      width: 36.r,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? AppColors.gold
                            : AppColors.surfaceOverlay,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.gold.withValues(alpha: isCurrent ? 1 : 0.3),
                        ),
                      ),
                      child: Icon(
                        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: isCurrent ? AppColors.surfaceBase : AppColors.gold,
                        size: 18.r,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
