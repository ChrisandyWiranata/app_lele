import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

class ToastHelper {
  static void showSuccess({
    required BuildContext context,
    required String message,
    String title = 'Success',
    Duration? duration,
  }) {
    MotionToast.success(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      description: Text(message, style: const TextStyle(color: Colors.white)),
      position: MotionToastPosition.bottom,
      animationType: AnimationType.fromBottom,
      toastDuration: duration ?? const Duration(seconds: 2),
    ).show(context);
  }

  static void showError({
    required BuildContext context, 
    required String message,
    String title = 'Error',
    Duration? duration,
  }) {
    MotionToast.error(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      description: Text(message, style: const TextStyle(color: Colors.white)),
      position: MotionToastPosition.bottom,
      animationType: AnimationType.fromBottom,
      toastDuration: duration ?? const Duration(seconds: 2),
    ).show(context);
  }

  static void showWarning({
    required BuildContext context,
    required String message, 
    String title = 'Warning',
    Duration? duration,
  }) {
    MotionToast.warning(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      description: Text(message, style: const TextStyle(color: Colors.white)),
      position: MotionToastPosition.bottom,
      animationType: AnimationType.fromBottom,
      toastDuration: duration ?? const Duration(seconds: 2),
    ).show(context);
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    String title = 'Info',
    Duration? duration,
  }) {
    MotionToast.info(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      description: Text(message, style: const TextStyle(color: Colors.white)),
      position: MotionToastPosition.bottom,
      animationType: AnimationType.fromBottom,
      toastDuration: duration ?? const Duration(seconds: 2),
    ).show(context);
  }
}