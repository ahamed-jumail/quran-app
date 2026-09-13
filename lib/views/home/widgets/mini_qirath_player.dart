import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/bloc/qiraath/qiraath_cubit.dart';
import '../../../core/bloc/qiraath/qiraath_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_styles.dart';
import '../../../models/surah_index_entry.dart';
import '../../surah_index/surah_repository.dart';

String _formatDuration(Duration d) {
  final int minutes = d.inMinutes;
  final int seconds = d.inSeconds % 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}

/// A premium "now playing" card shown below the progress card on Home.
/// Reflects [QiraathCubit]'s state directly so it survives app restarts
/// (surah/reciter/position are restored by the package on init) and updates
/// live while qirath plays anywhere else in the app.
class MiniQirathPlayer extends StatelessWidget {
  const MiniQirathPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final QiraathState state = context.watch<QiraathCubit>().state;
    final int? surahNumber = state.currentSurahNumber;

    return Material(
      color: AppColors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/quran-qirath'),
        splashColor: AppColors.gold.withValues(alpha: 0.06),
        highlightColor: AppColors.gold.withValues(alpha: 0.03),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            14.h,
            AppSpacing.md,
            12.h,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceRaised,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.18)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.24),
                blurRadius: 16.r,
                offset: Offset(0, 6.h),
              ),
            ],
          ),
          child: surahNumber == null
              ? const _EmptyState()
              : _NowPlayingContent(surahNumber: surahNumber, state: state),
        ),
      ),
    );
  }
}

/// A popular Surah offered as a one-tap "quick start" in the empty state.
class _QuickStartSurah {
  const _QuickStartSurah(this.number, this.name);

  final int number;
  final String name;
}

const List<_QuickStartSurah> _kQuickStartSurahs = <_QuickStartSurah>[
  _QuickStartSurah(1, 'Al-Fatiha'),
  _QuickStartSurah(36, 'Yaseen'),
  _QuickStartSurah(67, 'Al-Mulk'),
];

/// Shown before qirath has ever been played. Matches [_NowPlayingContent]'s
/// height (header row, then a second row) so the card doesn't jump in size
/// the moment playback starts — the extra room holds one-tap shortcuts for
/// a few popular Surahs instead of sitting empty.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            const _ArtworkBadge(isPlaying: false),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Quran Qirath',
                    style: textTheme.fraunces16SemiBold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Tap to start listening to a recitation',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.manrope12Regular.copyWith(
                      color: AppColors.textSecondary.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
              size: 22.r,
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: <Widget>[
            Expanded(child: Divider(color: AppColors.gold.withValues(alpha: 0.25))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Text(
                'LISTEN INSTANTLY',
                style: textTheme.manrope10SemiBold.copyWith(
                  color: AppColors.gold.withValues(alpha: 0.85),
                  letterSpacing: 1.1,
                ),
              ),
            ),
            Expanded(child: Divider(color: AppColors.gold.withValues(alpha: 0.25))),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: <Widget>[
            for (int i = 0; i < _kQuickStartSurahs.length; i++) ...<Widget>[
              if (i > 0) SizedBox(width: AppSpacing.sm),
              Expanded(child: _QuickStartChip(surah: _kQuickStartSurahs[i])),
            ],
          ],
        ),
      ],
    );
  }
}

class _QuickStartChip extends StatelessWidget {
  const _QuickStartChip({required this.surah});

  final _QuickStartSurah surah;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Material(
      color: AppColors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: () => context.read<QiraathCubit>().playSurah(surah.number),
        child: Container(
          height: 46.r,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surfaceOverlay,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.play_arrow_rounded, color: AppColors.gold, size: 15.r),
              SizedBox(width: 2.w),
              Flexible(
                child: Text(
                  surah.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.manrope12SemiBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NowPlayingContent extends StatelessWidget {
  const _NowPlayingContent({required this.surahNumber, required this.state});

  final int surahNumber;
  final QiraathState state;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool hasDuration = state.duration > Duration.zero;
    final Duration elapsed =
        hasDuration ? state.position : Duration(seconds: state.lastKnownPositionSeconds);
    final double progress = hasDuration
        ? (elapsed.inMilliseconds / state.duration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;
    final String reciterName = state.currentReciter?.name ?? '';

    return FutureBuilder<List<SurahIndexEntry>>(
      future: SurahRepository.loadAll(),
      builder: (BuildContext context, AsyncSnapshot<List<SurahIndexEntry>> snapshot) {
        String surahName = 'Surah $surahNumber';
        if (snapshot.hasData) {
          for (final SurahIndexEntry entry in snapshot.data!) {
            if (entry.number == surahNumber) {
              surahName = entry.name;
              break;
            }
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                _ArtworkBadge(isPlaying: state.isPlaying),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'NOW PLAYING',
                        style: textTheme.manrope10SemiBold.copyWith(
                          color: AppColors.gold.withValues(alpha: 0.85),
                          letterSpacing: 1.1,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        surahName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.fraunces16SemiBold.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (reciterName.isNotEmpty) ...<Widget>[
                        SizedBox(height: 1.h),
                        Text(
                          reciterName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.manrope12Regular.copyWith(
                            color: AppColors.textSecondary.withValues(alpha: 0.75),
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: <Widget>[
                Text(
                  _formatDuration(elapsed),
                  style: textTheme.manrope10Regular.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4.h,
                      backgroundColor: AppColors.surfaceOverlay.withValues(alpha: 0.6),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Text(
                  hasDuration ? _formatDuration(state.duration) : '--:--',
                  style: textTheme.manrope10Regular.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _ControlButton(
                  icon: Icons.skip_previous_rounded,
                  size: 34.r,
                  iconSize: 20.r,
                  filled: false,
                  onTap: () => context.read<QiraathCubit>().previous(),
                ),
                SizedBox(width: AppSpacing.md),
                _ControlButton(
                  icon: state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 46.r,
                  iconSize: 24.r,
                  filled: true,
                  onTap: () => context.read<QiraathCubit>().togglePlayPause(),
                ),
                SizedBox(width: AppSpacing.md),
                _ControlButton(
                  icon: Icons.skip_next_rounded,
                  size: 34.r,
                  iconSize: 20.r,
                  filled: false,
                  onTap: () => context.read<QiraathCubit>().next(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ArtworkBadge extends StatelessWidget {
  const _ArtworkBadge({required this.isPlaying});

  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.r,
      width: 48.r,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColors.gold.withValues(alpha: 0.28),
            AppColors.surfaceOverlay,
          ],
        ),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
        boxShadow: isPlaying
            ? <BoxShadow>[
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.28),
                  blurRadius: 14.r,
                  offset: Offset(0, 4.h),
                ),
              ]
            : null,
      ),
      child: Icon(Icons.headphones_rounded, color: AppColors.gold, size: 22.r),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.size,
    required this.iconSize,
    required this.filled,
    required this.onTap,
  });

  final IconData icon;
  final double size;
  final double iconSize;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: filled ? AppColors.gold : AppColors.surfaceOverlay,
            shape: BoxShape.circle,
            border: filled
                ? null
                : Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
            boxShadow: filled
                ? <BoxShadow>[
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.35),
                      blurRadius: 10.r,
                      offset: Offset(0, 3.h),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            color: filled ? AppColors.surfaceOverlay : AppColors.gold,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
