import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

/// The gold-embossed circular button sitting at the centre of Home's Quick
/// Access 2x2 grid, notched into all four surrounding tiles.
class KnowledgeHubButton extends StatelessWidget {
  const KnowledgeHubButton({super.key, required this.diameter});

  final double diameter;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/more-info'),
        child: Container(
          height: diameter,
          width: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xFFF6E7BE),
                AppColors.goldLight,
                AppColors.gold,
                Color(0xFF8F6B32),
              ],
              stops: <double>[0.0, 0.32, 0.68, 1.0],
            ),
            border: Border.all(color: const Color(0xFF8F6B32), width: 1.5),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.45),
                blurRadius: 14.r,
                offset: Offset(0, 6.h),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.35),
                blurRadius: 3.r,
                offset: Offset(-1.5.r, -1.5.r),
                spreadRadius: -2.r,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.settings,
            color: AppColors.surfaceOverlay,
            size: diameter * 0.5,
          ),
        ),
      ),
    );
  }
}
