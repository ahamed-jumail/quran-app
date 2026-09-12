import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/bloc/surah_interactions/surah_interactions_cubit.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_styles.dart';
import '../../../global_widgets/app_toast.dart';
import '../../../models/surah_index_entry.dart';

/// A single Surah row, shared by the Surah Index, Liked Surahs, and
/// Bookmarked Surahs pages. Tapping the row navigates via [onTap] (normally
/// straight to that Surah's page in the reader); tapping the trailing menu
/// opens a sheet with Info / Like / Bookmark actions.
class SurahTile extends StatelessWidget {
  const SurahTile({super.key, required this.entry, required this.onTap});

  final SurahIndexEntry entry;
  final VoidCallback onTap;

  void _openActionsSheet(BuildContext context) {
    final SurahInteractionsCubit cubit = context.read<SurahInteractionsCubit>();
    final bool liked = cubit.state.likedNumbers.contains(entry.number);
    final bool bookmarked = cubit.state.bookmarkedNumbers.contains(entry.number);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (BuildContext sheetContext) {
        return _SurahActionsSheet(
          liked: liked,
          bookmarked: bookmarked,
          onInfo: () {
            Navigator.of(sheetContext).pop();
            context.push('/surah-info', extra: entry);
          },
          onToggleLike: () {
            Navigator.of(sheetContext).pop();
            _toggleLike(context, cubit, wasLiked: liked);
          },
          onToggleBookmark: () {
            Navigator.of(sheetContext).pop();
            _toggleBookmark(context, cubit, wasBookmarked: bookmarked);
          },
        );
      },
    );
  }

  Future<void> _toggleLike(
    BuildContext context,
    SurahInteractionsCubit cubit, {
    required bool wasLiked,
  }) async {
    try {
      await cubit.toggleLike(entry.number);
      if (context.mounted) {
        AppToast.showSuccess(
          context,
          message: wasLiked ? 'Removed from Liked Surahs' : 'Added to Liked Surahs',
        );
      }
    } catch (_) {
      if (context.mounted) {
        AppToast.showFailure(
          context,
          message: "Couldn't update your liked Surahs. Please try again.",
        );
      }
    }
  }

  Future<void> _toggleBookmark(
    BuildContext context,
    SurahInteractionsCubit cubit, {
    required bool wasBookmarked,
  }) async {
    try {
      await cubit.toggleBookmark(entry.number);
      if (context.mounted) {
        AppToast.showSuccess(
          context,
          message: wasBookmarked ? 'Bookmark removed' : 'Surah bookmarked',
        );
      }
    } catch (_) {
      if (context.mounted) {
        AppToast.showFailure(
          context,
          message: "Couldn't update your bookmarks. Please try again.",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    // The main content and the trailing menu button are siblings, each in
    // their own Material/InkWell, rather than nesting one InkWell inside the
    // other. Two InkWells covering overlapping regions compete in the same
    // gesture arena, which resolves the winner non-deterministically —
    // nesting them made the menu button open the sheet on some taps and
    // trigger the row's navigation on others, at the exact same coordinates.
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
                onTap: onTap,
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
                              'Starts at page ${entry.startPage}',
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
            child: Material(
              color: AppColors.transparent,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => _openActionsSheet(context),
                child: Container(
                  height: 30.r,
                  width: 30.r,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceOverlay,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                  ),
                  child: Icon(Icons.more_vert_rounded, color: AppColors.gold, size: 16.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The actions sheet's content: Info / Like / Bookmark as premium icon-badge
/// tiles. Only "Surah Info" navigates onward, so only it shows a chevron.
class _SurahActionsSheet extends StatelessWidget {
  const _SurahActionsSheet({
    required this.liked,
    required this.bookmarked,
    required this.onInfo,
    required this.onToggleLike,
    required this.onToggleBookmark,
  });

  final bool liked;
  final bool bookmarked;
  final VoidCallback onInfo;
  final VoidCallback onToggleLike;
  final VoidCallback onToggleBookmark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceOverlay,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.16)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.4),
            blurRadius: 24.r,
            offset: Offset(0, -8.h),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: AppSpacing.sm),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Column(
                children: <Widget>[
                  _ActionTile(
                    icon: Icons.info_outline_rounded,
                    label: 'Surah Info',
                    subtitle: 'Meaning, revelation & summary',
                    active: false,
                    showChevron: true,
                    onTap: onInfo,
                  ),
                  _ActionTile(
                    icon: liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    label: liked ? 'Unlike Surah' : 'Like Surah',
                    subtitle: liked
                        ? 'Remove from your liked Surahs'
                        : 'Add to your liked Surahs',
                    active: liked,
                    showChevron: false,
                    onTap: onToggleLike,
                  ),
                  _ActionTile(
                    icon: bookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    label: bookmarked ? 'Remove Bookmark' : 'Bookmark Surah',
                    subtitle: bookmarked
                        ? 'Remove from your bookmarks'
                        : 'Save for quick access later',
                    active: bookmarked,
                    showChevron: false,
                    onTap: onToggleBookmark,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.active,
    required this.showChevron,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final bool active;
  final bool showChevron;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Material(
      color: AppColors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        splashColor: AppColors.gold.withValues(alpha: 0.08),
        highlightColor: AppColors.gold.withValues(alpha: 0.04),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 10.h),
          child: Row(
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 40.r,
                width: 40.r,
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.gold.withValues(alpha: 0.18)
                      : AppColors.surfaceRaised,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: active ? 0.5 : 0.22),
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: AppColors.gold, size: 19.r),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      label,
                      style: textTheme.manrope14SemiBold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: textTheme.manrope12Regular.copyWith(
                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 18.r,
                child: showChevron
                    ? Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textSecondary.withValues(alpha: 0.4),
                        size: 18.r,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
