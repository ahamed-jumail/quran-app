import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_styles.dart';
import '../../models/quran_details.dart';
import '../../models/quran_fact.dart';
import 'more_info_repository.dart';
import 'widgets/info_section_card.dart';

class AboutQuranPage extends StatelessWidget {
  const AboutQuranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('About Quran'),
      ),
      body: FutureBuilder<QuranDetails>(
        future: MoreInfoRepository.loadQuranDetails(),
        builder: (BuildContext context, AsyncSnapshot<QuranDetails> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          }
          return _AboutQuranBody(details: snapshot.data!);
        },
      ),
    );
  }
}

class _AboutQuranBody extends StatelessWidget {
  const _AboutQuranBody({required this.details});

  final QuranDetails details;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: EdgeInsets.all(AppSpacing.lg),
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.surfaceRaised,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.16)),
          ),
          child: Column(
            children: <Widget>[
              Text(
                details.arabicName,
                textDirection: TextDirection.rtl,
                style: textTheme.fraunces32Bold.copyWith(color: AppColors.gold),
              ),
              SizedBox(height: 6.h),
              Text(
                'The Quran',
                style: textTheme.fraunces20SemiBold.copyWith(color: AppColors.textPrimary),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                details.whatIsQuran,
                textAlign: TextAlign.center,
                style: textTheme.manrope13Regular.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.md),
        InfoSectionCard(
          title: 'By the numbers',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              EqualWidthGrid(
                itemCount: details.statistics.length,
                columns: 2,
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                itemBuilder: (BuildContext context, int index) {
                  final QuranFact fact = details.statistics[index];
                  return InfoChip(label: fact.label, value: fact.value);
                },
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                details.statisticsNote,
                style: textTheme.manrope10Regular.copyWith(
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                  fontStyle: FontStyle.italic,
                  fontSize: 11.sp,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.md),
        InfoSectionCard(
          title: 'Did you know?',
          child: Column(
            children: <Widget>[
              for (final QuranFact fact in details.importantFacts)
                FactRow(label: fact.label, value: fact.value),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.md),
        InfoSectionCard(
          title: 'History & revelation',
          child: Column(
            children: <Widget>[
              for (final QuranFact fact in details.historyAndRevelation)
                FactRow(label: fact.label, value: fact.value),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.md),
        InfoSectionCard(
          title: 'The Prophets',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${details.prophetsCount} prophets are named in the Quran.',
                style: textTheme.manrope13Regular.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              EqualWidthGrid(
                itemCount: details.prophetNames.length,
                columns: 2,
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                itemBuilder: (BuildContext context, int index) =>
                    InfoChip(label: details.prophetNames[index]),
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                'Surahs named after Prophets',
                style: textTheme.manrope12SemiBold.copyWith(color: AppColors.gold),
              ),
              SizedBox(height: AppSpacing.sm),
              EqualWidthGrid(
                itemCount: details.surahsNamedAfterProphets.length,
                columns: 4,
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                itemBuilder: (BuildContext context, int index) =>
                    InfoChip(label: details.surahsNamedAfterProphets[index]),
              ),
              for (final QuranFact fact in details.prophetFacts)
                FactRow(label: fact.label, value: fact.value),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.md),
        InfoSectionCard(
          title: 'Themes of the Quran',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (final String theme in details.themes)
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 16.w,
                        child: Text(
                          '•',
                          textAlign: TextAlign.center,
                          style: textTheme.manrope13Regular.copyWith(
                            color: AppColors.gold,
                            height: 1.5,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          theme,
                          style: textTheme.manrope13Regular.copyWith(
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: AppSpacing.sm),
              Text(
                details.beautyOfQuran,
                style: textTheme.manrope13Regular.copyWith(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
