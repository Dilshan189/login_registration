import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SocialAuthDivider extends StatelessWidget {
  final VoidCallback? onGoogleTap;
  final VoidCallback? onAppleTap;
  final VoidCallback? onGithubTap;

  const SocialAuthDivider({
    super.key,
    this.onGoogleTap,
    this.onAppleTap,
    this.onGithubTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(child: Divider(color: AppColors.border, thickness: 1)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR CONTINUE WITH',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            Expanded(child: Divider(color: AppColors.border, thickness: 1)),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialIcon(
              icon: Icons.g_mobiledata_rounded,
              color: Colors.redAccent,
              onTap: onGoogleTap,
              tooltip: 'Google',
            ),
            const SizedBox(width: 16),
            _buildSocialIcon(
              icon: Icons.apple_rounded,
              color: Colors.black87,
              onTap: onAppleTap,
              tooltip: 'Apple',
            ),
            const SizedBox(width: 16),
            _buildSocialIcon(
              icon: Icons.code_rounded,
              color: const Color(0xFF24292E),
              onTap: onGithubTap,
              tooltip: 'GitHub',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon({
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
    required String tooltip,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border, width: 1.2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 26),
      ),
    );
  }
}
