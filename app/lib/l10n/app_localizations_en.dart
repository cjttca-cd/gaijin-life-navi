// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Gaijin Life Navi';

  @override
  String get languageSelectionTitle => 'Choose Your Language';

  @override
  String get languageSelectionSubtitle =>
      'You can change this later in settings';

  @override
  String get continueButton => 'Continue';

  @override
  String get loginTitle => 'Welcome Back';

  @override
  String get loginSubtitle => 'Sign in to your account';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Sign In';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerSubtitle => 'Start your life in Japan with confidence';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get registerButton => 'Create Account';

  @override
  String get hasAccount => 'Already have an account?';

  @override
  String get signIn => 'Sign In';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get resetPasswordSubtitle =>
      'Enter your email to receive a reset link';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get resetPasswordSuccess =>
      'Password reset email sent. Check your inbox.';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Please enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get tabHome => 'Home';

  @override
  String get tabChat => 'Chat';

  @override
  String get tabTracker => 'Tracker';

  @override
  String get tabNavigate => 'Navigate';

  @override
  String get tabProfile => 'Profile';

  @override
  String get homeWelcome => 'Welcome to Gaijin Life Navi';

  @override
  String get homeSubtitle => 'Your guide to life in Japan';

  @override
  String get chatPlaceholder => 'AI Chat — Coming Soon';

  @override
  String get trackerPlaceholder => 'Admin Tracker — Coming Soon';

  @override
  String get navigatePlaceholder => 'Navigate — Coming Soon';

  @override
  String get profilePlaceholder => 'Profile — Coming Soon';

  @override
  String get genericError => 'Something went wrong. Please try again.';

  @override
  String get networkError => 'Network error. Please check your connection.';

  @override
  String get logout => 'Logout';
}
