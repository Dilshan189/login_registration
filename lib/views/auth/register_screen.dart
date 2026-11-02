import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/responsive_layout.dart';
import '../../core/utils/snackbar_helper.dart';
import '../../core/utils/validators.dart';
import '../home/home_screen.dart';
import '../widgets/auth_header_title.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/password_strength_meter.dart';
import '../widgets/wavy_header.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _emailFocus = FocusNode();
  final _mobileFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  bool _agreeToTerms = false;
  String _currentPasswordText = '';

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {
        _currentPasswordText = _passwordController.text;
      });
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _emailFocus.dispose();
    _mobileFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeToTerms) {
      SnackBarHelper.showError(context, AppStrings.termsRequired);
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.register(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      mobileNumber: _mobileController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      SnackBarHelper.showSuccess(
        context,
        authProvider.successMessage ?? AppStrings.registrationSuccess,
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } else {
      SnackBarHelper.showError(
        context,
        authProvider.errorMessage ?? 'Registration failed. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final horizontalPad = ResponsiveLayout.horizontalPadding(context);
    final screenH = MediaQuery.sizeOf(context).height;
    
    // Balanced, elegant header height matching the original design
    final headerH = (screenH * 0.23).clamp(170.0, 220.0);
    final fieldGap = (screenH * 0.015).clamp(8.0, 14.0);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            // Prominent, beautiful Wavy Header with back chevron '<' button
            WavyHeader(
              height: headerH,
              child: SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 8.0),
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 4),

                        // "Register" Header with accent line
                        const AuthHeaderTitle(
                          title: AppStrings.signUpHeader,
                          fontSize: 28,
                          lineWidth: 40,
                        ),
                        SizedBox(height: fieldGap * 1.2),

                        // Full Name
                        CustomTextField(
                          controller: _fullNameController,
                          label: AppStrings.fullNameLabel,
                          hint: AppStrings.fullNameHint,
                          prefixIcon: Icons.person_outline_rounded,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: Validators.validateFullName,
                          onFieldSubmitted: (_) => _emailFocus.requestFocus(),
                        ),
                        SizedBox(height: fieldGap),

                        // Email Address
                        CustomTextField(
                          controller: _emailController,
                          focusNode: _emailFocus,
                          label: AppStrings.emailLabel,
                          hint: AppStrings.emailHint,
                          prefixIcon: Icons.mail_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: Validators.validateEmail,
                          onFieldSubmitted: (_) => _mobileFocus.requestFocus(),
                        ),
                        SizedBox(height: fieldGap),

                        // Mobile Number
                        CustomTextField(
                          controller: _mobileController,
                          focusNode: _mobileFocus,
                          label: AppStrings.mobileLabel,
                          hint: AppStrings.mobileHint,
                          prefixIcon: Icons.phone_android_rounded,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          validator: Validators.validateMobile,
                          onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                        ),
                        SizedBox(height: fieldGap),

                        // Password
                        CustomTextField(
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          label: AppStrings.passwordLabel,
                          hint: AppStrings.passwordHint,
                          prefixIcon: Icons.lock_outline_rounded,
                          isPassword: true,
                          textInputAction: TextInputAction.next,
                          validator: Validators.validatePassword,
                          onFieldSubmitted: (_) => _confirmPasswordFocus.requestFocus(),
                        ),

                        // Compact real-time password strength meter
                        PasswordStrengthMeter(password: _currentPasswordText),
                        SizedBox(height: fieldGap),

                        // Confirm Password
                        CustomTextField(
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocus,
                          label: AppStrings.confirmPasswordLabel,
                          hint: AppStrings.confirmPasswordHint,
                          prefixIcon: Icons.lock_reset_rounded,
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                          validator: (value) => Validators.validateConfirmPassword(
                            value,
                            _passwordController.text,
                          ),
                          onFieldSubmitted: (_) => _handleRegister(),
                        ),
                        SizedBox(height: fieldGap * 0.9),

                        // Terms and Conditions checkbox
                        InkWell(
                          onTap: () {
                            setState(() {
                              _agreeToTerms = !_agreeToTerms;
                            });
                          },
                          borderRadius: BorderRadius.circular(6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 22,
                                height: 22,
                                child: Checkbox(
                                  value: _agreeToTerms,
                                  onChanged: (val) {
                                    setState(() {
                                      _agreeToTerms = val ?? false;
                                    });
                                  },
                                  activeColor: AppColors.primary,
                                  side: const BorderSide(
                                    color: AppColors.primary,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  AppStrings.termsNotice,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: fieldGap * 1.8),

                        // Register Action Button
                        CustomButton(
                          text: AppStrings.registerButton,
                          height: 52,
                          isLoading: authProvider.isLoading,
                          onPressed: authProvider.isLoading ? null : _handleRegister,
                        ),
                        SizedBox(height: fieldGap * 1.5),

                        // Footer: "Already have an Account ? Login"
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              AppStrings.alreadyHaveAccount,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Text(
                                AppStrings.signIn,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
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
}
