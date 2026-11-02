# AuthFlow - Flutter Login & Registration Module

A functional, responsive, and robust Authentication Module built with **Flutter & Dart**, adhering to clean code architecture, layered separation of concerns, modern UI/UX practices, and **Provider** state management.

---

## 📱 Screenshots & Design Highlights

The UI is inspired by a modern, minimalist coral-pink aesthetic featuring:
- **Curved Wavy Header**: Dynamic S-curve wave separating the header and content, complete with subtle topographic contour patterns rendered via `CustomPainter`.
- **Top Chevron Navigation `<`**: iOS-style sleek back navigation in the header for smooth screen transitions.
- **Minimalist Form Inputs**: Outline icons, vertical separators (`|`), and clean underline indicators.
- **Dynamic Password Strength Meter**: Live strength score (0%–100%) and rule compliance checklist (length, uppercase, lowercase, numbers, special characters).
- **Responsive & Overflow-Free**: Fully responsive across compact phones, standard devices, tablets, and landscape orientations with `MediaQuery` breakpoints.

---

## 🌟 Key Features

### 1. Login Screen
- **Email / Mobile Number Dual Input**: Accepts either a valid email or a 10-digit mobile number with smart regex detection and live error feedback.
- **Password Field**: Bullet dot placeholder with interactive Show / Hide password toggle eye icon.
- **Remember Me**: Saves user identifier across application restarts using persistent local storage (`SharedPreferences`).
- **Forgot Password Navigation**: Direct navigation to password recovery screen.
- **Login Button with Loading Spinner**: Gradient/solid coral button that disables and displays a `CircularProgressIndicator` while authenticating.
- **Navigation to Register**: Seamless link to the Registration screen.

### 2. Registration Screen
- **Full Name**: Strict alphabetical validation (minimum 3 characters, letters & spaces only).
- **Email Address**: RFC 5322 compliant regex validation.
- **Mobile Number**: 10-digit mobile number format validation.
- **Password**: Real-time password strength meter and rule checks.
- **Confirm Password**: Real-time match verification.
- **Terms & Conditions**: Interactive agreement checkbox required before account creation.
- **Register Button**: Loading indicator state during registration simulation.
- **Navigation to Login**: Back chevron `<` icon in header and bottom link.

### 3. Password Recovery (Forgot Password Screen)
- Input for registered email or mobile number.
- Reset instructions dispatch simulation.
- Success confirmation view with return to Login.

### 4. Home / Dashboard Screen
- Authenticated user workspace screen.
- Displays user profile avatar with name initials, full name, email, mobile number, and active session badge.
- Session status and persistent "Remember Me" indicator.
- Sign out action with confirmation dialog.

---

## 🏗️ Architecture & Project Structure

The project strictly follows the **Separation of Concerns** principle:

```
lib/
├── main.dart                          # App entry point, MultiProvider & session routing
├── core/
│   ├── constants/
│   │   ├── app_colors.dart            # Coral/salmon palette, gradients, and typography colors
│   │   ├── app_strings.dart           # Centralized string constants (Login, Register, errors)
│   │   └── app_theme.dart             # Material 3 theme, input decoration & button styling
│   └── utils/
│       ├── responsive_layout.dart     # MediaQuery breakpoints, adaptive header height & padding
│       ├── snackbar_helper.dart       # Floating notification snackbars (Success, Error, Info, Warning)
│       └── validators.dart            # Form input regex & password strength logic
├── models/
│   ├── api_response.dart              # Generic API response wrapper (success/failure, status codes)
│   └── user_model.dart                # User entity with JSON serialization & immutability
├── services/
│   ├── auth_service.dart              # Mock Auth API with latency simulation & mock database
│   └── local_storage_service.dart     # SharedPreferences persistence for Remember Me & session
├── controllers/
│   └── auth_provider.dart             # Provider ChangeNotifier for auth state management
└── views/
    ├── widgets/
    │   ├── auth_header_title.dart     # Reusable title with coral accent underline bar
    │   ├── custom_button.dart         # Reusable rounded button with loading indicator
    │   ├── custom_text_field.dart     # Reusable input field with prefix icon, divider & toggle
    │   ├── password_strength_meter.dart # Dynamic password strength bar & rule checklist
    │   └── wavy_header.dart           # S-curve wave header with topographic contour lines
    ├── auth/
    │   ├── login_screen.dart          # Responsive Login view
    │   ├── register_screen.dart       # Responsive Registration view
    │   └── forgot_password_screen.dart # Responsive Password Recovery view
    └── home/
        └── home_screen.dart           # Authenticated user dashboard view
```

---

## 🧪 Testing & Code Quality

- **16 Automated Tests** passing (100% test success rate):
  - Unit tests for all field validators (email, mobile, identifier, full name, password rules, matching).
  - Password strength scoring logic tests.
  - `AuthService` integration tests (valid login, invalid password, duplicate user rejection, registration).
  - Widget UI tests for Login & Registration screens.
  - Responsive screen adaptation tests (Compact mobile 360x640, Tablet 1280x800).
- **Zero Lint Issues**: Strict adherence to `flutter_lints` (`flutter analyze` reports 0 issues).

Run test suite:
```bash
flutter test
```

Run static analysis:
```bash
flutter analyze
```

---

## 🔑 Pre-Seeded Demo Accounts

You can test authentication using these credentials:

| Identifier | Password | Full Name |
| :--- | :--- | :--- |
| `user@example.com` | `Password123!` | Alex Johnson |
| `9476543210` | `Password123!` | Alex Johnson |
| `sarah@example.com` | `Password123!` | Sarah Connor |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `^3.13.0` or higher
- Dart SDK `^3.13.0` or higher

### Steps to Run
```bash
# 1. Clone repository
git clone <repo-url>
cd login_resistration

# 2. Install dependencies
flutter pub get

# 3. Run on your connected device or emulator
flutter run
```
*Supports Android, iOS, Web, and Desktop (Windows).*
