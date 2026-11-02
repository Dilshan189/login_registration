import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/validators.dart';

class PasswordStrengthMeter extends StatelessWidget {
  final String password;

  const PasswordStrengthMeter({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) {
      return const SizedBox.shrink();
    }

    final score = Validators.getPasswordStrengthScore(password);
    final strength = Validators.getPasswordStrength(password);

    Color barColor;
    String strengthLabel;

    switch (strength) {
      case PasswordStrength.weak:
        barColor = AppColors.error;
        strengthLabel = 'Weak';
        break;
      case PasswordStrength.medium:
        barColor = AppColors.warning;
        strengthLabel = 'Medium';
        break;
      case PasswordStrength.strong:
        barColor = AppColors.success;
        strengthLabel = 'Strong';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Strength: $strengthLabel',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: barColor,
              ),
            ),
            Text(
              '${(score * 100).toInt()}%',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: barColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: score,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
            minHeight: 3.5,
          ),
        ),
      ],
    );
  }
}
