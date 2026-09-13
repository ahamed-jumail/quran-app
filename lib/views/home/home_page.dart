import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/bloc/quran_progress/quran_progress_cubit.dart';
import '../../core/bloc/quran_progress/quran_progress_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_styles.dart';
import '../../global_widgets/gold_shimmer_text.dart';
import '../../models/quran_reader_route_args.dart';
import 'widgets/home_menu_tile.dart';
import 'widgets/knowledge_hub_button.dart';
import 'widgets/mini_qirath_player.dart';
import 'widgets/notched_corner_clip.dart';
import 'widgets/quran_progress_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final Size screenSize = MediaQuery.sizeOf(context);

    final bool isCompactHeight = screenSize.height < 700;
    final double tileGap = AppSpacing.sm;
    final double hubButtonDiameter = 64.r;
    final double hubButtonRadius = hubButtonDiameter / 2;
    // The notch is cut a bit larger than the button so a ring of background
    // stays visible between the clipped tile corners and the button itself,
    // instead of the tiles butting right up against it.
    final double hubNotchRadius = hubButtonRadius + AppSpacing.xs;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            isCompactHeight ? AppSpacing.sm : AppSpacing.md,
            AppSpacing.lg,
            isCompactHeight ? AppSpacing.sm : AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _HomeHeader(
                textTheme: textTheme,
                isCompactHeight: isCompactHeight,
              ),
              SizedBox(height: isCompactHeight ? AppSpacing.sm : AppSpacing.md),
              SizedBox(
                height: isCompactHeight ? 70.h : 80.h,
                child: BlocBuilder<QuranProgressCubit, QuranProgressState>(
                  builder: (BuildContext context, QuranProgressState state) {
                    final bool hasProgress =
                        state.lastPage > QuranProgressState.firstReadablePage &&
                        state.totalPages > 0;
                    return QuranProgressCard(
                      title: hasProgress ? 'Resume Quran' : 'Read Quran',
                      subtitle: hasProgress
                          ? 'Page ${state.lastPage} of ${state.totalPages}'
                          : 'Begin reading the Holy Quran',
                      progress: state.progress,
                      progressLabel: hasProgress
                          ? '${(state.progress * 100).round()}%'
                          : 'Begin',
                      onTap: () => context.push(
                        '/quran-reader',
                        extra: const QuranReaderRouteArgs(updateProgress: true),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: isCompactHeight ? AppSpacing.sm : AppSpacing.md),
              const MiniQirathPlayer(),
              SizedBox(height: isCompactHeight ? AppSpacing.sm : AppSpacing.md),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(color: AppColors.gold.withValues(alpha: 0.25)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    child: Text(
                      'EXPLORE',
                      style: textTheme.manrope12SemiBold.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: AppColors.gold.withValues(alpha: 0.25)),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Expanded(
                flex: 6,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: NotchedCornerClip(
                                  corner: NotchedCorner.bottomRight,
                                  notchRadius: hubNotchRadius,
                                  cornerRadius: AppRadius.lg,
                                  child: HomeMenuTile(
                                    icon: Icons.auto_stories_rounded,
                                    label: 'Surah Index',
                                    subtitle: '114 Surahs',
                                    onTap: () => context.push('/surah-index'),
                                  ),
                                ),
                              ),
                              SizedBox(width: tileGap),
                              Expanded(
                                child: NotchedCornerClip(
                                  corner: NotchedCorner.bottomLeft,
                                  notchRadius: hubNotchRadius,
                                  cornerRadius: AppRadius.lg,
                                  child: HomeMenuTile(
                                    icon: Icons.layers_rounded,
                                    label: 'Juz Index',
                                    subtitle: '30 Juz',
                                    onTap: () => context.push('/juz-index'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: tileGap),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: NotchedCornerClip(
                                  corner: NotchedCorner.topRight,
                                  notchRadius: hubNotchRadius,
                                  cornerRadius: AppRadius.lg,
                                  child: HomeMenuTile(
                                    icon: Icons.headphones_rounded,
                                    label: 'Quran Qirath',
                                    subtitle: 'Arabic Recitations',
                                    onTap: () => context.push('/quran-qirath'),
                                  ),
                                ),
                              ),
                              SizedBox(width: tileGap),
                              Expanded(
                                child: NotchedCornerClip(
                                  corner: NotchedCorner.topLeft,
                                  notchRadius: hubNotchRadius,
                                  cornerRadius: AppRadius.lg,
                                  child: HomeMenuTile(
                                    icon: Icons.bookmark_rounded,
                                    label: 'Bookmarks',
                                    subtitle: 'Your saved verses',
                                    onTap: () => context.push('/bookmarked-surahs'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    KnowledgeHubButton(diameter: hubButtonDiameter),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.textTheme, required this.isCompactHeight});

  final TextTheme textTheme;
  final bool isCompactHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        isCompactHeight ? 12.h : 15.h,
        AppSpacing.lg,
        isCompactHeight ? 14.h : 17.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColors.surfaceRaised,
            AppColors.surfaceOverlay.withValues(alpha: 0.72),
          ],
        ),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.12)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.3),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Image.asset('assets/icons/quran.png', height: 50.r, width: 50.r),
          SizedBox(width: AppSpacing.sm),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isCompactHeight ? 8.h : 11.h,
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      softWrap: false,
                      style: textTheme.manrope18SemiBold.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.7,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                SizedBox(
                  width: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: GoldShimmerText(
                      text: 'Your Quran Companion',
                      style: textTheme.fraunces22SemiBold.copyWith(height: 1.1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'A peaceful place to reconnect with the words of Allah',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.manrope10Regular.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.72),
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}
