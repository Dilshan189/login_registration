import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/snackbar_helper.dart';
import '../../core/utils/validators.dart';
import '../home/home_screen.dart';
import '../widgets/auth_header_title.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/wavy_header.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _identifierController;
  late final TextEditingController _passwordController;
  final FocusNode _passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _identifierController = TextEditingController(
      text: authProvider.savedIdentifier,
    );
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(
      identifier: _identifierController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      SnackBarHelper.showSuccess(
        context,
        authProvider.successMessage ?? AppStrings.loginSuccess,
      );
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      SnackBarHelper.showError(
        context,
        authProvider.errorMessage ?? 'Login failed. Please check credentials.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final isDesktop = screenWidth >= 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            // Top Wavy Coral Header with Topography Lines
            WavyHeader(height: isDesktop ? 220 : media.size.height * 0.28),

            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),

                        // "Sign in" Header with accent line
                        const AuthHeaderTitle(title: AppStrings.signInHeader),
                        const SizedBox(height: 24),

                        // Email or Mobile Field
                        CustomTextField(
                          controller: _identifierController,
                          label: AppStrings.identifierLabel,
                          hint: AppStrings.identifierHint,
                          prefixIcon: Icons.mail_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: Validators.validateIdentifier,
                          onFieldSubmitted: (_) =>
                              _passwordFocus.requestFocus(),
                        ),
                        const SizedBox(height: 20),

                        // Password Field with Show/Hide toggle
                        CustomTextField(
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          label: AppStrings.passwordLabel,
                          hint: AppStrings.passwordHint,
                          prefixIcon: Icons.lock_outline_rounded,
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return AppStrings.requiredField;
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => _handleLogin(),
                        ),
                        const SizedBox(height: 14),

                        // Remember Me and Forgot Password Row
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runSpacing: 8,
                          children: [
                            // Remember me checkbox
                            InkWell(
                              onTap: () {
                                authProvider.toggleRememberMe(
                                  !authProvider.rememberMe,
                                );
                              },
                              borderRadius: BorderRadius.circular(6),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: Checkbox(
                                      value: authProvider.rememberMe,
                                      onChanged: authProvider.toggleRememberMe,
                                      activeColor: AppColors.primary,
                                      side: const BorderSide(
                                        color: AppColors.primary,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    AppStrings.rememberMe,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Forgot Password link
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                AppStrings.forgotPassword,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Sign In Action Button
                        CustomButton(
                          text: AppStrings.loginButton,
                          isLoading: authProvider.isLoading,
                          onPressed: authProvider.isLoading
                              ? null
                              : _handleLogin,
                        ),
                        const SizedBox(height: 36),

                        // Footer: "Don't have an Account ? Sign up"
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              AppStrings.dontHaveAccount,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                AppStrings.signUp,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
