import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/responsive_layout.dart';
import '../../core/utils/snackbar_helper.dart';
import '../../core/utils/validators.dart';
import '../widgets/auth_header_title.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/wavy_header.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.forgotPassword(
      identifier: _identifierController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      setState(() {
        _submitted = true;
      });
      SnackBarHelper.showSuccess(
        context,
        authProvider.successMessage ?? AppStrings.resetSuccess,
      );
    } else {
      SnackBarHelper.showError(
        context,
        authProvider.errorMessage ?? 'User not found. Check your input.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final horizontalPad = ResponsiveLayout.horizontalPadding(context);
    final headerH = ResponsiveLayout.headerHeight(context, defaultRatio: 0.24);
    final verticalSpacing = ResponsiveLayout.verticalSpacing(
      context,
      defaultValue: 20.0,
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            // Top Wavy Header with back button (Adaptive via MediaQuery)
            WavyHeader(
              height: headerH,
              child: SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.chevron_left_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                      tooltip: 'Back',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ),
            ),

            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: ResponsiveLayout.maxContentWidth,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPad),
                  child: _submitted
                      ? _buildSuccessView(context)
                      : Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 8),

                              const AuthHeaderTitle(
                                title: 'Forgot Password',
                                lineWidth: 60,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Enter your registered email address or mobile number to receive password recovery instructions.',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                              SizedBox(height: verticalSpacing * 1.3),

                              CustomTextField(
                                controller: _identifierController,
                                label: 'Email or Mobile',
                                hint: 'densa@email.com',
                                prefixIcon: Icons.mail_outline_rounded,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                validator: Validators.validateIdentifier,
                                onFieldSubmitted: (_) => _handleResetPassword(),
                              ),
                              SizedBox(height: verticalSpacing * 1.6),

                              CustomButton(
                                text: 'Send Reset Link',
                                isLoading: authProvider.isLoading,
                                onPressed: authProvider.isLoading
                                    ? null
                                    : _handleResetPassword,
                              ),
                              SizedBox(height: verticalSpacing * 1.2),

                              Center(
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: const Text(
                                    AppStrings.backToLogin,
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 28),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.mark_email_read_rounded,
              size: 38,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Check Your Inbox',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'We have dispatched recovery instructions to ${_identifierController.text.trim()}.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        CustomButton(
          text: AppStrings.backToLogin,
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(height: 28),
      ],
    );
  }
}
