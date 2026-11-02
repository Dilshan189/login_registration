import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AuthHeaderTitle extends StatelessWidget {
  final String title;
  final double fontSize;
  final double lineWidth;

  const AuthHeaderTitle({
    super.key,
    required this.title,
    this.fontSize = 30,
    this.lineWidth = 42,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: lineWidth,
          height: 3.5,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
