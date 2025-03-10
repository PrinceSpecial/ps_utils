import 'package:ps_utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PSLoaders{
  PSLoaders._();

  static successSnackBar({required title, message = ""}){
    Get.snackbar(
        title,
        message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: PSColors.white,
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        icon: const Icon(Icons.warning_amber, color: PSColors.white,)
    );
  }

  static warningSnackBar({required title, message = ""}){
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: PSColors.white,
      backgroundColor: Colors.orange,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Icons.warning_amber, color: PSColors.white,)
    );
  }

  static errorSnackBar({required title, message = ""}){
    Get.snackbar(
        title,
        message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: PSColors.white,
        backgroundColor: Colors.red.shade600,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        icon: const Icon(Icons.warning_amber, color: PSColors.white,)
    );
  }

  static infoSnackBar({required String title, String message = ""}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: PSColors.white,
      backgroundColor: Colors.blue.shade600,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Icons.info, color: PSColors.white),
    );
  }

  static notificationSnackBar({required String title, String message = ""}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: PSColors.white,
      backgroundColor: Colors.purple.shade600,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Icons.notifications, color: PSColors.white),
    );
  }}