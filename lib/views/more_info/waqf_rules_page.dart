import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_styles.dart';
import '../../models/waqf_rule.dart';
import 'more_info_repository.dart';
import 'widgets/info_section_card.dart';

class WaqfRulesPage extends StatelessWidget {
  const WaqfRulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Waqf Rules'),
      ),
      body: FutureBuilder<WaqfRulesData>(
        future: MoreInfoRepository.loadWaqfRules(),
        builder: (BuildContext context, AsyncSnapshot<WaqfRulesData> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          }
          return _WaqfRulesBody(data: snapshot.data!);
        },
      ),
    );
  }
}

class _WaqfRulesBody extends StatelessWidget {
  const _WaqfRulesBody({required this.data});

  final WaqfRulesData data;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: EdgeInsets.all(AppSpacing.lg),
      children: <Widget>[
        Text(
          data.intro,
          style: textTheme.manrope13Regular.copyWith(
            color: AppColors.textPrimary,
            height: 1.6,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.warning.withValues(alpha: 0.35)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.info_outline_rounded, color: AppColors.warning, size: 20.r),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  data.importantNote,
                  style: textTheme.manrope12Regular.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        Text(
          'STOP & PAUSE SIGNS',
          style: textTheme.manrope12SemiBold.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        for (final WaqfRule rule in data.rules) ...<Widget>[
          _WaqfRuleTile(rule: rule),
          SizedBox(height: AppSpacing.sm),
        ],
        SizedBox(height: AppSpacing.sm),
        InfoSectionCard(
          title: 'Common beginner rules',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (final WaqfBeginnerRule rule in data.beginnerRules)
                Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 16.w,
                            child: Text(
                              '•',
                              textAlign: TextAlign.center,
                              style: textTheme.manrope13SemiBold.copyWith(
                                color: AppColors.gold,
                                height: 1.5,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              rule.rule,
                              style: textTheme.manrope13SemiBold.copyWith(
                                color: AppColors.textPrimary,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.w, top: 2.h),
                        child: Text(
                          rule.reason,
                          style: textTheme.manrope12Regular.copyWith(
                            color: AppColors.textSecondary.withValues(alpha: 0.8),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.md),
        Text(
          data.mushafVariation,
          style: textTheme.manrope12Regular.copyWith(
            color: AppColors.textSecondary.withValues(alpha: 0.7),
            fontStyle: FontStyle.italic,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _WaqfRuleTile extends StatelessWidget {
  const _WaqfRuleTile({required this.rule});

  final WaqfRule rule;

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
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
            ),
            alignment: Alignment.center,
            child: Text(
              rule.symbol,
              textDirection: TextDirection.rtl,
              style: textTheme.fraunces18SemiBold.copyWith(color: AppColors.gold),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  rule.name,
                  style: textTheme.fraunces16SemiBold.copyWith(color: AppColors.textPrimary),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${rule.meaning} · ${rule.arabicName}',
                  style: textTheme.manrope12Regular.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    rule.action,
                    style: textTheme.manrope12SemiBold.copyWith(color: AppColors.gold),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  rule.simpleExplanation,
                  style: textTheme.manrope12Regular.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.85),
                    height: 1.5,
                  ),
                ),
                if (rule.breath != null) ...<Widget>[
                  SizedBox(height: 4.h),
                  Text(
                    rule.breath!,
                    style: textTheme.manrope12Regular.copyWith(
                      color: AppColors.textSecondary.withValues(alpha: 0.6),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
