import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class ToastHelper {
  static void successToast(
      {required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: AppColors.success,
      content: Text(
        message,
        style: const TextStyle(color: AppColors.surfaceBase),
      ),
    ));
  }

  static void failureToast(
      {required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: AppColors.error,
      content: Text(
        message,
        style: const TextStyle(color: AppColors.surfaceBase),
      ),
    ));
  }
}
