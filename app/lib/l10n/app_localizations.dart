import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
    Locale('pt'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Gaijin Life Navi'**
  String get appTitle;

  /// Title on language selection screen
  ///
  /// In en, this message translates to:
  /// **'Choose Your Language'**
  String get languageSelectionTitle;

  /// Subtitle on language selection screen
  ///
  /// In en, this message translates to:
  /// **'You can change this later in settings'**
  String get languageSelectionSubtitle;

  /// Continue button label
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Login screen title
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginTitle;

  /// Login screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get loginSubtitle;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// Login button label
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginButton;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No account text
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// Sign up link text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Register screen title
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerTitle;

  /// Register screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Start your life in Japan with confidence'**
  String get registerSubtitle;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// Register button label
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerButton;

  /// Has account text
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get hasAccount;

  /// Sign in link text
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Reset password screen title
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// Reset password screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a reset link'**
  String get resetPasswordSubtitle;

  /// Send reset link button label
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// Back to login link text
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// Reset password success message
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent. Check your inbox.'**
  String get resetPasswordSuccess;

  /// Email required validation
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// Email invalid validation
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalid;

  /// Password required validation
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// Password too short validation
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// Password mismatch validation
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// Chat tab label
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get tabChat;

  /// Tracker tab label
  ///
  /// In en, this message translates to:
  /// **'Tracker'**
  String get tabTracker;

  /// Navigate tab label
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get tabNavigate;

  /// Profile tab label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// Welcome message on home screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to Gaijin Life Navi'**
  String get homeWelcome;

  /// Home screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Your guide to life in Japan'**
  String get homeSubtitle;

  /// Quick actions section title
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get homeQuickActions;

  /// Ask AI quick action
  ///
  /// In en, this message translates to:
  /// **'Ask AI'**
  String get homeActionAskAI;

  /// Tracker quick action
  ///
  /// In en, this message translates to:
  /// **'Tracker'**
  String get homeActionTracker;

  /// Banking quick action
  ///
  /// In en, this message translates to:
  /// **'Banking'**
  String get homeActionBanking;

  /// Chat history quick action
  ///
  /// In en, this message translates to:
  /// **'Chat History'**
  String get homeActionChatHistory;

  /// Recent chats section title
  ///
  /// In en, this message translates to:
  /// **'Recent Chats'**
  String get homeRecentChats;

  /// No recent chats message
  ///
  /// In en, this message translates to:
  /// **'No recent chats yet'**
  String get homeNoRecentChats;

  /// Messages count label
  ///
  /// In en, this message translates to:
  /// **'messages'**
  String get homeMessagesLabel;

  /// Chat placeholder text
  ///
  /// In en, this message translates to:
  /// **'AI Chat — Coming Soon'**
  String get chatPlaceholder;

  /// Chat screen title
  ///
  /// In en, this message translates to:
  /// **'AI Chat'**
  String get chatTitle;

  /// New chat session button
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get chatNewSession;

  /// Empty chat list title
  ///
  /// In en, this message translates to:
  /// **'Start a Conversation'**
  String get chatEmptyTitle;

  /// Empty chat list subtitle
  ///
  /// In en, this message translates to:
  /// **'Ask the AI anything about living in Japan'**
  String get chatEmptySubtitle;

  /// Untitled session label
  ///
  /// In en, this message translates to:
  /// **'New Conversation'**
  String get chatUntitledSession;

  /// Chat conversation screen title
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chatConversationTitle;

  /// Chat input hint text
  ///
  /// In en, this message translates to:
  /// **'Ask about life in Japan...'**
  String get chatInputHint;

  /// Typing indicator text
  ///
  /// In en, this message translates to:
  /// **'Thinking...'**
  String get chatTyping;

  /// Sources section label
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get chatSources;

  /// Retry button label
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get chatRetry;

  /// Delete chat dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Chat'**
  String get chatDeleteTitle;

  /// Delete chat confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this chat?'**
  String get chatDeleteConfirm;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get chatDeleteCancel;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get chatDeleteAction;

  /// Daily limit reached label
  ///
  /// In en, this message translates to:
  /// **'Daily limit reached'**
  String get chatLimitReached;

  /// Remaining chat count
  ///
  /// In en, this message translates to:
  /// **'{remaining}/{limit} remaining'**
  String chatRemainingCount(int remaining, int limit);

  /// Limit reached dialog title
  ///
  /// In en, this message translates to:
  /// **'Daily Limit Reached'**
  String get chatLimitReachedTitle;

  /// Limit reached dialog message
  ///
  /// In en, this message translates to:
  /// **'You have used all your free chats for today. Upgrade to Premium for unlimited access.'**
  String get chatLimitReachedMessage;

  /// Upgrade to premium button
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get chatUpgradeToPremium;

  /// Chat welcome prompt
  ///
  /// In en, this message translates to:
  /// **'How can I help you today?'**
  String get chatWelcomePrompt;

  /// Chat welcome hint
  ///
  /// In en, this message translates to:
  /// **'Ask about visa procedures, banking, housing, or anything about life in Japan.'**
  String get chatWelcomeHint;

  /// Onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Setup Your Profile'**
  String get onboardingTitle;

  /// Skip onboarding button
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// Next step button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// Complete onboarding button
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get onboardingComplete;

  /// Step indicator
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String onboardingStepOf(int current, int total);

  /// Nationality step title
  ///
  /// In en, this message translates to:
  /// **'What is your nationality?'**
  String get onboardingNationalityTitle;

  /// Nationality step subtitle
  ///
  /// In en, this message translates to:
  /// **'This helps us provide relevant information for your situation.'**
  String get onboardingNationalitySubtitle;

  /// Residence status step title
  ///
  /// In en, this message translates to:
  /// **'What is your residence status?'**
  String get onboardingResidenceStatusTitle;

  /// Residence status step subtitle
  ///
  /// In en, this message translates to:
  /// **'Select your current visa type in Japan.'**
  String get onboardingResidenceStatusSubtitle;

  /// Region step title
  ///
  /// In en, this message translates to:
  /// **'Where do you live?'**
  String get onboardingRegionTitle;

  /// Region step subtitle
  ///
  /// In en, this message translates to:
  /// **'Select the area you currently live in or plan to move to.'**
  String get onboardingRegionSubtitle;

  /// Arrival date step title
  ///
  /// In en, this message translates to:
  /// **'When did you arrive in Japan?'**
  String get onboardingArrivalDateTitle;

  /// Arrival date step subtitle
  ///
  /// In en, this message translates to:
  /// **'This helps us suggest relevant procedures and deadlines.'**
  String get onboardingArrivalDateSubtitle;

  /// Select date button
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get onboardingSelectDate;

  /// Change date button
  ///
  /// In en, this message translates to:
  /// **'Change Date'**
  String get onboardingChangeDate;

  /// Country name
  ///
  /// In en, this message translates to:
  /// **'China'**
  String get countryCN;

  /// Country name
  ///
  /// In en, this message translates to:
  /// **'Vietnam'**
  String get countryVN;

  /// Country name
  ///
  /// In en, this message translates to:
  /// **'South Korea'**
  String get countryKR;

  /// Country name
  ///
  /// In en, this message translates to:
  /// **'Philippines'**
  String get countryPH;

  /// Country name
  ///
  /// In en, this message translates to:
  /// **'Brazil'**
  String get countryBR;

  /// Country name
  ///
  /// In en, this message translates to:
  /// **'Nepal'**
  String get countryNP;

  /// Country name
  ///
  /// In en, this message translates to:
  /// **'Indonesia'**
  String get countryID;

  /// Country name
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get countryUS;

  /// Country name
  ///
  /// In en, this message translates to:
  /// **'Thailand'**
  String get countryTH;

  /// Country name
  ///
  /// In en, this message translates to:
  /// **'India'**
  String get countryIN;

  /// Country name
  ///
  /// In en, this message translates to:
  /// **'Myanmar'**
  String get countryMM;

  /// Country name
  ///
  /// In en, this message translates to:
  /// **'Taiwan'**
  String get countryTW;

  /// Country name
  ///
  /// In en, this message translates to:
  /// **'Peru'**
  String get countryPE;

  /// Country name
  ///
  /// In en, this message translates to:
  /// **'United Kingdom'**
  String get countryGB;

  /// Country name
  ///
  /// In en, this message translates to:
  /// **'Pakistan'**
  String get countryPK;

  /// Country name
  ///
  /// In en, this message translates to:
  /// **'Bangladesh'**
  String get countryBD;

  /// Country name
  ///
  /// In en, this message translates to:
  /// **'Sri Lanka'**
  String get countryLK;

  /// Country name
  ///
  /// In en, this message translates to:
  /// **'France'**
  String get countryFR;

  /// Country name
  ///
  /// In en, this message translates to:
  /// **'Germany'**
  String get countryDE;

  /// Other country
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get countryOther;

  /// Visa type
  ///
  /// In en, this message translates to:
  /// **'Engineer / Specialist'**
  String get visaEngineer;

  /// Visa type
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get visaStudent;

  /// Visa type
  ///
  /// In en, this message translates to:
  /// **'Dependent'**
  String get visaDependent;

  /// Visa type
  ///
  /// In en, this message translates to:
  /// **'Permanent Resident'**
  String get visaPermanent;

  /// Visa type
  ///
  /// In en, this message translates to:
  /// **'Spouse of Japanese National'**
  String get visaSpouse;

  /// Visa type
  ///
  /// In en, this message translates to:
  /// **'Working Holiday'**
  String get visaWorkingHoliday;

  /// Visa type
  ///
  /// In en, this message translates to:
  /// **'Specified Skilled Worker'**
  String get visaSpecifiedSkilled;

  /// Visa type
  ///
  /// In en, this message translates to:
  /// **'Technical Intern'**
  String get visaTechnicalIntern;

  /// Visa type
  ///
  /// In en, this message translates to:
  /// **'Highly Skilled Professional'**
  String get visaHighlySkilled;

  /// Other visa type
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get visaOther;

  /// Region name
  ///
  /// In en, this message translates to:
  /// **'Tokyo'**
  String get regionTokyo;

  /// Region name
  ///
  /// In en, this message translates to:
  /// **'Osaka'**
  String get regionOsaka;

  /// Region name
  ///
  /// In en, this message translates to:
  /// **'Nagoya'**
  String get regionNagoya;

  /// Region name
  ///
  /// In en, this message translates to:
  /// **'Yokohama'**
  String get regionYokohama;

  /// Region name
  ///
  /// In en, this message translates to:
  /// **'Fukuoka'**
  String get regionFukuoka;

  /// Region name
  ///
  /// In en, this message translates to:
  /// **'Sapporo'**
  String get regionSapporo;

  /// Region name
  ///
  /// In en, this message translates to:
  /// **'Kobe'**
  String get regionKobe;

  /// Region name
  ///
  /// In en, this message translates to:
  /// **'Kyoto'**
  String get regionKyoto;

  /// Region name
  ///
  /// In en, this message translates to:
  /// **'Sendai'**
  String get regionSendai;

  /// Region name
  ///
  /// In en, this message translates to:
  /// **'Hiroshima'**
  String get regionHiroshima;

  /// Other region
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get regionOther;

  /// Tracker placeholder text
  ///
  /// In en, this message translates to:
  /// **'Admin Tracker — Coming Soon'**
  String get trackerPlaceholder;

  /// Navigate placeholder text
  ///
  /// In en, this message translates to:
  /// **'Navigate — Coming Soon'**
  String get navigatePlaceholder;

  /// Profile placeholder text
  ///
  /// In en, this message translates to:
  /// **'Profile — Coming Soon'**
  String get profilePlaceholder;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get networkError;

  /// Logout button label
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko', 'pt', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
