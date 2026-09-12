import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_styles.dart';
import 'widgets/home_menu_tile.dart';
import 'widgets/quran_progress_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'As-salamu alaykum',
                style:
                    textTheme.manrope13Regular.copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: 4.h),
              Text(
                'Your Quran Companion',
                style:
                    textTheme.fraunces24SemiBold.copyWith(color: AppColors.textPrimary),
              ),
              SizedBox(height: AppSpacing.xl),
              QuranProgressCard(
                title: 'Start Reading',
                subtitle: 'Begin your journey through the Quran',
                onTap: () {},
              ),
              SizedBox(height: AppSpacing.xl),
              Text(
                'QUICK ACCESS',
                style: textTheme.manrope12SemiBold.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Row(
                children: <Widget>[
                  Expanded(
                    child: HomeMenuTile(
                      icon: Icons.grid_view_rounded,
                      label: 'Surah Index',
                      onTap: () {},
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: HomeMenuTile(
                      icon: Icons.layers_rounded,
                      label: 'Juz Index',
                      onTap: () {},
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: HomeMenuTile(
                      icon: Icons.bookmark_rounded,
                      label: 'Bookmarks',
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
