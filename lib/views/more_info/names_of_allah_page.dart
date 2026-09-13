import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_styles.dart';
import '../../global_widgets/islamic_star_loader.dart';
import '../../models/name_of_allah.dart';
import 'more_info_repository.dart';

class NamesOfAllahPage extends StatelessWidget {
  const NamesOfAllahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('99 Names of Allah'),
      ),
      body: FutureBuilder<List<NameOfAllah>>(
        future: MoreInfoRepository.loadNamesOfAllah(),
        builder: (BuildContext context, AsyncSnapshot<List<NameOfAllah>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: IslamicStarLoader());
          }
          final List<NameOfAllah> names = snapshot.data!;
          return Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
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
                      blurRadius: 20.r,
                      offset: Offset(0, 10.h),
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      'أَسْمَاءُ اللهِ الْحُسْنَى',
                      textDirection: TextDirection.rtl,
                      style: Theme.of(context).textTheme.fraunces24SemiBold.copyWith(
                        color: AppColors.surfaceOverlay,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'The 99 Beautiful Names of Allah',
                      style: Theme.of(context).textTheme.manrope13Regular.copyWith(
                        color: AppColors.surfaceOverlay.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.sm,
                    crossAxisSpacing: AppSpacing.sm,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: names.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _NameOfAllahCard(name: names[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NameOfAllahCard extends StatelessWidget {
  const _NameOfAllahCard({required this.name});

  final NameOfAllah name;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.18)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.18),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 26.r,
            width: 26.r,
            decoration: BoxDecoration(
              color: AppColors.surfaceOverlay,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
            ),
            alignment: Alignment.center,
            child: Text(
              '${name.number}',
              style: textTheme.manrope10SemiBold.copyWith(color: AppColors.gold),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            name.arabicName,
            textDirection: TextDirection.rtl,
            maxLines: 1,
            style: textTheme.fraunces20SemiBold.copyWith(color: AppColors.gold),
          ),
          SizedBox(height: 4.h),
          Text(
            name.englishName,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.manrope13SemiBold.copyWith(color: AppColors.textPrimary),
          ),
          SizedBox(height: 4.h),
          Text(
            name.meaning,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: textTheme.manrope10Regular.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.8),
              fontSize: 11.sp,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
