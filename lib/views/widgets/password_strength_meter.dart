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
        strengthLabel = 'Weak Password';
        break;
      case PasswordStrength.medium:
        barColor = AppColors.warning;
        strengthLabel = 'Medium Strength';
        break;
      case PasswordStrength.strong:
        barColor = AppColors.success;
        strengthLabel = 'Strong Password';
        break;
    }

    final hasMinLength = password.length >= 8;
    final hasUpper = RegExp(r'[A-Z]').hasMatch(password);
    final hasLower = RegExp(r'[a-z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecial = RegExp(r'[@$!%*?&]').hasMatch(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              strengthLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: barColor,
              ),
            ),
            Text(
              '${(score * 100).toInt()}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: barColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
            minHeight: 5,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            _buildRuleItem('8+ chars', hasMinLength),
            _buildRuleItem('Uppercase', hasUpper),
            _buildRuleItem('Lowercase', hasLower),
            _buildRuleItem('Number', hasNumber),
            _buildRuleItem('Symbol (@\$!%*?&)', hasSpecial),
          ],
        ),
      ],
    );
  }

  Widget _buildRuleItem(String text, bool satisfied) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          satisfied ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
          size: 13,
          color: satisfied ? AppColors.success : AppColors.textMuted,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: satisfied ? FontWeight.w600 : FontWeight.w400,
            color: satisfied ? AppColors.textPrimary : AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

