import 'package:ps_utils/popup/animation_loader.dart';
import 'package:ps_utils/constants/colors.dart';
import 'package:ps_utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A utility class for managing a full-screen loading dialog.
class PSFullScreenLoader {
  /// Open a full-screen loading dialog with a given text and animation.
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.85), // Darker overlay
      builder: (_) => PopScope(
        canPop: false,
            child: Container(
              color: PSHelperFunctions.isDarkMode(Get.context!)
              ? PSColors.dark.withOpacity(0.95)
              : PSColors.white.withOpacity(0.95),
              width: double.infinity,
              height: double.infinity,
          child: Stack(
                children: [
              // Background gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: PSHelperFunctions.isDarkMode(Get.context!)
                        ? [
                            Colors.grey[900]!.withOpacity(0.5),
                            Colors.grey[850]!.withOpacity(0.3),
                          ]
                        : [
                            const Color(0xFF6A11CB).withOpacity(0.05),
                            const Color(0xFF2575FC).withOpacity(0.05),
                          ],
                  ),
                ),
              ),

              // Content
              Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: PSHelperFunctions.isDarkMode(Get.context!)
                        ? Colors.grey[850]?.withOpacity(0.9)
                        : Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Animation
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: PSHelperFunctions.isDarkMode(Get.context!)
                              ? Colors.grey[900]?.withOpacity(0.5)
                              : Colors.grey[100]?.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: PSAnimationLoaderWidget(
                          text: text,
                          animation: animation,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Loading indicator
                      SizedBox(
                        width: 160,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            backgroundColor: Theme.of(Get.context!)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(Get.context!).colorScheme.primary,
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Loading text
                      Text(
                        text.isEmpty ? "Loading..." : text,
                        style: Theme.of(Get.context!)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
                ],
              ),
            ),
          ),
    );
  }

  /// Stop the currently open dialog
  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
