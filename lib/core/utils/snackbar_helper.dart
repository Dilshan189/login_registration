import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SnackBarHelper {
  /// Green SnackBar for Success scenarios
  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  /// Red SnackBar for all Errors, Warnings & Invalid actions
  static void showError(BuildContext context, String message) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: AppColors.error,
      icon: Icons.error_outline_rounded,
    );
  }

  static void _showSnackBar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    // Clear any previous snackbar immediately
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        // Auto-dismisses quickly within 2 seconds
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }
}
