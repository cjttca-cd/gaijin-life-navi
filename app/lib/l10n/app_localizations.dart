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

  /// Banking list screen title
  ///
  /// In en, this message translates to:
  /// **'Banking Navigator'**
  String get bankingTitle;

  /// Bank friendly score label
  ///
  /// In en, this message translates to:
  /// **'Foreigner-Friendly Score'**
  String get bankingFriendlyScore;

  /// Empty bank list message
  ///
  /// In en, this message translates to:
  /// **'No banks found'**
  String get bankingEmpty;

  /// Recommend button
  ///
  /// In en, this message translates to:
  /// **'Recommend'**
  String get bankingRecommendButton;

  /// Recommend screen title
  ///
  /// In en, this message translates to:
  /// **'Bank Recommendations'**
  String get bankingRecommendTitle;

  /// Priority selection label
  ///
  /// In en, this message translates to:
  /// **'Select your priorities'**
  String get bankingSelectPriorities;

  /// Priority chip
  ///
  /// In en, this message translates to:
  /// **'Multilingual Support'**
  String get bankingPriorityMultilingual;

  /// Priority chip
  ///
  /// In en, this message translates to:
  /// **'Low Fees'**
  String get bankingPriorityLowFee;

  /// Priority chip
  ///
  /// In en, this message translates to:
  /// **'ATM Network'**
  String get bankingPriorityAtm;

  /// Priority chip
  ///
  /// In en, this message translates to:
  /// **'Online Banking'**
  String get bankingPriorityOnline;

  /// Get recommendations button
  ///
  /// In en, this message translates to:
  /// **'Get Recommendations'**
  String get bankingGetRecommendations;

  /// Recommend screen hint
  ///
  /// In en, this message translates to:
  /// **'Select your priorities and tap Get Recommendations'**
  String get bankingRecommendHint;

  /// No recommendations message
  ///
  /// In en, this message translates to:
  /// **'No recommendations found'**
  String get bankingNoRecommendations;

  /// View guide button
  ///
  /// In en, this message translates to:
  /// **'View Guide'**
  String get bankingViewGuide;

  /// Guide screen title
  ///
  /// In en, this message translates to:
  /// **'Account Opening Guide'**
  String get bankingGuideTitle;

  /// Required documents section
  ///
  /// In en, this message translates to:
  /// **'Required Documents'**
  String get bankingRequiredDocs;

  /// Conversation templates section
  ///
  /// In en, this message translates to:
  /// **'Useful Phrases at the Bank'**
  String get bankingConversationTemplates;

  /// Troubleshooting section
  ///
  /// In en, this message translates to:
  /// **'Troubleshooting Tips'**
  String get bankingTroubleshooting;

  /// Source citation label
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get bankingSource;

  /// Visa list screen title
  ///
  /// In en, this message translates to:
  /// **'Visa Navigator'**
  String get visaTitle;

  /// Empty visa list message
  ///
  /// In en, this message translates to:
  /// **'No procedures found'**
  String get visaEmpty;

  /// All filter chip
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get visaFilterAll;

  /// Visa detail screen title
  ///
  /// In en, this message translates to:
  /// **'Procedure Details'**
  String get visaDetailTitle;

  /// Steps section title
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get visaSteps;

  /// Required documents section
  ///
  /// In en, this message translates to:
  /// **'Required Documents'**
  String get visaRequiredDocuments;

  /// Fees section title
  ///
  /// In en, this message translates to:
  /// **'Fees'**
  String get visaFees;

  /// Processing time section
  ///
  /// In en, this message translates to:
  /// **'Processing Time'**
  String get visaProcessingTime;

  /// Visa disclaimer text
  ///
  /// In en, this message translates to:
  /// **'IMPORTANT: This is general information about visa procedures and does not constitute immigration advice. Immigration laws and procedures may change. Always consult the Immigration Services Agency or a qualified immigration lawyer (行政書士) for your specific situation.'**
  String get visaDisclaimer;

  /// Tracker screen title
  ///
  /// In en, this message translates to:
  /// **'Admin Tracker'**
  String get trackerTitle;

  /// Empty tracker message
  ///
  /// In en, this message translates to:
  /// **'No procedures tracked'**
  String get trackerEmpty;

  /// Empty tracker hint
  ///
  /// In en, this message translates to:
  /// **'Tap + to add procedures to track'**
  String get trackerEmptyHint;

  /// Add procedure button
  ///
  /// In en, this message translates to:
  /// **'Add Procedure'**
  String get trackerAddProcedure;

  /// Not started status
  ///
  /// In en, this message translates to:
  /// **'Not Started'**
  String get trackerStatusNotStarted;

  /// In progress status
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get trackerStatusInProgress;

  /// Completed status
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get trackerStatusCompleted;

  /// Due date label
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get trackerDueDate;

  /// Free tier limit info
  ///
  /// In en, this message translates to:
  /// **'Free plan: up to 3 procedures. Upgrade for unlimited.'**
  String get trackerFreeLimitInfo;

  /// Tracker detail screen title
  ///
  /// In en, this message translates to:
  /// **'Procedure Details'**
  String get trackerDetailTitle;

  /// Current status label
  ///
  /// In en, this message translates to:
  /// **'Current Status'**
  String get trackerCurrentStatus;

  /// Notes label
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get trackerNotes;

  /// Change status section title
  ///
  /// In en, this message translates to:
  /// **'Change Status'**
  String get trackerChangeStatus;

  /// Mark in progress button
  ///
  /// In en, this message translates to:
  /// **'Mark as In Progress'**
  String get trackerMarkInProgress;

  /// Mark completed button
  ///
  /// In en, this message translates to:
  /// **'Mark as Completed'**
  String get trackerMarkCompleted;

  /// Mark incomplete button
  ///
  /// In en, this message translates to:
  /// **'Mark as Incomplete'**
  String get trackerMarkIncomplete;

  /// Status updated snackbar
  ///
  /// In en, this message translates to:
  /// **'Status updated'**
  String get trackerStatusUpdated;

  /// Delete procedure dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Procedure'**
  String get trackerDeleteTitle;

  /// Delete procedure confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this procedure from your tracker?'**
  String get trackerDeleteConfirm;

  /// Procedure added snackbar
  ///
  /// In en, this message translates to:
  /// **'Procedure added to tracker'**
  String get trackerProcedureAdded;

  /// Tracker limit reached message
  ///
  /// In en, this message translates to:
  /// **'Free plan limit reached (3 procedures). Upgrade to Premium for unlimited.'**
  String get trackerLimitReached;

  /// Already tracking message
  ///
  /// In en, this message translates to:
  /// **'You are already tracking this procedure'**
  String get trackerAlreadyTracking;

  /// Essential procedures section
  ///
  /// In en, this message translates to:
  /// **'Essential (After Arrival)'**
  String get trackerEssentialProcedures;

  /// Other procedures section
  ///
  /// In en, this message translates to:
  /// **'Other Procedures'**
  String get trackerOtherProcedures;

  /// No templates message
  ///
  /// In en, this message translates to:
  /// **'No procedure templates available'**
  String get trackerNoTemplates;

  /// Scanner screen title
  ///
  /// In en, this message translates to:
  /// **'Document Scanner'**
  String get scannerTitle;

  /// Scanner description
  ///
  /// In en, this message translates to:
  /// **'Scan Japanese documents to get instant translations and explanations'**
  String get scannerDescription;

  /// Camera scan button
  ///
  /// In en, this message translates to:
  /// **'Scan from Camera'**
  String get scannerFromCamera;

  /// Gallery scan button
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get scannerFromGallery;

  /// History button
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get scannerHistory;

  /// History screen title
  ///
  /// In en, this message translates to:
  /// **'Scan History'**
  String get scannerHistoryTitle;

  /// Empty history message
  ///
  /// In en, this message translates to:
  /// **'No scans yet'**
  String get scannerHistoryEmpty;

  /// Unknown document type
  ///
  /// In en, this message translates to:
  /// **'Unknown Document'**
  String get scannerUnknownType;

  /// Result screen title
  ///
  /// In en, this message translates to:
  /// **'Scan Result'**
  String get scannerResultTitle;

  /// Original OCR text section
  ///
  /// In en, this message translates to:
  /// **'Original Text (Japanese)'**
  String get scannerOriginalText;

  /// Translation section
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get scannerTranslation;

  /// Explanation section
  ///
  /// In en, this message translates to:
  /// **'What This Means'**
  String get scannerExplanation;

  /// Processing status
  ///
  /// In en, this message translates to:
  /// **'Processing your document...'**
  String get scannerProcessing;

  /// Refresh button
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get scannerRefresh;

  /// Scan failed message
  ///
  /// In en, this message translates to:
  /// **'Scan failed. Please try again.'**
  String get scannerFailed;

  /// Free tier limit info
  ///
  /// In en, this message translates to:
  /// **'Free plan: 3 scans/month. Upgrade for more.'**
  String get scannerFreeLimitInfo;

  /// Scanner limit reached message
  ///
  /// In en, this message translates to:
  /// **'Monthly scan limit reached. Upgrade to Premium for more scans.'**
  String get scannerLimitReached;

  /// Medical screen title
  ///
  /// In en, this message translates to:
  /// **'Medical Guide'**
  String get medicalTitle;

  /// Emergency tab
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get medicalTabEmergency;

  /// Phrases tab
  ///
  /// In en, this message translates to:
  /// **'Phrases'**
  String get medicalTabPhrases;

  /// Emergency number label
  ///
  /// In en, this message translates to:
  /// **'Emergency Number'**
  String get medicalEmergencyNumber;

  /// How to call section
  ///
  /// In en, this message translates to:
  /// **'How to Call'**
  String get medicalHowToCall;

  /// What to prepare section
  ///
  /// In en, this message translates to:
  /// **'What to Prepare'**
  String get medicalWhatToPrepare;

  /// Useful phrases section
  ///
  /// In en, this message translates to:
  /// **'Useful Phrases'**
  String get medicalUsefulPhrases;

  /// All categories filter
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get medicalCategoryAll;

  /// Emergency category
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get medicalCategoryEmergency;

  /// Symptoms category
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get medicalCategorySymptom;

  /// Insurance category
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get medicalCategoryInsurance;

  /// General category
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get medicalCategoryGeneral;

  /// No phrases message
  ///
  /// In en, this message translates to:
  /// **'No phrases found'**
  String get medicalNoPhrases;

  /// Medical disclaimer text
  ///
  /// In en, this message translates to:
  /// **'This guide provides general health information and is not a substitute for professional medical advice. In an emergency, call 119 immediately.'**
  String get medicalDisclaimer;

  /// Navigate hub banking title
  ///
  /// In en, this message translates to:
  /// **'Banking'**
  String get navigateBanking;

  /// Navigate hub banking description
  ///
  /// In en, this message translates to:
  /// **'Find foreigner-friendly banks'**
  String get navigateBankingDesc;

  /// Navigate hub visa title
  ///
  /// In en, this message translates to:
  /// **'Visa'**
  String get navigateVisa;

  /// Navigate hub visa description
  ///
  /// In en, this message translates to:
  /// **'Visa procedures & documents'**
  String get navigateVisaDesc;

  /// Navigate hub scanner title
  ///
  /// In en, this message translates to:
  /// **'Scanner'**
  String get navigateScanner;

  /// Navigate hub scanner description
  ///
  /// In en, this message translates to:
  /// **'Translate Japanese documents'**
  String get navigateScannerDesc;

  /// Navigate hub medical title
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get navigateMedical;

  /// Navigate hub medical description
  ///
  /// In en, this message translates to:
  /// **'Emergency guide & phrases'**
  String get navigateMedicalDesc;

  /// Upgrade to premium button
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get upgradeToPremium;

  /// Community screen title
  ///
  /// In en, this message translates to:
  /// **'Community Q&A'**
  String get communityTitle;

  /// Empty community list message
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get communityEmpty;

  /// New post button
  ///
  /// In en, this message translates to:
  /// **'New Post'**
  String get communityNewPost;

  /// Post detail screen title
  ///
  /// In en, this message translates to:
  /// **'Post Detail'**
  String get communityDetailTitle;

  /// Answered badge
  ///
  /// In en, this message translates to:
  /// **'Answered'**
  String get communityAnswered;

  /// Best answer badge
  ///
  /// In en, this message translates to:
  /// **'Best Answer'**
  String get communityBestAnswer;

  /// All category filter
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get communityFilterAll;

  /// Sort by newest
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get communitySortNewest;

  /// Sort by popular
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get communitySortPopular;

  /// Visa category
  ///
  /// In en, this message translates to:
  /// **'Visa'**
  String get communityCategoryVisa;

  /// Housing category
  ///
  /// In en, this message translates to:
  /// **'Housing'**
  String get communityCategoryHousing;

  /// Banking category
  ///
  /// In en, this message translates to:
  /// **'Banking'**
  String get communityCategoryBanking;

  /// Work category
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get communityCategoryWork;

  /// Daily life category
  ///
  /// In en, this message translates to:
  /// **'Daily Life'**
  String get communityCategoryDailyLife;

  /// Medical category
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get communityCategoryMedical;

  /// Education category
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get communityCategoryEducation;

  /// Tax category
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get communityCategoryTax;

  /// Other category
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get communityCategoryOther;

  /// Reply count header
  ///
  /// In en, this message translates to:
  /// **'{count} Replies'**
  String communityReplies(int count);

  /// No replies message
  ///
  /// In en, this message translates to:
  /// **'No replies yet. Be the first to answer!'**
  String get communityNoReplies;

  /// Reply input hint
  ///
  /// In en, this message translates to:
  /// **'Write a reply...'**
  String get communityReplyHint;

  /// Free user reply restriction
  ///
  /// In en, this message translates to:
  /// **'Posting and replying requires a Premium subscription.'**
  String get communityReplyPremiumOnly;

  /// Vote count label
  ///
  /// In en, this message translates to:
  /// **'{count} votes'**
  String communityVoteCount(int count);

  /// Pending moderation badge
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get communityModerationPending;

  /// Flagged moderation badge
  ///
  /// In en, this message translates to:
  /// **'Flagged for review'**
  String get communityModerationFlagged;

  /// Moderation notice on create
  ///
  /// In en, this message translates to:
  /// **'Your post will be reviewed by our AI moderation system before it becomes visible to others.'**
  String get communityModerationNotice;

  /// Channel selector label
  ///
  /// In en, this message translates to:
  /// **'Language Channel'**
  String get communityChannelLabel;

  /// Category selector label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get communityCategoryLabel;

  /// Post title field label
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get communityTitleLabel;

  /// Post title hint
  ///
  /// In en, this message translates to:
  /// **'What\'s your question?'**
  String get communityTitleHint;

  /// Title min length validation
  ///
  /// In en, this message translates to:
  /// **'Title must be at least 5 characters'**
  String get communityTitleMinLength;

  /// Post content field label
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get communityContentLabel;

  /// Post content hint
  ///
  /// In en, this message translates to:
  /// **'Describe your question or situation in detail...'**
  String get communityContentHint;

  /// Content min length validation
  ///
  /// In en, this message translates to:
  /// **'Content must be at least 10 characters'**
  String get communityContentMinLength;

  /// Submit post button
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get communitySubmit;

  /// Time ago in days
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String communityTimeAgoDays(int days);

  /// Time ago in hours
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String communityTimeAgoHours(int hours);

  /// Time ago in minutes
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String communityTimeAgoMinutes(int minutes);

  /// Navigate hub community title
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get navigateCommunity;

  /// Navigate hub community description
  ///
  /// In en, this message translates to:
  /// **'Q&A with other foreigners'**
  String get navigateCommunityDesc;

  /// Subscription screen title
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscriptionTitle;

  /// Plans section title
  ///
  /// In en, this message translates to:
  /// **'Choose Your Plan'**
  String get subscriptionPlansTitle;

  /// Plans section subtitle
  ///
  /// In en, this message translates to:
  /// **'Unlock the full potential of Gaijin Life Navi'**
  String get subscriptionPlansSubtitle;

  /// Current plan label
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get subscriptionCurrentPlan;

  /// Current plan badge on card
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get subscriptionCurrentPlanBadge;

  /// Free tier name
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get subscriptionTierFree;

  /// Premium tier name
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get subscriptionTierPremium;

  /// Premium+ tier name
  ///
  /// In en, this message translates to:
  /// **'Premium+'**
  String get subscriptionTierPremiumPlus;

  /// Free plan price
  ///
  /// In en, this message translates to:
  /// **'¥0'**
  String get subscriptionFreePrice;

  /// Price per month
  ///
  /// In en, this message translates to:
  /// **'¥{price}/month'**
  String subscriptionPricePerMonth(int price);

  /// Checkout button
  ///
  /// In en, this message translates to:
  /// **'Subscribe Now'**
  String get subscriptionCheckout;

  /// Recommended badge
  ///
  /// In en, this message translates to:
  /// **'RECOMMENDED'**
  String get subscriptionRecommended;

  /// Cancelling status
  ///
  /// In en, this message translates to:
  /// **'Cancelling...'**
  String get subscriptionCancelling;

  /// Cancellation date message
  ///
  /// In en, this message translates to:
  /// **'Your plan will end on {date}'**
  String subscriptionCancellingAt(String date);

  /// Free plan chat feature
  ///
  /// In en, this message translates to:
  /// **'5 AI chats per day'**
  String get subscriptionFeatureFreeChat;

  /// Free plan scan feature
  ///
  /// In en, this message translates to:
  /// **'3 document scans per month'**
  String get subscriptionFeatureFreeScans;

  /// Free plan tracker feature
  ///
  /// In en, this message translates to:
  /// **'Track up to 3 procedures'**
  String get subscriptionFeatureFreeTracker;

  /// Free plan community feature
  ///
  /// In en, this message translates to:
  /// **'Read community posts'**
  String get subscriptionFeatureFreeCommunityRead;

  /// Premium community feature
  ///
  /// In en, this message translates to:
  /// **'Post & reply in community'**
  String get subscriptionFeatureCommunityPost;

  /// Premium chat feature
  ///
  /// In en, this message translates to:
  /// **'Unlimited AI chats'**
  String get subscriptionFeatureUnlimitedChat;
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
