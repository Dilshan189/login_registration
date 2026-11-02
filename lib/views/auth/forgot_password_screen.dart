import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/snackbar_helper.dart';
import '../../core/utils/validators.dart';
import '../widgets/app_logo.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

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
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Password Recovery'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24.0 : 40.0,
              vertical: 24.0,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Card(
                elevation: isMobile ? 0 : 2,
                color: isMobile ? Colors.transparent : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: isMobile
                      ? BorderSide.none
                      : const BorderSide(color: AppColors.border),
                ),
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 0.0 : 32.0),
                  child: _submitted
                      ? _buildSuccessView(context)
                      : Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const AppLogo(
                                title: AppStrings.forgotPassword,
                                subtitle: AppStrings.forgotPasswordSubtitle,
                              ),
                              const SizedBox(height: 32),
                              CustomTextField(
                                controller: _identifierController,
                                label: AppStrings.identifierLabel,
                                hint: AppStrings.identifierHint,
                                prefixIcon: Icons.mark_email_read_outlined,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                validator: Validators.validateIdentifier,
                                onFieldSubmitted: (_) => _handleResetPassword(),
                              ),
                              const SizedBox(height: 24),
                              CustomButton(
                                text: AppStrings.resetPasswordButton,
                                isLoading: authProvider.isLoading,
                                onPressed: authProvider.isLoading
                                    ? null
                                    : _handleResetPassword,
                                icon: Icons.send_rounded,
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text(
                                  AppStrings.backToLogin,
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.successLight,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.mark_email_read_rounded,
              size: 38,
              color: AppColors.success,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Check Your Inbox',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'We have dispatched password reset instructions to ${_identifierController.text.trim()}.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 28),
        CustomButton(
          text: AppStrings.backToLogin,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icons.arrow_back_rounded,
        ),
      ],
    );
  }
}

