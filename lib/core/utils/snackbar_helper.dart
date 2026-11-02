import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SnackBarHelper {
  /// Global ScaffoldMessenger key so snackbars can be safely displayed across any route transition
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// Green SnackBar for Success scenarios
  static void showSuccess([BuildContext? context, String? message]) {
    _showSnackBar(
      context: context,
      message: message ?? 'Success',
      backgroundColor: AppColors.success,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  /// Red SnackBar for all Errors, Warnings & Invalid actions
  static void showError([BuildContext? context, String? message]) {
    _showSnackBar(
      context: context,
      message: message ?? 'An error occurred',
      backgroundColor: AppColors.error,
      icon: Icons.error_outline_rounded,
    );
  }

  static void _showSnackBar({
    BuildContext? context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    final messenger = context != null
        ? ScaffoldMessenger.maybeOf(context) ?? messengerKey.currentState
        : messengerKey.currentState;

    if (messenger == null) return;

    // Clear any previous snackbar immediately
    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            SizedBox(width: 10),
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
