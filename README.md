# AuthFlow - Flutter Login & Registration Module

A production-grade, responsive, and robust Authentication Module built with **Flutter & Dart**, adhering to clean code standards, layered architecture, and modern UI/UX practices.

---

## 🌟 Key Features

### 1. Login Screen
- **Dual Identifier Input**: Accepts either a valid Email Address or a 10-digit Mobile Number with smart regex-based validation.
- **Password Visibility Toggle**: Interactive Show/Hide password toggle.
- **Remember Me Option**: Saves identifier preference across app restarts using local storage (`SharedPreferences`).
- **Forgot Password Flow**: Streamlined recovery workflow with user feedback.
- **Loading State & Error Feedback**: Custom loading indicator button and floating SnackBar notifications.
- **Quick Demo Auto-Fill**: One-tap credential auto-fill for testing (`user@example.com` / `Password123!`).
- **Social Login Options**: Polished social sign-in UI (Google, Apple, GitHub).

### 2. Registration Screen
- **Full Name Input**: Validates minimum character length and alphabetical input.
- **Email Input**: Strict RFC-compliant email pattern validation.
- **Mobile Number Input**: 10-digit mobile number format validation.
- **Password with Live Strength Meter**: Real-time strength score (0-100%) and interactive rule checklist (length, uppercase, lowercase, numbers, special characters).
- **Confirm Password**: Real-time match verification.
- **Terms & Conditions**: Checkbox agreement validation before submission.
- **Smooth Navigation**: One-tap navigation back to the login screen.

### 3. Home / Dashboard Screen
- Greets the authenticated user with a modern profile header and avatar initials.
- Shows user information (User ID, Email, Mobile number, Session status).
- Confirmation dialog for secure sign-out.

---

## 🏗️ Architecture & Project Structure

The project strictly follows the **Separation of Concerns** principle:

```
lib/
├── main.dart                          # App entry point, MultiProvider configuration & routing
├── core/
│   ├── constants/
│   │   ├── app_colors.dart            # Color palette, gradients, and shadows
│   │   ├── app_strings.dart           # Centralized string constants
│   │   └── app_theme.dart             # Material 3 theme, input styling, button styling
│   └── utils/
│       ├── snackbar_helper.dart       # Elegant floating notification snackbars
│       └── validators.dart            # Form input validators & password strength scoring
├── models/
│   ├── api_response.dart              # Generic API response wrapper (success/failure)
│   └── user_model.dart                # User entity with JSON serialization & immutability
├── services/
│   ├── auth_service.dart              # Authentication service with network simulation & mock DB
│   └── local_storage_service.dart     # SharedPreferences session & credentials persistence
├── controllers/
│   └── auth_provider.dart             # Provider ChangeNotifier for state & business logic
└── views/
    ├── widgets/
    │   ├── app_logo.dart              # Reusable app branding logo header
    │   ├── custom_button.dart         # Gradient elevated button with loading spinner
    │   ├── custom_text_field.dart     # Accessible input field with password visibility toggle
    │   ├── password_strength_meter.dart # Visual strength meter & checklist
    │   └── social_auth_divider.dart   # Social sign-in divider and buttons
    ├── auth/
    │   ├── login_screen.dart          # Responsive login view
    │   ├── register_screen.dart       # Responsive registration view
    │   └── forgot_password_screen.dart # Password recovery view
    └── home/
        └── home_screen.dart           # Authenticated user dashboard view
```

---

## 🧪 Testing & Code Quality

- **100% Test Coverage** across all business logic, validators, authentication scenarios, and UI components.
- **Zero Analysis Warnings**: Fully compliant with `flutter_lints` and strict typing (`flutter analyze` reports 0 issues).

Run the automated test suite:
```bash
flutter test
```

Run static code analysis:
```bash
flutter analyze
```

---

## 🔑 Pre-Seeded Demo Credentials

You can test login using either of the following pre-configured credentials:

| Identifier | Password | Name |
| :--- | :--- | :--- |
| `user@example.com` | `Password123!` | Alex Johnson |
| `9876543210` | `Password123!` | Alex Johnson |
| `sarah@example.com` | `Password123!` | Sarah Connor |

> You can also click the **"Auto-Fill"** button on the login screen to populate these credentials instantly.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `^3.13.0` or higher
- Dart SDK `^3.13.0` or higher

### Installation & Run
1. Clone the repository:
   ```bash
   git clone <repo-url>
   cd login_resistration
   ```
2. Get dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```
   *Compatible with Android, iOS, Web, and Desktop (Windows).*
