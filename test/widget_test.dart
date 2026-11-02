import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:login_resistration/controllers/auth_provider.dart';
import 'package:login_resistration/core/constants/app_strings.dart';
import 'package:login_resistration/core/constants/app_theme.dart';
import 'package:login_resistration/core/utils/validators.dart';
import 'package:login_resistration/services/auth_service.dart';
import 'package:login_resistration/views/auth/login_screen.dart';
import 'package:login_resistration/views/auth/register_screen.dart';
import 'package:login_resistration/views/widgets/custom_button.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Validators Unit Tests', () {
    test('validateIdentifier accepts valid email and 10-digit mobile', () {
      expect(Validators.validateIdentifier('user@example.com'), isNull);
      expect(Validators.validateIdentifier('9876543210'), isNull);
      expect(Validators.validateIdentifier(''), AppStrings.requiredField);
      expect(Validators.validateIdentifier('invalid-input'), AppStrings.invalidIdentifier);
      expect(Validators.validateIdentifier('12345'), AppStrings.invalidIdentifier);
    });

    test('validateFullName validates min 3 characters and alphabets', () {
      expect(Validators.validateFullName('John Doe'), isNull);
      expect(Validators.validateFullName(''), AppStrings.requiredField);
      expect(Validators.validateFullName('Ab'), AppStrings.invalidName);
      expect(Validators.validateFullName('John123'), 'Name must contain only alphabets and spaces');
    });

    test('validateEmail validates standard emails', () {
      expect(Validators.validateEmail('test@domain.com'), isNull);
      expect(Validators.validateEmail('invalid-email'), AppStrings.invalidEmail);
      expect(Validators.validateEmail(''), AppStrings.requiredField);
    });

    test('validateMobile validates 10-digit numbers', () {
      expect(Validators.validateMobile('9876543210'), isNull);
      expect(Validators.validateMobile('1234'), AppStrings.invalidMobile);
      expect(Validators.validateMobile('987654321099'), AppStrings.invalidMobile);
      expect(Validators.validateMobile('abcdefghij'), AppStrings.invalidMobile);
    });

    test('validatePassword validates length and character types', () {
      expect(Validators.validatePassword('Password123!'), isNull);
      expect(Validators.validatePassword('Pass1!'), AppStrings.passwordTooShort);
      expect(Validators.validatePassword('password123!'), AppStrings.passwordNeedsUpper);
      expect(Validators.validatePassword('PASSWORD123!'), AppStrings.passwordNeedsLower);
      expect(Validators.validatePassword('Password!!!!'), AppStrings.passwordNeedsDigit);
      expect(Validators.validatePassword('Password1234'), AppStrings.passwordNeedsSpecial);
    });

    test('validateConfirmPassword ensures matching', () {
      expect(Validators.validateConfirmPassword('Password123!', 'Password123!'), isNull);
      expect(
        Validators.validateConfirmPassword('DifferentPassword!', 'Password123!'),
        AppStrings.passwordsDoNotMatch,
      );
    });

    test('Password strength scoring', () {
      expect(Validators.getPasswordStrengthScore(''), 0.0);
      expect(Validators.getPasswordStrength('weak'), PasswordStrength.weak);
      expect(Validators.getPasswordStrength('Password123!'), PasswordStrength.strong);
    });
  });

  group('AuthService Mock Integration Tests', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    test('Login with valid email succeeds', () async {
      final res = await authService.login(
        identifier: 'user@example.com',
        password: 'Password123!',
      );
      expect(res.isSuccess, isTrue);
      expect(res.data?.email, 'user@example.com');
    });

    test('Login with valid mobile succeeds', () async {
      final res = await authService.login(
        identifier: '9876543210',
        password: 'Password123!',
      );
      expect(res.isSuccess, isTrue);
      expect(res.data?.mobileNumber, '9876543210');
    });

    test('Login with incorrect password fails', () async {
      final res = await authService.login(
        identifier: 'user@example.com',
        password: 'WrongPassword!',
      );
      expect(res.isSuccess, isFalse);
      expect(res.statusCode, 401);
    });

    test('Registration creates user and prevents duplicates', () async {
      final uniqueEmail = 'new_${DateTime.now().millisecondsSinceEpoch}@example.com';
      final uniqueMobile = '8${DateTime.now().millisecondsSinceEpoch.toString().substring(4, 13)}';

      final res = await authService.register(
        fullName: 'Test User',
        email: uniqueEmail,
        mobileNumber: uniqueMobile,
        password: 'Password123!',
      );
      expect(res.isSuccess, isTrue);
      expect(res.data?.email, uniqueEmail);

      // Attempt duplicate
      final dupRes = await authService.register(
        fullName: 'Test User 2',
        email: uniqueEmail,
        mobileNumber: '9999999999',
        password: 'Password123!',
      );
      expect(dupRes.isSuccess, isFalse);
      expect(dupRes.statusCode, 409);
    });
  });

  group('Widget & UI Tests', () {
    Widget createWidgetUnderTest(Widget child) {
      final authProvider = AuthProvider();
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: child,
          ),
        ),
      );
    }

    testWidgets('LoginScreen renders all required UI elements', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest(const LoginScreen()));

      expect(find.text(AppStrings.signInHeader), findsOneWidget);
      expect(find.text(AppStrings.identifierLabel), findsOneWidget);
      expect(find.text(AppStrings.passwordLabel), findsOneWidget);
      expect(find.text(AppStrings.rememberMe), findsOneWidget);
      expect(find.text(AppStrings.forgotPassword), findsOneWidget);
      expect(find.text(AppStrings.loginButton), findsOneWidget);
      expect(find.text(AppStrings.signUp), findsOneWidget);
    });

    testWidgets('Validation errors appear when submitting empty login form', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest(const LoginScreen()));

      // Tap Login button
      await tester.tap(find.text(AppStrings.loginButton));
      await tester.pumpAndSettle();

      // Should display required field error
      expect(find.text(AppStrings.requiredField), findsWidgets);
    });

    testWidgets('Show / hide password icon toggles obscureText', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest(const LoginScreen()));

      // Locate password toggle button
      final toggleFinder = find.byTooltip('Show password');
      expect(toggleFinder, findsOneWidget);

      await tester.tap(toggleFinder);
      await tester.pumpAndSettle();

      expect(find.byTooltip('Hide password'), findsOneWidget);
    });

    testWidgets('RegisterScreen renders all required fields', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest(const RegisterScreen()));

      expect(find.text(AppStrings.fullNameLabel), findsOneWidget);
      expect(find.text(AppStrings.emailLabel), findsOneWidget);
      expect(find.text(AppStrings.mobileLabel), findsOneWidget);
      expect(find.text(AppStrings.passwordLabel), findsOneWidget);
      expect(find.text(AppStrings.confirmPasswordLabel), findsOneWidget);
      expect(find.widgetWithText(CustomButton, AppStrings.registerButton), findsOneWidget);
      expect(find.text(AppStrings.termsNotice), findsOneWidget);
    });
  });
}
