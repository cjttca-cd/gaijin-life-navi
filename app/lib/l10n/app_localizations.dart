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

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Gaijin Life Navi'**
  String get appTitle;

  /// No description provided for @langTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get langTitle;

  /// No description provided for @langContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get langContinue;

  /// No description provided for @langEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEn;

  /// No description provided for @langZh.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get langZh;

  /// No description provided for @langVi.
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get langVi;

  /// No description provided for @langKo.
  ///
  /// In en, this message translates to:
  /// **'한국어'**
  String get langKo;

  /// No description provided for @langPt.
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get langPt;

  /// No description provided for @loginWelcome.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get loginWelcome;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get loginSubtitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'your@email.com'**
  String get loginEmailHint;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginPasswordHint;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginButton;

  /// No description provided for @loginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get loginNoAccount;

  /// No description provided for @loginSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get loginSignUp;

  /// No description provided for @loginErrorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get loginErrorInvalidEmail;

  /// No description provided for @loginErrorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password. Please try again.'**
  String get loginErrorInvalidCredentials;

  /// No description provided for @loginErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect. Please check your internet connection.'**
  String get loginErrorNetwork;

  /// No description provided for @loginErrorTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get loginErrorTooManyAttempts;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your journey in Japan'**
  String get registerSubtitle;

  /// No description provided for @registerEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get registerEmailLabel;

  /// No description provided for @registerEmailHint.
  ///
  /// In en, this message translates to:
  /// **'your@email.com'**
  String get registerEmailHint;

  /// No description provided for @registerPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get registerPasswordLabel;

  /// No description provided for @registerPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Create a password'**
  String get registerPasswordHint;

  /// No description provided for @registerPasswordHelper.
  ///
  /// In en, this message translates to:
  /// **'8 or more characters'**
  String get registerPasswordHelper;

  /// No description provided for @registerConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get registerConfirmLabel;

  /// No description provided for @registerConfirmHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get registerConfirmHint;

  /// No description provided for @registerTermsAgree.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get registerTermsAgree;

  /// No description provided for @registerTermsLink.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get registerTermsLink;

  /// No description provided for @registerPrivacyAnd.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get registerPrivacyAnd;

  /// No description provided for @registerPrivacyLink.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get registerPrivacyLink;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerButton;

  /// No description provided for @registerHasAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get registerHasAccount;

  /// No description provided for @registerSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get registerSignIn;

  /// No description provided for @registerErrorEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get registerErrorEmailInvalid;

  /// No description provided for @registerErrorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered. Try signing in instead.'**
  String get registerErrorEmailInUse;

  /// No description provided for @registerErrorPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters.'**
  String get registerErrorPasswordShort;

  /// No description provided for @registerErrorPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match.'**
  String get registerErrorPasswordMismatch;

  /// No description provided for @registerErrorTermsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the Terms of Service.'**
  String get registerErrorTermsRequired;

  /// No description provided for @resetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get resetTitle;

  /// No description provided for @resetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a reset link.'**
  String get resetSubtitle;

  /// No description provided for @resetEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get resetEmailLabel;

  /// No description provided for @resetEmailHint.
  ///
  /// In en, this message translates to:
  /// **'your@email.com'**
  String get resetEmailHint;

  /// No description provided for @resetButton.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get resetButton;

  /// No description provided for @resetBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get resetBackToLogin;

  /// No description provided for @resetSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get resetSuccessTitle;

  /// No description provided for @resetSuccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a reset link to {email}'**
  String resetSuccessSubtitle(String email);

  /// No description provided for @resetResend.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive it? Resend'**
  String get resetResend;

  /// No description provided for @resetErrorEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get resetErrorEmailInvalid;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingStepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String onboardingStepOf(int current, int total);

  /// No description provided for @onboardingS1Title.
  ///
  /// In en, this message translates to:
  /// **'What\'s your nationality?'**
  String get onboardingS1Title;

  /// No description provided for @onboardingS1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'This helps us give you relevant information.'**
  String get onboardingS1Subtitle;

  /// No description provided for @onboardingS2Title.
  ///
  /// In en, this message translates to:
  /// **'What\'s your residence status?'**
  String get onboardingS2Title;

  /// No description provided for @onboardingS2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'We can tailor visa-related information for you.'**
  String get onboardingS2Subtitle;

  /// No description provided for @onboardingS3Title.
  ///
  /// In en, this message translates to:
  /// **'Where do you live in Japan?'**
  String get onboardingS3Title;

  /// No description provided for @onboardingS3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'For location-specific guides.'**
  String get onboardingS3Subtitle;

  /// No description provided for @onboardingS4Title.
  ///
  /// In en, this message translates to:
  /// **'When did you arrive in Japan?'**
  String get onboardingS4Title;

  /// No description provided for @onboardingS4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll suggest time-sensitive tasks you may need to complete.'**
  String get onboardingS4Subtitle;

  /// No description provided for @onboardingS4Placeholder.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get onboardingS4Placeholder;

  /// No description provided for @onboardingS4NotYet.
  ///
  /// In en, this message translates to:
  /// **'I haven\'t arrived yet'**
  String get onboardingS4NotYet;

  /// No description provided for @onboardingChangeDate.
  ///
  /// In en, this message translates to:
  /// **'Change Date'**
  String get onboardingChangeDate;

  /// No description provided for @onboardingErrorSave.
  ///
  /// In en, this message translates to:
  /// **'Unable to save your information. Please try again.'**
  String get onboardingErrorSave;

  /// No description provided for @statusEngineer.
  ///
  /// In en, this message translates to:
  /// **'Engineer / Specialist in Humanities'**
  String get statusEngineer;

  /// No description provided for @statusStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get statusStudent;

  /// No description provided for @statusDependent.
  ///
  /// In en, this message translates to:
  /// **'Dependent'**
  String get statusDependent;

  /// No description provided for @statusPermanent.
  ///
  /// In en, this message translates to:
  /// **'Permanent Resident'**
  String get statusPermanent;

  /// No description provided for @statusSpouse.
  ///
  /// In en, this message translates to:
  /// **'Spouse of Japanese National'**
  String get statusSpouse;

  /// No description provided for @statusWorkingHoliday.
  ///
  /// In en, this message translates to:
  /// **'Working Holiday'**
  String get statusWorkingHoliday;

  /// No description provided for @statusSpecifiedSkilled.
  ///
  /// In en, this message translates to:
  /// **'Specified Skilled Worker'**
  String get statusSpecifiedSkilled;

  /// No description provided for @statusOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get statusOther;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabChat.
  ///
  /// In en, this message translates to:
  /// **'AI Guide'**
  String get tabChat;

  /// No description provided for @tabGuide.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get tabGuide;

  /// No description provided for @tabSOS.
  ///
  /// In en, this message translates to:
  /// **'SOS'**
  String get tabSOS;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @homeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name} 👋'**
  String homeGreetingMorning(String name);

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon, {name} 👋'**
  String homeGreetingAfternoon(String name);

  /// No description provided for @homeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening, {name} 👋'**
  String homeGreetingEvening(String name);

  /// No description provided for @homeGreetingDefault.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name} 👋'**
  String homeGreetingDefault(String name);

  /// No description provided for @homeGreetingNoName.
  ///
  /// In en, this message translates to:
  /// **'Welcome! 👋'**
  String get homeGreetingNoName;

  /// No description provided for @homeUsageFree.
  ///
  /// In en, this message translates to:
  /// **'Free • {remaining}/{limit} chats remaining'**
  String homeUsageFree(int remaining, int limit);

  /// No description provided for @homeSectionQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get homeSectionQuickActions;

  /// No description provided for @homeSectionExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get homeSectionExplore;

  /// No description provided for @homeTrackerSummary.
  ///
  /// In en, this message translates to:
  /// **'My To-Dos'**
  String get homeTrackerSummary;

  /// No description provided for @homePopularGuides.
  ///
  /// In en, this message translates to:
  /// **'Popular Guides'**
  String get homePopularGuides;

  /// No description provided for @homeTrackerNoItems.
  ///
  /// In en, this message translates to:
  /// **'No to-dos yet. Tap to add one.'**
  String get homeTrackerNoItems;

  /// No description provided for @homeQaChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Talk to AI Guide'**
  String get homeQaChatTitle;

  /// No description provided for @homeQaChatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask anything about life in Japan'**
  String get homeQaChatSubtitle;

  /// No description provided for @homeQaBankingTitle.
  ///
  /// In en, this message translates to:
  /// **'Banking'**
  String get homeQaBankingTitle;

  /// No description provided for @homeQaBankingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Account opening, transfers & more'**
  String get homeQaBankingSubtitle;

  /// No description provided for @homeQaVisaTitle.
  ///
  /// In en, this message translates to:
  /// **'Visa'**
  String get homeQaVisaTitle;

  /// No description provided for @homeQaVisaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Immigration guides & procedures'**
  String get homeQaVisaSubtitle;

  /// No description provided for @homeQaMedicalTitle.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get homeQaMedicalTitle;

  /// No description provided for @homeQaMedicalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Health guides & emergency info'**
  String get homeQaMedicalSubtitle;

  /// No description provided for @homeExploreGuides.
  ///
  /// In en, this message translates to:
  /// **'Browse all guides'**
  String get homeExploreGuides;

  /// No description provided for @homeExploreEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency contacts'**
  String get homeExploreEmergency;

  /// No description provided for @homeUpgradeTitle.
  ///
  /// In en, this message translates to:
  /// **'Get more from your AI assistant'**
  String get homeUpgradeTitle;

  /// No description provided for @homeUpgradeCta.
  ///
  /// In en, this message translates to:
  /// **'Upgrade now'**
  String get homeUpgradeCta;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Guide'**
  String get chatTitle;

  /// No description provided for @chatInputPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get chatInputPlaceholder;

  /// No description provided for @chatEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask me anything!'**
  String get chatEmptyTitle;

  /// No description provided for @chatEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'I can help you with banking, visa, medical questions and more about life in Japan.'**
  String get chatEmptySubtitle;

  /// No description provided for @chatSuggestBank.
  ///
  /// In en, this message translates to:
  /// **'How do I open a bank account?'**
  String get chatSuggestBank;

  /// No description provided for @chatSuggestVisa.
  ///
  /// In en, this message translates to:
  /// **'How to renew my visa?'**
  String get chatSuggestVisa;

  /// No description provided for @chatSuggestMedical.
  ///
  /// In en, this message translates to:
  /// **'How to see a doctor?'**
  String get chatSuggestMedical;

  /// No description provided for @chatSuggestGeneral.
  ///
  /// In en, this message translates to:
  /// **'What do I need after arriving in Japan?'**
  String get chatSuggestGeneral;

  /// No description provided for @chatSourcesHeader.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get chatSourcesHeader;

  /// No description provided for @chatDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This is general information only. It does not constitute legal advice. Please verify with relevant authorities.'**
  String get chatDisclaimer;

  /// No description provided for @chatLimitRemaining.
  ///
  /// In en, this message translates to:
  /// **'{remaining}/{limit} free chats remaining.'**
  String chatLimitRemaining(int remaining, int limit);

  /// No description provided for @chatLimitUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get chatLimitUpgrade;

  /// No description provided for @chatLimitExhausted.
  ///
  /// In en, this message translates to:
  /// **'You\'ve used all your free chats for today. Upgrade to keep chatting!'**
  String get chatLimitExhausted;

  /// No description provided for @chatErrorSend.
  ///
  /// In en, this message translates to:
  /// **'Unable to send your message. Please try again.'**
  String get chatErrorSend;

  /// No description provided for @chatErrorRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get chatErrorRetry;

  /// No description provided for @chatDateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get chatDateToday;

  /// No description provided for @chatDateYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get chatDateYesterday;

  /// No description provided for @chatNewSession.
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get chatNewSession;

  /// No description provided for @chatUntitledSession.
  ///
  /// In en, this message translates to:
  /// **'New Conversation'**
  String get chatUntitledSession;

  /// No description provided for @chatDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Chat'**
  String get chatDeleteTitle;

  /// No description provided for @chatDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this chat?'**
  String get chatDeleteConfirm;

  /// No description provided for @chatDeleteCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get chatDeleteCancel;

  /// No description provided for @chatDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get chatDeleteAction;

  /// No description provided for @chatRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get chatRetry;

  /// No description provided for @countryCN.
  ///
  /// In en, this message translates to:
  /// **'China'**
  String get countryCN;

  /// No description provided for @countryVN.
  ///
  /// In en, this message translates to:
  /// **'Vietnam'**
  String get countryVN;

  /// No description provided for @countryKR.
  ///
  /// In en, this message translates to:
  /// **'South Korea'**
  String get countryKR;

  /// No description provided for @countryPH.
  ///
  /// In en, this message translates to:
  /// **'Philippines'**
  String get countryPH;

  /// No description provided for @countryBR.
  ///
  /// In en, this message translates to:
  /// **'Brazil'**
  String get countryBR;

  /// No description provided for @countryNP.
  ///
  /// In en, this message translates to:
  /// **'Nepal'**
  String get countryNP;

  /// No description provided for @countryID.
  ///
  /// In en, this message translates to:
  /// **'Indonesia'**
  String get countryID;

  /// No description provided for @countryUS.
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get countryUS;

  /// No description provided for @countryTH.
  ///
  /// In en, this message translates to:
  /// **'Thailand'**
  String get countryTH;

  /// No description provided for @countryIN.
  ///
  /// In en, this message translates to:
  /// **'India'**
  String get countryIN;

  /// No description provided for @countryMM.
  ///
  /// In en, this message translates to:
  /// **'Myanmar'**
  String get countryMM;

  /// No description provided for @countryTW.
  ///
  /// In en, this message translates to:
  /// **'Taiwan'**
  String get countryTW;

  /// No description provided for @countryPE.
  ///
  /// In en, this message translates to:
  /// **'Peru'**
  String get countryPE;

  /// No description provided for @countryGB.
  ///
  /// In en, this message translates to:
  /// **'United Kingdom'**
  String get countryGB;

  /// No description provided for @countryPK.
  ///
  /// In en, this message translates to:
  /// **'Pakistan'**
  String get countryPK;

  /// No description provided for @countryBD.
  ///
  /// In en, this message translates to:
  /// **'Bangladesh'**
  String get countryBD;

  /// No description provided for @countryLK.
  ///
  /// In en, this message translates to:
  /// **'Sri Lanka'**
  String get countryLK;

  /// No description provided for @countryFR.
  ///
  /// In en, this message translates to:
  /// **'France'**
  String get countryFR;

  /// No description provided for @countryDE.
  ///
  /// In en, this message translates to:
  /// **'Germany'**
  String get countryDE;

  /// No description provided for @countryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get countryOther;

  /// No description provided for @regionTokyo.
  ///
  /// In en, this message translates to:
  /// **'Tokyo'**
  String get regionTokyo;

  /// No description provided for @regionOsaka.
  ///
  /// In en, this message translates to:
  /// **'Osaka'**
  String get regionOsaka;

  /// No description provided for @regionNagoya.
  ///
  /// In en, this message translates to:
  /// **'Nagoya'**
  String get regionNagoya;

  /// No description provided for @regionYokohama.
  ///
  /// In en, this message translates to:
  /// **'Yokohama'**
  String get regionYokohama;

  /// No description provided for @regionFukuoka.
  ///
  /// In en, this message translates to:
  /// **'Fukuoka'**
  String get regionFukuoka;

  /// No description provided for @regionSapporo.
  ///
  /// In en, this message translates to:
  /// **'Sapporo'**
  String get regionSapporo;

  /// No description provided for @regionKobe.
  ///
  /// In en, this message translates to:
  /// **'Kobe'**
  String get regionKobe;

  /// No description provided for @regionKyoto.
  ///
  /// In en, this message translates to:
  /// **'Kyoto'**
  String get regionKyoto;

  /// No description provided for @regionSendai.
  ///
  /// In en, this message translates to:
  /// **'Sendai'**
  String get regionSendai;

  /// No description provided for @regionHiroshima.
  ///
  /// In en, this message translates to:
  /// **'Hiroshima'**
  String get regionHiroshima;

  /// No description provided for @regionOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get regionOther;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get networkError;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @bankingTitle.
  ///
  /// In en, this message translates to:
  /// **'Banking Navigator'**
  String get bankingTitle;

  /// No description provided for @bankingFriendlyScore.
  ///
  /// In en, this message translates to:
  /// **'Foreigner-Friendly Score'**
  String get bankingFriendlyScore;

  /// No description provided for @bankingEmpty.
  ///
  /// In en, this message translates to:
  /// **'No banks found'**
  String get bankingEmpty;

  /// No description provided for @bankingRecommendButton.
  ///
  /// In en, this message translates to:
  /// **'Recommend'**
  String get bankingRecommendButton;

  /// No description provided for @bankingRecommendTitle.
  ///
  /// In en, this message translates to:
  /// **'Bank Recommendations'**
  String get bankingRecommendTitle;

  /// No description provided for @bankingSelectPriorities.
  ///
  /// In en, this message translates to:
  /// **'Select your priorities'**
  String get bankingSelectPriorities;

  /// No description provided for @bankingPriorityMultilingual.
  ///
  /// In en, this message translates to:
  /// **'Multilingual Support'**
  String get bankingPriorityMultilingual;

  /// No description provided for @bankingPriorityLowFee.
  ///
  /// In en, this message translates to:
  /// **'Low Fees'**
  String get bankingPriorityLowFee;

  /// No description provided for @bankingPriorityAtm.
  ///
  /// In en, this message translates to:
  /// **'ATM Network'**
  String get bankingPriorityAtm;

  /// No description provided for @bankingPriorityOnline.
  ///
  /// In en, this message translates to:
  /// **'Online Banking'**
  String get bankingPriorityOnline;

  /// No description provided for @bankingGetRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Get Recommendations'**
  String get bankingGetRecommendations;

  /// No description provided for @bankingRecommendHint.
  ///
  /// In en, this message translates to:
  /// **'Select your priorities and tap Get Recommendations'**
  String get bankingRecommendHint;

  /// No description provided for @bankingNoRecommendations.
  ///
  /// In en, this message translates to:
  /// **'No recommendations found'**
  String get bankingNoRecommendations;

  /// No description provided for @bankingViewGuide.
  ///
  /// In en, this message translates to:
  /// **'View Guide'**
  String get bankingViewGuide;

  /// No description provided for @bankingGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Opening Guide'**
  String get bankingGuideTitle;

  /// No description provided for @bankingRequiredDocs.
  ///
  /// In en, this message translates to:
  /// **'Required Documents'**
  String get bankingRequiredDocs;

  /// No description provided for @bankingConversationTemplates.
  ///
  /// In en, this message translates to:
  /// **'Useful Phrases at the Bank'**
  String get bankingConversationTemplates;

  /// No description provided for @bankingTroubleshooting.
  ///
  /// In en, this message translates to:
  /// **'Troubleshooting Tips'**
  String get bankingTroubleshooting;

  /// No description provided for @bankingSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get bankingSource;

  /// No description provided for @visaTitle.
  ///
  /// In en, this message translates to:
  /// **'Visa Navigator'**
  String get visaTitle;

  /// No description provided for @visaEmpty.
  ///
  /// In en, this message translates to:
  /// **'No procedures found'**
  String get visaEmpty;

  /// No description provided for @visaFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get visaFilterAll;

  /// No description provided for @visaDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Procedure Details'**
  String get visaDetailTitle;

  /// No description provided for @visaSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get visaSteps;

  /// No description provided for @visaRequiredDocuments.
  ///
  /// In en, this message translates to:
  /// **'Required Documents'**
  String get visaRequiredDocuments;

  /// No description provided for @visaFees.
  ///
  /// In en, this message translates to:
  /// **'Fees'**
  String get visaFees;

  /// No description provided for @visaProcessingTime.
  ///
  /// In en, this message translates to:
  /// **'Processing Time'**
  String get visaProcessingTime;

  /// No description provided for @visaDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'IMPORTANT: This is general information about visa procedures and does not constitute immigration advice.'**
  String get visaDisclaimer;

  /// No description provided for @trackerTitle.
  ///
  /// In en, this message translates to:
  /// **'To-Do'**
  String get trackerTitle;

  /// No description provided for @trackerAddItem.
  ///
  /// In en, this message translates to:
  /// **'New To-Do'**
  String get trackerAddItem;

  /// No description provided for @trackerNoItems.
  ///
  /// In en, this message translates to:
  /// **'No to-dos yet'**
  String get trackerNoItems;

  /// No description provided for @trackerNoItemsHint.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first to-do'**
  String get trackerNoItemsHint;

  /// No description provided for @trackerAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get trackerAddTitle;

  /// No description provided for @trackerAddMemo.
  ///
  /// In en, this message translates to:
  /// **'Memo (optional)'**
  String get trackerAddMemo;

  /// No description provided for @trackerAddDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date (optional)'**
  String get trackerAddDueDate;

  /// No description provided for @trackerDueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get trackerDueToday;

  /// No description provided for @trackerOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get trackerOverdue;

  /// No description provided for @trackerViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all →'**
  String get trackerViewAll;

  /// No description provided for @trackerDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete To-Do'**
  String get trackerDeleteTitle;

  /// No description provided for @trackerDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this to-do?'**
  String get trackerDeleteConfirm;

  /// No description provided for @trackerLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Free plan allows up to 3 to-dos. Upgrade for unlimited.'**
  String get trackerLimitReached;

  /// No description provided for @trackerAlreadyTracking.
  ///
  /// In en, this message translates to:
  /// **'This item is already in your to-do list'**
  String get trackerAlreadyTracking;

  /// No description provided for @scannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Document Scanner'**
  String get scannerTitle;

  /// No description provided for @scannerDescription.
  ///
  /// In en, this message translates to:
  /// **'Scan Japanese documents to get instant translations and explanations'**
  String get scannerDescription;

  /// No description provided for @scannerFromCamera.
  ///
  /// In en, this message translates to:
  /// **'Scan from Camera'**
  String get scannerFromCamera;

  /// No description provided for @scannerFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get scannerFromGallery;

  /// No description provided for @scannerHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get scannerHistory;

  /// No description provided for @scannerHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan History'**
  String get scannerHistoryTitle;

  /// No description provided for @scannerHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No scans yet'**
  String get scannerHistoryEmpty;

  /// No description provided for @scannerUnknownType.
  ///
  /// In en, this message translates to:
  /// **'Unknown Document'**
  String get scannerUnknownType;

  /// No description provided for @scannerResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Result'**
  String get scannerResultTitle;

  /// No description provided for @scannerOriginalText.
  ///
  /// In en, this message translates to:
  /// **'Original Text (Japanese)'**
  String get scannerOriginalText;

  /// No description provided for @scannerTranslation.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get scannerTranslation;

  /// No description provided for @scannerExplanation.
  ///
  /// In en, this message translates to:
  /// **'What This Means'**
  String get scannerExplanation;

  /// No description provided for @scannerProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing your document...'**
  String get scannerProcessing;

  /// No description provided for @scannerRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get scannerRefresh;

  /// No description provided for @scannerFailed.
  ///
  /// In en, this message translates to:
  /// **'Scan failed. Please try again.'**
  String get scannerFailed;

  /// No description provided for @scannerFreeLimitInfo.
  ///
  /// In en, this message translates to:
  /// **'Free plan: 3 scans/month. Upgrade for more.'**
  String get scannerFreeLimitInfo;

  /// No description provided for @scannerLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Monthly scan limit reached. Upgrade to Premium for more scans.'**
  String get scannerLimitReached;

  /// No description provided for @medicalTitle.
  ///
  /// In en, this message translates to:
  /// **'Medical Guide'**
  String get medicalTitle;

  /// No description provided for @medicalTabEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get medicalTabEmergency;

  /// No description provided for @medicalTabPhrases.
  ///
  /// In en, this message translates to:
  /// **'Phrases'**
  String get medicalTabPhrases;

  /// No description provided for @medicalEmergencyNumber.
  ///
  /// In en, this message translates to:
  /// **'Emergency Number'**
  String get medicalEmergencyNumber;

  /// No description provided for @medicalHowToCall.
  ///
  /// In en, this message translates to:
  /// **'How to Call'**
  String get medicalHowToCall;

  /// No description provided for @medicalWhatToPrepare.
  ///
  /// In en, this message translates to:
  /// **'What to Prepare'**
  String get medicalWhatToPrepare;

  /// No description provided for @medicalUsefulPhrases.
  ///
  /// In en, this message translates to:
  /// **'Useful Phrases'**
  String get medicalUsefulPhrases;

  /// No description provided for @medicalCategoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get medicalCategoryAll;

  /// No description provided for @medicalCategoryEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get medicalCategoryEmergency;

  /// No description provided for @medicalCategorySymptom.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get medicalCategorySymptom;

  /// No description provided for @medicalCategoryInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get medicalCategoryInsurance;

  /// No description provided for @medicalCategoryGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get medicalCategoryGeneral;

  /// No description provided for @medicalNoPhrases.
  ///
  /// In en, this message translates to:
  /// **'No phrases found'**
  String get medicalNoPhrases;

  /// No description provided for @medicalDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This guide provides general health information and is not a substitute for professional medical advice. In an emergency, call 119 immediately.'**
  String get medicalDisclaimer;

  /// No description provided for @navigateBanking.
  ///
  /// In en, this message translates to:
  /// **'Banking'**
  String get navigateBanking;

  /// No description provided for @navigateBankingDesc.
  ///
  /// In en, this message translates to:
  /// **'Find foreigner-friendly banks'**
  String get navigateBankingDesc;

  /// No description provided for @navigateVisa.
  ///
  /// In en, this message translates to:
  /// **'Visa'**
  String get navigateVisa;

  /// No description provided for @navigateVisaDesc.
  ///
  /// In en, this message translates to:
  /// **'Visa procedures & documents'**
  String get navigateVisaDesc;

  /// No description provided for @navigateScanner.
  ///
  /// In en, this message translates to:
  /// **'Scanner'**
  String get navigateScanner;

  /// No description provided for @navigateScannerDesc.
  ///
  /// In en, this message translates to:
  /// **'Translate Japanese documents'**
  String get navigateScannerDesc;

  /// No description provided for @navigateMedical.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get navigateMedical;

  /// No description provided for @navigateMedicalDesc.
  ///
  /// In en, this message translates to:
  /// **'Emergency guide & phrases'**
  String get navigateMedicalDesc;

  /// No description provided for @navigateCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get navigateCommunity;

  /// No description provided for @navigateCommunityDesc.
  ///
  /// In en, this message translates to:
  /// **'Q&A with other foreigners'**
  String get navigateCommunityDesc;

  /// No description provided for @upgradeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get upgradeToPremium;

  /// No description provided for @communityTitle.
  ///
  /// In en, this message translates to:
  /// **'Community Q&A'**
  String get communityTitle;

  /// No description provided for @communityEmpty.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get communityEmpty;

  /// No description provided for @communityNewPost.
  ///
  /// In en, this message translates to:
  /// **'New Post'**
  String get communityNewPost;

  /// No description provided for @communityDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Post Detail'**
  String get communityDetailTitle;

  /// No description provided for @communityAnswered.
  ///
  /// In en, this message translates to:
  /// **'Answered'**
  String get communityAnswered;

  /// No description provided for @communityBestAnswer.
  ///
  /// In en, this message translates to:
  /// **'Best Answer'**
  String get communityBestAnswer;

  /// No description provided for @communityFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get communityFilterAll;

  /// No description provided for @communitySortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get communitySortNewest;

  /// No description provided for @communitySortPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get communitySortPopular;

  /// No description provided for @communityCategoryVisa.
  ///
  /// In en, this message translates to:
  /// **'Visa'**
  String get communityCategoryVisa;

  /// No description provided for @communityCategoryHousing.
  ///
  /// In en, this message translates to:
  /// **'Housing'**
  String get communityCategoryHousing;

  /// No description provided for @communityCategoryBanking.
  ///
  /// In en, this message translates to:
  /// **'Banking'**
  String get communityCategoryBanking;

  /// No description provided for @communityCategoryWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get communityCategoryWork;

  /// No description provided for @communityCategoryDailyLife.
  ///
  /// In en, this message translates to:
  /// **'Daily Life'**
  String get communityCategoryDailyLife;

  /// No description provided for @communityCategoryMedical.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get communityCategoryMedical;

  /// No description provided for @communityCategoryEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get communityCategoryEducation;

  /// No description provided for @communityCategoryTax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get communityCategoryTax;

  /// No description provided for @communityCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get communityCategoryOther;

  /// No description provided for @communityReplies.
  ///
  /// In en, this message translates to:
  /// **'{count} Replies'**
  String communityReplies(int count);

  /// No description provided for @communityNoReplies.
  ///
  /// In en, this message translates to:
  /// **'No replies yet. Be the first to answer!'**
  String get communityNoReplies;

  /// No description provided for @communityReplyHint.
  ///
  /// In en, this message translates to:
  /// **'Write a reply...'**
  String get communityReplyHint;

  /// No description provided for @communityReplyPremiumOnly.
  ///
  /// In en, this message translates to:
  /// **'Posting and replying requires a Premium subscription.'**
  String get communityReplyPremiumOnly;

  /// No description provided for @communityVoteCount.
  ///
  /// In en, this message translates to:
  /// **'{count} votes'**
  String communityVoteCount(int count);

  /// No description provided for @communityModerationPending.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get communityModerationPending;

  /// No description provided for @communityModerationFlagged.
  ///
  /// In en, this message translates to:
  /// **'Flagged for review'**
  String get communityModerationFlagged;

  /// No description provided for @communityModerationNotice.
  ///
  /// In en, this message translates to:
  /// **'Your post will be reviewed by our AI moderation system before it becomes visible to others.'**
  String get communityModerationNotice;

  /// No description provided for @communityChannelLabel.
  ///
  /// In en, this message translates to:
  /// **'Language Channel'**
  String get communityChannelLabel;

  /// No description provided for @communityCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get communityCategoryLabel;

  /// No description provided for @communityTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get communityTitleLabel;

  /// No description provided for @communityTitleHint.
  ///
  /// In en, this message translates to:
  /// **'What\'s your question?'**
  String get communityTitleHint;

  /// No description provided for @communityTitleMinLength.
  ///
  /// In en, this message translates to:
  /// **'Title must be at least 5 characters'**
  String get communityTitleMinLength;

  /// No description provided for @communityContentLabel.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get communityContentLabel;

  /// No description provided for @communityContentHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your question or situation in detail...'**
  String get communityContentHint;

  /// No description provided for @communityContentMinLength.
  ///
  /// In en, this message translates to:
  /// **'Content must be at least 10 characters'**
  String get communityContentMinLength;

  /// No description provided for @communitySubmit.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get communitySubmit;

  /// No description provided for @communityTimeAgoDays.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String communityTimeAgoDays(int days);

  /// No description provided for @communityTimeAgoHours.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String communityTimeAgoHours(int hours);

  /// No description provided for @communityTimeAgoMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String communityTimeAgoMinutes(int minutes);

  /// No description provided for @subscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscriptionTitle;

  /// No description provided for @subscriptionPlansTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Plan'**
  String get subscriptionPlansTitle;

  /// No description provided for @subscriptionPlansSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock the full potential of Gaijin Life Navi'**
  String get subscriptionPlansSubtitle;

  /// No description provided for @subscriptionCurrentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get subscriptionCurrentPlan;

  /// No description provided for @subscriptionCurrentPlanBadge.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get subscriptionCurrentPlanBadge;

  /// No description provided for @subscriptionTierFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get subscriptionTierFree;

  /// No description provided for @subscriptionTierPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get subscriptionTierPremium;

  /// No description provided for @subscriptionTierPremiumPlus.
  ///
  /// In en, this message translates to:
  /// **'Premium+'**
  String get subscriptionTierPremiumPlus;

  /// No description provided for @subscriptionFreePrice.
  ///
  /// In en, this message translates to:
  /// **'¥0'**
  String get subscriptionFreePrice;

  /// No description provided for @subscriptionPricePerMonth.
  ///
  /// In en, this message translates to:
  /// **'¥{price}/month'**
  String subscriptionPricePerMonth(int price);

  /// No description provided for @subscriptionCheckout.
  ///
  /// In en, this message translates to:
  /// **'Subscribe Now'**
  String get subscriptionCheckout;

  /// No description provided for @subscriptionRecommended.
  ///
  /// In en, this message translates to:
  /// **'RECOMMENDED'**
  String get subscriptionRecommended;

  /// No description provided for @subscriptionCancelling.
  ///
  /// In en, this message translates to:
  /// **'Cancelling...'**
  String get subscriptionCancelling;

  /// No description provided for @subscriptionCancellingAt.
  ///
  /// In en, this message translates to:
  /// **'Your plan will end on {date}'**
  String subscriptionCancellingAt(String date);

  /// No description provided for @subscriptionFeatureFreeChat.
  ///
  /// In en, this message translates to:
  /// **'20 free AI chats on signup'**
  String get subscriptionFeatureFreeChat;

  /// No description provided for @subscriptionFeatureFreeScans.
  ///
  /// In en, this message translates to:
  /// **'3 document scans per month'**
  String get subscriptionFeatureFreeScans;

  /// No description provided for @subscriptionFeatureFreeTracker.
  ///
  /// In en, this message translates to:
  /// **'Track up to 3 procedures'**
  String get subscriptionFeatureFreeTracker;

  /// No description provided for @subscriptionFeatureFreeCommunityRead.
  ///
  /// In en, this message translates to:
  /// **'Read community posts'**
  String get subscriptionFeatureFreeCommunityRead;

  /// No description provided for @subscriptionFeatureCommunityPost.
  ///
  /// In en, this message translates to:
  /// **'Post & reply in community'**
  String get subscriptionFeatureCommunityPost;

  /// No description provided for @subscriptionFeatureUnlimitedChat.
  ///
  /// In en, this message translates to:
  /// **'Unlimited AI chats'**
  String get subscriptionFeatureUnlimitedChat;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditTitle;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEdit;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profileNationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get profileNationality;

  /// No description provided for @profileResidenceStatus.
  ///
  /// In en, this message translates to:
  /// **'Residence Status'**
  String get profileResidenceStatus;

  /// No description provided for @profileRegion.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get profileRegion;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileArrivalDate.
  ///
  /// In en, this message translates to:
  /// **'Arrival Date'**
  String get profileArrivalDate;

  /// No description provided for @profileDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get profileDisplayName;

  /// No description provided for @profileNoName.
  ///
  /// In en, this message translates to:
  /// **'No Name'**
  String get profileNoName;

  /// No description provided for @profileNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Name must be 100 characters or less'**
  String get profileNameTooLong;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get profileSaved;

  /// No description provided for @profileSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profileSaveButton;

  /// No description provided for @profileSaveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to save profile'**
  String get profileSaveError;

  /// No description provided for @profileLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get profileLoadError;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageSection;

  /// No description provided for @settingsAccountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccountSection;

  /// No description provided for @settingsAboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAboutSection;

  /// No description provided for @settingsLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get settingsLogout;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsDeleteAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone'**
  String get settingsDeleteAccountSubtitle;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsLogoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get settingsLogoutConfirmTitle;

  /// No description provided for @settingsLogoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get settingsLogoutConfirmMessage;

  /// No description provided for @settingsDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settingsDeleteConfirmTitle;

  /// No description provided for @settingsDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone. All your data will be permanently removed.'**
  String get settingsDeleteConfirmMessage;

  /// No description provided for @settingsDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account'**
  String get settingsDeleteError;

  /// No description provided for @settingsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsCancel;

  /// No description provided for @settingsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get settingsDelete;

  /// No description provided for @settingsConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get settingsConfirm;

  /// No description provided for @navTitle.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get navTitle;

  /// No description provided for @navSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore topics to help you navigate life in Japan.'**
  String get navSubtitle;

  /// No description provided for @navGuideCount.
  ///
  /// In en, this message translates to:
  /// **'{count} guides'**
  String navGuideCount(int count);

  /// No description provided for @navGuideCountOne.
  ///
  /// In en, this message translates to:
  /// **'1 guide'**
  String get navGuideCountOne;

  /// No description provided for @navComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get navComingSoon;

  /// No description provided for @navComingSoonSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Coming soon! We\'re working on it.'**
  String get navComingSoonSnackbar;

  /// No description provided for @navErrorLoad.
  ///
  /// In en, this message translates to:
  /// **'Unable to load guides.'**
  String get navErrorLoad;

  /// No description provided for @navErrorRetry.
  ///
  /// In en, this message translates to:
  /// **'Tap to retry'**
  String get navErrorRetry;

  /// No description provided for @domainBanking.
  ///
  /// In en, this message translates to:
  /// **'Banking & Finance'**
  String get domainBanking;

  /// No description provided for @domainVisa.
  ///
  /// In en, this message translates to:
  /// **'Visa & Immigration'**
  String get domainVisa;

  /// No description provided for @domainMedical.
  ///
  /// In en, this message translates to:
  /// **'Medical & Health'**
  String get domainMedical;

  /// No description provided for @domainConcierge.
  ///
  /// In en, this message translates to:
  /// **'Life & General'**
  String get domainConcierge;

  /// No description provided for @domainHousing.
  ///
  /// In en, this message translates to:
  /// **'Housing & Utilities'**
  String get domainHousing;

  /// No description provided for @domainEmployment.
  ///
  /// In en, this message translates to:
  /// **'Employment & Tax'**
  String get domainEmployment;

  /// No description provided for @domainEducation.
  ///
  /// In en, this message translates to:
  /// **'Education & Childcare'**
  String get domainEducation;

  /// No description provided for @domainLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal & Insurance'**
  String get domainLegal;

  /// No description provided for @guideSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search guides...'**
  String get guideSearchPlaceholder;

  /// No description provided for @guideComingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get guideComingSoonTitle;

  /// No description provided for @guideComingSoonSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'re working on {domain} guides. Check back soon!'**
  String guideComingSoonSubtitle(String domain);

  /// No description provided for @guideComingSoonAskAi.
  ///
  /// In en, this message translates to:
  /// **'Ask AI about {domain}'**
  String guideComingSoonAskAi(String domain);

  /// No description provided for @guideSearchEmpty.
  ///
  /// In en, this message translates to:
  /// **'No guides found for \"{query}\".'**
  String guideSearchEmpty(String query);

  /// No description provided for @guideSearchTry.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term.'**
  String get guideSearchTry;

  /// No description provided for @guideErrorLoad.
  ///
  /// In en, this message translates to:
  /// **'Unable to load guides for this category.'**
  String get guideErrorLoad;

  /// No description provided for @guideAskAi.
  ///
  /// In en, this message translates to:
  /// **'Ask AI about this topic'**
  String get guideAskAi;

  /// No description provided for @guideDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This is general information and does not constitute legal advice. Please verify with relevant authorities.'**
  String get guideDisclaimer;

  /// No description provided for @guideShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get guideShare;

  /// No description provided for @guideErrorNotFound.
  ///
  /// In en, this message translates to:
  /// **'This guide is no longer available.'**
  String get guideErrorNotFound;

  /// No description provided for @guideErrorLoadDetail.
  ///
  /// In en, this message translates to:
  /// **'Unable to load this guide. Please try again.'**
  String get guideErrorLoadDetail;

  /// No description provided for @guideErrorRetryBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get guideErrorRetryBack;

  /// No description provided for @emergencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get emergencyTitle;

  /// No description provided for @emergencyWarning.
  ///
  /// In en, this message translates to:
  /// **'If you are in immediate danger, call 110 (Police) or 119 (Fire/Ambulance) immediately.'**
  String get emergencyWarning;

  /// No description provided for @emergencySectionContacts.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get emergencySectionContacts;

  /// No description provided for @emergencySectionAmbulance.
  ///
  /// In en, this message translates to:
  /// **'How to Call an Ambulance'**
  String get emergencySectionAmbulance;

  /// No description provided for @emergencySectionMoreHelp.
  ///
  /// In en, this message translates to:
  /// **'Need more help?'**
  String get emergencySectionMoreHelp;

  /// No description provided for @emergencyPoliceName.
  ///
  /// In en, this message translates to:
  /// **'Police'**
  String get emergencyPoliceName;

  /// No description provided for @emergencyPoliceNumber.
  ///
  /// In en, this message translates to:
  /// **'110'**
  String get emergencyPoliceNumber;

  /// No description provided for @emergencyFireName.
  ///
  /// In en, this message translates to:
  /// **'Fire / Ambulance'**
  String get emergencyFireName;

  /// No description provided for @emergencyFireNumber.
  ///
  /// In en, this message translates to:
  /// **'119'**
  String get emergencyFireNumber;

  /// No description provided for @emergencyMedicalName.
  ///
  /// In en, this message translates to:
  /// **'Medical Consultation'**
  String get emergencyMedicalName;

  /// No description provided for @emergencyMedicalNumber.
  ///
  /// In en, this message translates to:
  /// **'#7119'**
  String get emergencyMedicalNumber;

  /// No description provided for @emergencyMedicalNote.
  ///
  /// In en, this message translates to:
  /// **'Non-emergency medical advice'**
  String get emergencyMedicalNote;

  /// No description provided for @emergencyTellName.
  ///
  /// In en, this message translates to:
  /// **'TELL Japan (Mental Health)'**
  String get emergencyTellName;

  /// No description provided for @emergencyTellNumber.
  ///
  /// In en, this message translates to:
  /// **'03-5774-0992'**
  String get emergencyTellNumber;

  /// No description provided for @emergencyTellNote.
  ///
  /// In en, this message translates to:
  /// **'Counseling in English'**
  String get emergencyTellNote;

  /// No description provided for @emergencyHelplineName.
  ///
  /// In en, this message translates to:
  /// **'Japan Helpline'**
  String get emergencyHelplineName;

  /// No description provided for @emergencyHelplineNumber.
  ///
  /// In en, this message translates to:
  /// **'0570-064-211'**
  String get emergencyHelplineNumber;

  /// No description provided for @emergencyHelplineNote.
  ///
  /// In en, this message translates to:
  /// **'24 hours, multilingual'**
  String get emergencyHelplineNote;

  /// No description provided for @emergencyStep1.
  ///
  /// In en, this message translates to:
  /// **'Call 119'**
  String get emergencyStep1;

  /// No description provided for @emergencyStep2.
  ///
  /// In en, this message translates to:
  /// **'Say \"Kyuukyuu desu\" (救急です — It\'s an emergency)'**
  String get emergencyStep2;

  /// No description provided for @emergencyStep3.
  ///
  /// In en, this message translates to:
  /// **'Explain your location (address, nearby landmarks)'**
  String get emergencyStep3;

  /// No description provided for @emergencyStep4.
  ///
  /// In en, this message translates to:
  /// **'Describe the situation (what happened, symptoms)'**
  String get emergencyStep4;

  /// No description provided for @emergencyStep5.
  ///
  /// In en, this message translates to:
  /// **'Wait for the ambulance at the entrance of your building'**
  String get emergencyStep5;

  /// No description provided for @emergencyPhraseEmergencyHelp.
  ///
  /// In en, this message translates to:
  /// **'It\'s an emergency'**
  String get emergencyPhraseEmergencyHelp;

  /// No description provided for @emergencyPhraseHelpHelp.
  ///
  /// In en, this message translates to:
  /// **'Please help'**
  String get emergencyPhraseHelpHelp;

  /// No description provided for @emergencyPhraseAmbulanceHelp.
  ///
  /// In en, this message translates to:
  /// **'Please send an ambulance'**
  String get emergencyPhraseAmbulanceHelp;

  /// No description provided for @emergencyPhraseAddressHelp.
  ///
  /// In en, this message translates to:
  /// **'The address is ○○'**
  String get emergencyPhraseAddressHelp;

  /// No description provided for @emergencyAskAi.
  ///
  /// In en, this message translates to:
  /// **'Chat with AI about emergency situations'**
  String get emergencyAskAi;

  /// No description provided for @emergencyDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This guide provides general health information and is not a substitute for professional medical advice. In an emergency, call 119 immediately.'**
  String get emergencyDisclaimer;

  /// No description provided for @emergencyCallButton.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get emergencyCallButton;

  /// No description provided for @emergencyOffline.
  ///
  /// In en, this message translates to:
  /// **'Unable to load additional information. Call 110 or 119 if you need help.'**
  String get emergencyOffline;

  /// No description provided for @subTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subTitle;

  /// No description provided for @subSectionCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get subSectionCurrent;

  /// No description provided for @subSectionChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose a Plan'**
  String get subSectionChoose;

  /// No description provided for @subSectionCharge.
  ///
  /// In en, this message translates to:
  /// **'Need More Chats?'**
  String get subSectionCharge;

  /// No description provided for @subSectionFaq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get subSectionFaq;

  /// No description provided for @subCurrentFree.
  ///
  /// In en, this message translates to:
  /// **'Free Plan'**
  String get subCurrentFree;

  /// No description provided for @subCurrentStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard Plan'**
  String get subCurrentStandard;

  /// No description provided for @subCurrentPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium Plan'**
  String get subCurrentPremium;

  /// No description provided for @subUpgradeNow.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Now'**
  String get subUpgradeNow;

  /// No description provided for @subPlanFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get subPlanFree;

  /// No description provided for @subPlanStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get subPlanStandard;

  /// No description provided for @subPlanPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get subPlanPremium;

  /// No description provided for @subPriceFree.
  ///
  /// In en, this message translates to:
  /// **'¥0'**
  String get subPriceFree;

  /// No description provided for @subPriceStandard.
  ///
  /// In en, this message translates to:
  /// **'¥720'**
  String get subPriceStandard;

  /// No description provided for @subPricePremium.
  ///
  /// In en, this message translates to:
  /// **'¥1,360'**
  String get subPricePremium;

  /// No description provided for @subPriceInterval.
  ///
  /// In en, this message translates to:
  /// **'/month'**
  String get subPriceInterval;

  /// No description provided for @subRecommended.
  ///
  /// In en, this message translates to:
  /// **'RECOMMENDED'**
  String get subRecommended;

  /// No description provided for @subFeatureChatFree.
  ///
  /// In en, this message translates to:
  /// **'20 AI Guide chats on signup'**
  String get subFeatureChatFree;

  /// No description provided for @subFeatureChatStandard.
  ///
  /// In en, this message translates to:
  /// **'300 AI Guide chats/month'**
  String get subFeatureChatStandard;

  /// No description provided for @subFeatureChatPremium.
  ///
  /// In en, this message translates to:
  /// **'Unlimited AI Guide chats'**
  String get subFeatureChatPremium;

  /// No description provided for @subFeatureTrackerFree.
  ///
  /// In en, this message translates to:
  /// **'Up to 3 tracker items'**
  String get subFeatureTrackerFree;

  /// No description provided for @subFeatureTrackerPaid.
  ///
  /// In en, this message translates to:
  /// **'Unlimited tracker items'**
  String get subFeatureTrackerPaid;

  /// No description provided for @subFeatureAdsYes.
  ///
  /// In en, this message translates to:
  /// **'Contains ads'**
  String get subFeatureAdsYes;

  /// No description provided for @subFeatureAdsNo.
  ///
  /// In en, this message translates to:
  /// **'No ads'**
  String get subFeatureAdsNo;

  /// No description provided for @subFeatureGuideFree.
  ///
  /// In en, this message translates to:
  /// **'Browse selected guides'**
  String get subFeatureGuideFree;

  /// No description provided for @subFeatureGuidePaid.
  ///
  /// In en, this message translates to:
  /// **'Browse all guides'**
  String get subFeatureGuidePaid;

  /// No description provided for @subFeatureImageNo.
  ///
  /// In en, this message translates to:
  /// **'AI image analysis (in chat)'**
  String get subFeatureImageNo;

  /// No description provided for @subFeatureImageYes.
  ///
  /// In en, this message translates to:
  /// **'AI image analysis (in chat)'**
  String get subFeatureImageYes;

  /// No description provided for @subButtonCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get subButtonCurrent;

  /// No description provided for @subButtonChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose {plan}'**
  String subButtonChoose(String plan);

  /// No description provided for @subCharge100.
  ///
  /// In en, this message translates to:
  /// **'100 Chats Pack'**
  String get subCharge100;

  /// No description provided for @subCharge50.
  ///
  /// In en, this message translates to:
  /// **'50 Chats Pack'**
  String get subCharge50;

  /// No description provided for @subCharge100Price.
  ///
  /// In en, this message translates to:
  /// **'¥360 (¥3.6/chat)'**
  String get subCharge100Price;

  /// No description provided for @subCharge50Price.
  ///
  /// In en, this message translates to:
  /// **'¥180 (¥3.6/chat)'**
  String get subCharge50Price;

  /// No description provided for @subChargeDescription.
  ///
  /// In en, this message translates to:
  /// **'Extra chats that never expire. Used after your plan\'s limit.'**
  String get subChargeDescription;

  /// No description provided for @subFaqBillingQ.
  ///
  /// In en, this message translates to:
  /// **'How does billing work?'**
  String get subFaqBillingQ;

  /// No description provided for @subFaqBillingA.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions are billed monthly through the App Store or Google Play. You can manage your subscription in your device settings.'**
  String get subFaqBillingA;

  /// No description provided for @subFaqCancelQ.
  ///
  /// In en, this message translates to:
  /// **'Can I cancel anytime?'**
  String get subFaqCancelQ;

  /// No description provided for @subFaqCancelA.
  ///
  /// In en, this message translates to:
  /// **'Yes! You can cancel anytime. Your plan will remain active until the end of the billing period.'**
  String get subFaqCancelA;

  /// No description provided for @subFaqDowngradeQ.
  ///
  /// In en, this message translates to:
  /// **'What happens when I downgrade?'**
  String get subFaqDowngradeQ;

  /// No description provided for @subFaqDowngradeA.
  ///
  /// In en, this message translates to:
  /// **'When you downgrade, you\'ll keep your current plan benefits until the end of the billing period. Then your plan will switch to the new tier.'**
  String get subFaqDowngradeA;

  /// No description provided for @subFooter.
  ///
  /// In en, this message translates to:
  /// **'Subscription managed via App Store / Google Play'**
  String get subFooter;

  /// No description provided for @subPurchaseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Welcome to {plan}! Your upgrade is now active.'**
  String subPurchaseSuccess(String plan);

  /// No description provided for @subPurchaseError.
  ///
  /// In en, this message translates to:
  /// **'Unable to complete purchase. Please try again.'**
  String get subPurchaseError;

  /// No description provided for @subErrorLoad.
  ///
  /// In en, this message translates to:
  /// **'Unable to load subscription plans.'**
  String get subErrorLoad;

  /// No description provided for @subErrorRetry.
  ///
  /// In en, this message translates to:
  /// **'Tap to retry'**
  String get subErrorRetry;

  /// No description provided for @profileSectionInfo.
  ///
  /// In en, this message translates to:
  /// **'Your Information'**
  String get profileSectionInfo;

  /// No description provided for @profileSectionStats.
  ///
  /// In en, this message translates to:
  /// **'Usage Statistics'**
  String get profileSectionStats;

  /// No description provided for @profileChatsToday.
  ///
  /// In en, this message translates to:
  /// **'Chats today'**
  String get profileChatsToday;

  /// No description provided for @profileMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since'**
  String get profileMemberSince;

  /// No description provided for @profileManageSubscription.
  ///
  /// In en, this message translates to:
  /// **'Manage Subscription'**
  String get profileManageSubscription;

  /// No description provided for @profileNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get profileNotSet;

  /// No description provided for @editTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editTitle;

  /// No description provided for @editSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get editSave;

  /// No description provided for @editNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get editNameLabel;

  /// No description provided for @editNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get editNameHint;

  /// No description provided for @editNationalityLabel.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get editNationalityLabel;

  /// No description provided for @editNationalityHint.
  ///
  /// In en, this message translates to:
  /// **'Select your nationality'**
  String get editNationalityHint;

  /// No description provided for @editStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Residence Status'**
  String get editStatusLabel;

  /// No description provided for @editStatusHint.
  ///
  /// In en, this message translates to:
  /// **'Select your status'**
  String get editStatusHint;

  /// No description provided for @editRegionLabel.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get editRegionLabel;

  /// No description provided for @editRegionHint.
  ///
  /// In en, this message translates to:
  /// **'Select your region'**
  String get editRegionHint;

  /// No description provided for @editLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred Language'**
  String get editLanguageLabel;

  /// No description provided for @editChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get editChangePhoto;

  /// No description provided for @editSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully.'**
  String get editSuccess;

  /// No description provided for @editError.
  ///
  /// In en, this message translates to:
  /// **'Unable to update profile. Please try again.'**
  String get editError;

  /// No description provided for @editUnsavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get editUnsavedTitle;

  /// No description provided for @editUnsavedMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Discard them?'**
  String get editUnsavedMessage;

  /// No description provided for @editUnsavedDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get editUnsavedDiscard;

  /// No description provided for @editUnsavedKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get editUnsavedKeep;

  /// No description provided for @settingsSectionGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsSectionGeneral;

  /// No description provided for @settingsSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsSectionAccount;

  /// No description provided for @settingsSectionDanger.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get settingsSectionDanger;

  /// No description provided for @settingsSectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsSectionAbout;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsSubscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get settingsSubscription;

  /// No description provided for @settingsTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settingsTerms;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacy;

  /// No description provided for @settingsContact.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get settingsContact;

  /// No description provided for @settingsFooter.
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️ for everyone navigating life in Japan'**
  String get settingsFooter;

  /// No description provided for @settingsLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get settingsLogoutTitle;

  /// No description provided for @settingsLogoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get settingsLogoutMessage;

  /// No description provided for @settingsLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get settingsLogoutConfirm;

  /// No description provided for @settingsLogoutCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsLogoutCancel;

  /// No description provided for @settingsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settingsDeleteTitle;

  /// No description provided for @settingsDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All your data will be permanently deleted. Are you sure?'**
  String get settingsDeleteMessage;

  /// No description provided for @settingsDeleteConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Delete My Account'**
  String get settingsDeleteConfirmAction;

  /// No description provided for @settingsDeleteCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsDeleteCancel;

  /// No description provided for @settingsDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted.'**
  String get settingsDeleteSuccess;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsErrorLogout.
  ///
  /// In en, this message translates to:
  /// **'Unable to log out. Please try again.'**
  String get settingsErrorLogout;

  /// No description provided for @settingsErrorDelete.
  ///
  /// In en, this message translates to:
  /// **'Unable to delete account. Please try again.'**
  String get settingsErrorDelete;

  /// No description provided for @chatGuestTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask AI anything about life in Japan'**
  String get chatGuestTitle;

  /// No description provided for @chatGuestFeature1.
  ///
  /// In en, this message translates to:
  /// **'How to open a bank account'**
  String get chatGuestFeature1;

  /// No description provided for @chatGuestFeature2.
  ///
  /// In en, this message translates to:
  /// **'Visa renewal procedures'**
  String get chatGuestFeature2;

  /// No description provided for @chatGuestFeature3.
  ///
  /// In en, this message translates to:
  /// **'How to visit a hospital'**
  String get chatGuestFeature3;

  /// No description provided for @chatGuestFeature4.
  ///
  /// In en, this message translates to:
  /// **'And anything else'**
  String get chatGuestFeature4;

  /// No description provided for @chatGuestFreeOffer.
  ///
  /// In en, this message translates to:
  /// **'Free signup — 20 chats included'**
  String get chatGuestFreeOffer;

  /// No description provided for @chatGuestSignUp.
  ///
  /// In en, this message translates to:
  /// **'Get started free'**
  String get chatGuestSignUp;

  /// No description provided for @chatGuestLogin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in'**
  String get chatGuestLogin;

  /// No description provided for @guestRegisterCta.
  ///
  /// In en, this message translates to:
  /// **'Sign up free to use AI Chat'**
  String get guestRegisterCta;

  /// No description provided for @guideReadMore.
  ///
  /// In en, this message translates to:
  /// **'Sign up to read the full guide'**
  String get guideReadMore;

  /// No description provided for @guideAskAI.
  ///
  /// In en, this message translates to:
  /// **'Ask AI for details'**
  String get guideAskAI;

  /// No description provided for @guideGuestCtaButton.
  ///
  /// In en, this message translates to:
  /// **'Create Free Account'**
  String get guideGuestCtaButton;

  /// No description provided for @homeGuestCtaText.
  ///
  /// In en, this message translates to:
  /// **'Create your free account to unlock AI chat and personalized guides'**
  String get homeGuestCtaText;

  /// No description provided for @homeGuestCtaButton.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get homeGuestCtaButton;

  /// No description provided for @chatUpgradeBanner.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium for unlimited chat'**
  String get chatUpgradeBanner;

  /// No description provided for @chatUpgradeButton.
  ///
  /// In en, this message translates to:
  /// **'View Plans'**
  String get chatUpgradeButton;

  /// No description provided for @guidePremiumCta.
  ///
  /// In en, this message translates to:
  /// **'This content is available with a Premium subscription'**
  String get guidePremiumCta;

  /// No description provided for @guidePremiumCtaButton.
  ///
  /// In en, this message translates to:
  /// **'View Plans'**
  String get guidePremiumCtaButton;

  /// No description provided for @guideTierLimitError.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to access the full guide content'**
  String get guideTierLimitError;

  /// No description provided for @trackerSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get trackerSave;

  /// No description provided for @trackerSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get trackerSaved;

  /// No description provided for @trackerItemSaved.
  ///
  /// In en, this message translates to:
  /// **'Added to to-do list'**
  String get trackerItemSaved;

  /// No description provided for @homeQaTrackerTitle.
  ///
  /// In en, this message translates to:
  /// **'To-Do'**
  String get homeQaTrackerTitle;

  /// No description provided for @homeQaTrackerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your to-do list'**
  String get homeQaTrackerSubtitle;

  /// No description provided for @chatAttachPhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get chatAttachPhoto;

  /// No description provided for @chatAttachGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chatAttachGallery;

  /// No description provided for @chatAttachCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get chatAttachCancel;

  /// No description provided for @chatImageTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Image is too large (max 5MB)'**
  String get chatImageTooLarge;

  /// No description provided for @profilePersonalizationHint.
  ///
  /// In en, this message translates to:
  /// **'The AI guide will provide more personalized advice based on your completed profile'**
  String get profilePersonalizationHint;

  /// No description provided for @profileVisaExpiry.
  ///
  /// In en, this message translates to:
  /// **'Visa Expiry'**
  String get profileVisaExpiry;

  /// No description provided for @profileResidenceRegion.
  ///
  /// In en, this message translates to:
  /// **'Residence Area'**
  String get profileResidenceRegion;

  /// No description provided for @profilePreferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Preferred Language'**
  String get profilePreferredLanguage;

  /// No description provided for @profileSelectNationality.
  ///
  /// In en, this message translates to:
  /// **'Select Nationality'**
  String get profileSelectNationality;

  /// No description provided for @profileSelectResidenceStatus.
  ///
  /// In en, this message translates to:
  /// **'Select Residence Status'**
  String get profileSelectResidenceStatus;

  /// No description provided for @profileSelectPrefecture.
  ///
  /// In en, this message translates to:
  /// **'Select Prefecture'**
  String get profileSelectPrefecture;

  /// No description provided for @profileSelectCity.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get profileSelectCity;

  /// No description provided for @profileSelectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get profileSelectLanguage;

  /// No description provided for @profileCommonStatuses.
  ///
  /// In en, this message translates to:
  /// **'Common'**
  String get profileCommonStatuses;

  /// No description provided for @profileOtherStatuses.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get profileOtherStatuses;

  /// No description provided for @profileSearchNationality.
  ///
  /// In en, this message translates to:
  /// **'Search nationality'**
  String get profileSearchNationality;

  /// No description provided for @visaRenewalPrepTitle.
  ///
  /// In en, this message translates to:
  /// **'Prepare visa renewal application'**
  String get visaRenewalPrepTitle;

  /// No description provided for @visaRenewalDeadlineTitle.
  ///
  /// In en, this message translates to:
  /// **'Visa renewal deadline'**
  String get visaRenewalDeadlineTitle;

  /// No description provided for @profileSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profileSave;

  /// No description provided for @profileUsageStats.
  ///
  /// In en, this message translates to:
  /// **'Usage Statistics'**
  String get profileUsageStats;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileLogout;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get profileDeleteAccount;

  /// No description provided for @subUsageTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Usage'**
  String get subUsageTitle;

  /// No description provided for @subUsageCount.
  ///
  /// In en, this message translates to:
  /// **'Used {used} / {limit} chats'**
  String subUsageCount(int used, int limit);

  /// No description provided for @subUsageUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited chats'**
  String get subUsageUnlimited;

  /// No description provided for @tabAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get tabAccount;

  /// No description provided for @accountSectionProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get accountSectionProfile;

  /// No description provided for @accountSectionManagement.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSectionManagement;

  /// No description provided for @accountSectionDanger.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get accountSectionDanger;
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
