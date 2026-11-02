class AppStrings {
  // App General
  static const String appName = 'AuthFlow';
  static const String welcomeBack = 'Welcome Back!';
  static const String loginSubtitle = 'Sign in to access your account & manage your workspace';
  static const String createAccount = 'Create Account';
  static const String registerSubtitle = 'Join our platform today and explore endless possibilities';
  static const String forgotPassword = 'Forgot Password?';
  static const String forgotPasswordSubtitle = 'Enter your email or mobile to receive recovery instructions';

  // Labels & Hints
  static const String identifierLabel = 'Email or Mobile Number';
  static const String identifierHint = 'name@example.com or 10-digit number';
  static const String fullNameLabel = 'Full Name';
  static const String fullNameHint = 'John Doe';
  static const String emailLabel = 'Email Address';
  static const String emailHint = 'john.doe@example.com';
  static const String mobileLabel = 'Mobile Number';
  static const String mobileHint = '9876543210';
  static const String passwordLabel = 'Password';
  static const String passwordHint = '••••••••';
  static const String confirmPasswordLabel = 'Confirm Password';
  static const String confirmPasswordHint = '••••••••';

  // Actions
  static const String loginButton = 'Sign In';
  static const String registerButton = 'Create Account';
  static const String resetPasswordButton = 'Send Reset Link';
  static const String rememberMe = 'Remember Me';
  static const String termsNotice = 'I agree to the Terms of Service & Privacy Policy';
  static const String termsRequired = 'You must accept the terms and conditions';
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String dontHaveAccount = "Don't have an account?";
  static const String signIn = 'Sign In';
  static const String signUp = 'Sign Up';
  static const String backToLogin = 'Back to Sign In';
  static const String logout = 'Log Out';
  static const String demoAccount = 'Demo Account Quick Fill';

  // Validation Messages
  static const String requiredField = 'This field is required';
  static const String invalidIdentifier = 'Enter a valid email address or 10-digit mobile number';
  static const String invalidEmail = 'Enter a valid email address (e.g. user@domain.com)';
  static const String invalidMobile = 'Enter a valid 10-digit mobile number';
  static const String invalidName = 'Full name must be at least 3 characters and contain only letters';
  static const String passwordTooShort = 'Password must be at least 8 characters long';
  static const String passwordNeedsUpper = 'Must contain at least one uppercase letter';
  static const String passwordNeedsLower = 'Must contain at least one lowercase letter';
  static const String passwordNeedsDigit = 'Must contain at least one number';
  static const String passwordNeedsSpecial = 'Must contain at least one special character (@\$!%*?&)';
  static const String passwordsDoNotMatch = 'Passwords do not match';

  // Feedback Messages
  static const String loginSuccess = 'Welcome back! Login successful.';
  static const String registrationSuccess = 'Account created successfully! Welcome aboard.';
  static const String resetSuccess = 'Password reset instructions have been sent to your inbox/phone.';
  static const String logoutConfirmTitle = 'Log Out';
  static const String logoutConfirmMessage = 'Are you sure you want to sign out of your account?';
  static const String cancel = 'Cancel';
}
