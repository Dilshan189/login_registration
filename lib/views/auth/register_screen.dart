import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/snackbar_helper.dart';
import '../../core/utils/validators.dart';
import '../home/home_screen.dart';
import '../widgets/app_logo.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/password_strength_meter.dart';

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
      SnackBarHelper.showWarning(context, AppStrings.termsRequired);
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 480;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Registration'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 16.0 : 24.0,
              vertical: 16.0,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Card(
                elevation: isCompact ? 0 : 2,
                color: isCompact ? Colors.transparent : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: isCompact
                      ? BorderSide.none
                      : const BorderSide(color: AppColors.border),
                ),
                child: Padding(
                  padding: EdgeInsets.all(isCompact ? 4.0 : 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AppLogo(
                          title: AppStrings.createAccount,
                          subtitle: AppStrings.registerSubtitle,
                          iconSize: 56,
                        ),
                        const SizedBox(height: 24),

                        // Full Name
                        CustomTextField(
                          controller: _fullNameController,
                          label: AppStrings.fullNameLabel,
                          hint: AppStrings.fullNameHint,
                          prefixIcon: Icons.badge_outlined,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: Validators.validateFullName,
                          onFieldSubmitted: (_) => _emailFocus.requestFocus(),
                        ),
                        const SizedBox(height: 16),

                        // Email Address
                        CustomTextField(
                          controller: _emailController,
                          focusNode: _emailFocus,
                          label: AppStrings.emailLabel,
                          hint: AppStrings.emailHint,
                          prefixIcon: Icons.alternate_email_rounded,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: Validators.validateEmail,
                          onFieldSubmitted: (_) => _mobileFocus.requestFocus(),
                        ),
                        const SizedBox(height: 16),

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
                        const SizedBox(height: 16),

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

                        // Dynamic Password Strength Meter
                        PasswordStrengthMeter(password: _currentPasswordText),
                        const SizedBox(height: 16),

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
                        const SizedBox(height: 16),

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
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _agreeToTerms,
                                  onChanged: (val) {
                                    setState(() {
                                      _agreeToTerms = val ?? false;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  AppStrings.termsNotice,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Registration Button with loading indicator
                        CustomButton(
                          text: AppStrings.registerButton,
                          isLoading: authProvider.isLoading,
                          onPressed: authProvider.isLoading ? null : _handleRegister,
                          icon: Icons.person_add_alt_1_rounded,
                        ),
                        const SizedBox(height: 20),

                        // Link back to Login
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              AppStrings.alreadyHaveAccount,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                AppStrings.signIn,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
}
