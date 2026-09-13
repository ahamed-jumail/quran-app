import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_styles.dart';

class _AppFeature {
  const _AppFeature({required this.icon, required this.title, required this.description});

  final IconData icon;
  final String title;
  final String description;
}

const List<_AppFeature> _kFeatures = <_AppFeature>[
  _AppFeature(
    icon: Icons.menu_book_rounded,
    title: 'Tajweed Quran Reader',
    description:
        'A full colour-coded Tajweed Mushaf that seamlessly resumes exactly where you left off, '
        'with an auto-hiding reader bar for a distraction-free reading view.',
  ),
  _AppFeature(
    icon: Icons.auto_stories_rounded,
    title: 'Surah Index',
    description:
        'Browse all 114 Surahs with search and Makkiyah/Madhiniya filters. Like or bookmark any '
        'Surah for quick access later, or open its info page for a summary and key details.',
  ),
  _AppFeature(
    icon: Icons.layers_rounded,
    title: 'Juz Index',
    description: 'Jump straight to the start of any of the 30 Juz with a single tap.',
  ),
  _AppFeature(
    icon: Icons.headphones_rounded,
    title: 'Quran Qirath',
    description:
        'Listen to Quran recitations from a choice of reciters, with playback that continues '
        'in the background and full controls from the notification bar.',
  ),
  _AppFeature(
    icon: Icons.bookmark_rounded,
    title: 'Liked & Bookmarked Surahs',
    description: 'Keep a personal shortlist of Surahs you love or want to return to.',
  ),
  _AppFeature(
    icon: Icons.palette_outlined,
    title: 'Tajweed Colour Codes',
    description: 'A quick reference explaining what each Tajweed colour in the Mushaf means.',
  ),
];

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

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
        title: const Text('About App'),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.lg),
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
                Image.asset('assets/icons/quran.png', height: 56.r, width: 56.r),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Your Quran Companion',
                  textAlign: TextAlign.center,
                  style: textTheme.fraunces22SemiBold.copyWith(color: AppColors.surfaceOverlay),
                ),
                SizedBox(height: 6.h),
                Text(
                  'A peaceful, premium space to read, listen to and learn about the Holy Quran — '
                  'built around a Tajweed Mushaf, Quran recitations and quick reference to the '
                  'rules of proper recitation.',
                  textAlign: TextAlign.center,
                  style: textTheme.manrope13Regular.copyWith(
                    color: AppColors.surfaceOverlay.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'FEATURES',
            style: textTheme.manrope12SemiBold.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          for (final _AppFeature feature in _kFeatures) ...<Widget>[
            _FeatureTile(feature: feature),
            SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.feature});

  final _AppFeature feature;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 44.r,
            width: 44.r,
            decoration: BoxDecoration(
              color: AppColors.surfaceOverlay,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.28)),
            ),
            alignment: Alignment.center,
            child: Icon(feature.icon, color: AppColors.gold, size: 20.r),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  feature.title,
                  style: textTheme.fraunces16SemiBold.copyWith(color: AppColors.textPrimary),
                ),
                SizedBox(height: 2.h),
                Text(
                  feature.description,
                  style: textTheme.manrope12Regular.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
