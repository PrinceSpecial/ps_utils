import 'package:ps_utils/google_update/update_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Obx updateButton(BuildContext context) {
  // final dark = CHelperFunctions.isDarkMode(context);
  final controller = Get.put(UpdateController());

  controller.isUpdated.value = true;
  controller.checkForUpdates();

  return Obx(() {
    if (controller.isUpdated.value) {
      return const SizedBox.shrink();
    }

    return ElevatedButton.icon(
      onPressed: controller.downloadAndInstallAPK,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.withOpacity(0.1),
        foregroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
      icon: controller.isUpdating.value 
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            )
          : const Icon(Icons.system_update),
      label: Text(
        controller.isUpdating.value
            ? "Downloading ${controller.progress.value}%"
            : "Update App",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  });
}
