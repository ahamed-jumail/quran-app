import 'package:flutter/material.dart';

class ToastHelper {
  static void successToast(
      {required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.greenAccent,
      content: Text(
        message,
        style: const TextStyle(color: Colors.black),
      ),
    ));
  }

  static void failureToast(
      {required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.redAccent,
      content: Text(
        message,
        style: const TextStyle(color: Colors.black),
      ),
    ));
  }
}
