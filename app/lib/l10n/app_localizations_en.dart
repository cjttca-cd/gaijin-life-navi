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
  String get homeQuickActions => 'Quick Actions';

  @override
  String get homeActionAskAI => 'Ask AI';

  @override
  String get homeActionTracker => 'Tracker';

  @override
  String get homeActionBanking => 'Banking';

  @override
  String get homeActionChatHistory => 'Chat History';

  @override
  String get homeRecentChats => 'Recent Chats';

  @override
  String get homeNoRecentChats => 'No recent chats yet';

  @override
  String get homeMessagesLabel => 'messages';

  @override
  String get chatPlaceholder => 'AI Chat — Coming Soon';

  @override
  String get chatTitle => 'AI Chat';

  @override
  String get chatNewSession => 'New Chat';

  @override
  String get chatEmptyTitle => 'Start a Conversation';

  @override
  String get chatEmptySubtitle => 'Ask the AI anything about living in Japan';

  @override
  String get chatUntitledSession => 'New Conversation';

  @override
  String get chatConversationTitle => 'Chat';

  @override
  String get chatInputHint => 'Ask about life in Japan...';

  @override
  String get chatTyping => 'Thinking...';

  @override
  String get chatSources => 'Sources';

  @override
  String get chatRetry => 'Retry';

  @override
  String get chatDeleteTitle => 'Delete Chat';

  @override
  String get chatDeleteConfirm => 'Are you sure you want to delete this chat?';

  @override
  String get chatDeleteCancel => 'Cancel';

  @override
  String get chatDeleteAction => 'Delete';

  @override
  String get chatLimitReached => 'Daily limit reached';

  @override
  String chatRemainingCount(int remaining, int limit) {
    return '$remaining/$limit remaining';
  }

  @override
  String get chatLimitReachedTitle => 'Daily Limit Reached';

  @override
  String get chatLimitReachedMessage =>
      'You have used all your free chats for today. Upgrade to Premium for unlimited access.';

  @override
  String get chatUpgradeToPremium => 'Upgrade to Premium';

  @override
  String get chatWelcomePrompt => 'How can I help you today?';

  @override
  String get chatWelcomeHint =>
      'Ask about visa procedures, banking, housing, or anything about life in Japan.';

  @override
  String get onboardingTitle => 'Setup Your Profile';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingComplete => 'Complete';

  @override
  String onboardingStepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get onboardingNationalityTitle => 'What is your nationality?';

  @override
  String get onboardingNationalitySubtitle =>
      'This helps us provide relevant information for your situation.';

  @override
  String get onboardingResidenceStatusTitle => 'What is your residence status?';

  @override
  String get onboardingResidenceStatusSubtitle =>
      'Select your current visa type in Japan.';

  @override
  String get onboardingRegionTitle => 'Where do you live?';

  @override
  String get onboardingRegionSubtitle =>
      'Select the area you currently live in or plan to move to.';

  @override
  String get onboardingArrivalDateTitle => 'When did you arrive in Japan?';

  @override
  String get onboardingArrivalDateSubtitle =>
      'This helps us suggest relevant procedures and deadlines.';

  @override
  String get onboardingSelectDate => 'Select Date';

  @override
  String get onboardingChangeDate => 'Change Date';

  @override
  String get countryCN => 'China';

  @override
  String get countryVN => 'Vietnam';

  @override
  String get countryKR => 'South Korea';

  @override
  String get countryPH => 'Philippines';

  @override
  String get countryBR => 'Brazil';

  @override
  String get countryNP => 'Nepal';

  @override
  String get countryID => 'Indonesia';

  @override
  String get countryUS => 'United States';

  @override
  String get countryTH => 'Thailand';

  @override
  String get countryIN => 'India';

  @override
  String get countryMM => 'Myanmar';

  @override
  String get countryTW => 'Taiwan';

  @override
  String get countryPE => 'Peru';

  @override
  String get countryGB => 'United Kingdom';

  @override
  String get countryPK => 'Pakistan';

  @override
  String get countryBD => 'Bangladesh';

  @override
  String get countryLK => 'Sri Lanka';

  @override
  String get countryFR => 'France';

  @override
  String get countryDE => 'Germany';

  @override
  String get countryOther => 'Other';

  @override
  String get visaEngineer => 'Engineer / Specialist';

  @override
  String get visaStudent => 'Student';

  @override
  String get visaDependent => 'Dependent';

  @override
  String get visaPermanent => 'Permanent Resident';

  @override
  String get visaSpouse => 'Spouse of Japanese National';

  @override
  String get visaWorkingHoliday => 'Working Holiday';

  @override
  String get visaSpecifiedSkilled => 'Specified Skilled Worker';

  @override
  String get visaTechnicalIntern => 'Technical Intern';

  @override
  String get visaHighlySkilled => 'Highly Skilled Professional';

  @override
  String get visaOther => 'Other';

  @override
  String get regionTokyo => 'Tokyo';

  @override
  String get regionOsaka => 'Osaka';

  @override
  String get regionNagoya => 'Nagoya';

  @override
  String get regionYokohama => 'Yokohama';

  @override
  String get regionFukuoka => 'Fukuoka';

  @override
  String get regionSapporo => 'Sapporo';

  @override
  String get regionKobe => 'Kobe';

  @override
  String get regionKyoto => 'Kyoto';

  @override
  String get regionSendai => 'Sendai';

  @override
  String get regionHiroshima => 'Hiroshima';

  @override
  String get regionOther => 'Other';

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
