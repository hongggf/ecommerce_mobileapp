import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastWidget {

  static void show({
    String type = 'success',
    required String message,
    Duration autoCloseDuration = const Duration(seconds: 2),
  }) {
    ToastificationType toastType;
    switch (type.toLowerCase()) {
      case 'error':
        toastType = ToastificationType.error;
        break;
      case 'success':
      default:
        toastType = ToastificationType.success;
        break;
    }

    toastification.show(
      type: toastType,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: autoCloseDuration,
      title: Text(message),
    );
  }

}