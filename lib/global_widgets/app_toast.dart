import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_dimensions.dart';
import '../core/theme/app_styles.dart';

/// A themed, animated success/failure toast — used in place of a plain
/// [SnackBar] wherever the app wants to confirm the outcome of an action
/// with a premium look consistent with the rest of the UI.
class AppToast {
  const AppToast._();

  static void showSuccess(BuildContext context, {required String message}) =>
      _show(context, message: message, success: true);

  static void showFailure(BuildContext context, {required String message}) =>
      _show(context, message: message, success: false);

  static void _show(BuildContext context, {required String message, required bool success}) {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        padding: EdgeInsets.zero,
        margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
        content: _ToastContent(message: message, success: success),
      ),
    );
  }
}

class _ToastContent extends StatelessWidget {
  const _ToastContent({required this.message, required this.success});

  final String message;
  final bool success;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color accent = success ? AppColors.success : AppColors.error;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceOverlay,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: accent.withValues(alpha: 0.4)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.4),
            blurRadius: 16.r,
            offset: Offset(0, 6.h),
          ),
          BoxShadow(color: accent.withValues(alpha: 0.16), blurRadius: 20.r),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 420),
            curve: Curves.elasticOut,
            builder: (BuildContext context, double value, Widget? child) {
              return Transform.scale(scale: value, child: child);
            },
            child: Container(
              height: 34.r,
              width: 34.r,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.16),
                shape: BoxShape.circle,
                border: Border.all(color: accent.withValues(alpha: 0.5)),
              ),
              alignment: Alignment.center,
              child: Icon(
                success ? Icons.check_rounded : Icons.close_rounded,
                color: accent,
                size: 18.r,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              message,
              style: textTheme.manrope13SemiBold.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
