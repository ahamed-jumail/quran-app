import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_styles.dart';

/// Landing page for the Home page's central "knowledge" button — a short
/// menu of reference/informational destinations.
class MoreInfoPage extends StatelessWidget {
  const MoreInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Knowledge Hub'),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.lg),
        children: <Widget>[
          _MoreInfoTile(
            icon: Icons.auto_awesome_rounded,
            title: 'About App',
            subtitle: 'What this app offers and how to use it',
            onTap: () => context.push('/about-app'),
          ),
          SizedBox(height: AppSpacing.sm),
          _MoreInfoTile(
            icon: Icons.menu_book_rounded,
            title: 'About Quran',
            subtitle: 'History, statistics and remarkable facts',
            onTap: () => context.push('/about-quran'),
          ),
          SizedBox(height: AppSpacing.sm),
          _MoreInfoTile(
            icon: Icons.signpost_rounded,
            title: 'Waqf Rules',
            subtitle: 'Stop and pause signs used in the Mushaf',
            onTap: () => context.push('/waqf-rules'),
          ),
          SizedBox(height: AppSpacing.sm),
          _MoreInfoTile(
            icon: Icons.palette_outlined,
            title: 'Tajweed Rules',
            subtitle: "The Mushaf's Tajweed colour codes",
            onTap: () => context.push('/color-codes'),
          ),
          SizedBox(height: AppSpacing.sm),
          _MoreInfoTile(
            icon: Icons.auto_awesome_mosaic_rounded,
            title: 'Names of Allah',
            subtitle: 'The 99 Beautiful Names',
            onTap: () => context.push('/names-of-allah'),
          ),
        ],
      ),
    );
  }
}

class _MoreInfoTile extends StatelessWidget {
  const _MoreInfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
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
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceRaised,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.12)),
          ),
          child: Row(
            children: <Widget>[
              Container(
                height: 48.r,
                width: 48.r,
                decoration: BoxDecoration(
                  color: AppColors.surfaceOverlay,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.28)),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: AppColors.gold, size: 22.r),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: textTheme.fraunces16SemiBold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      maxLines: 2,
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
        ),
      ),
    );
  }
}
