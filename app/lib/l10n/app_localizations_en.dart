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
  String get langTitle => 'Choose your language';

  @override
  String get langContinue => 'Continue';

  @override
  String get langEn => 'English';

  @override
  String get langZh => '中文';

  @override
  String get langVi => 'Tiếng Việt';

  @override
  String get langKo => '한국어';

  @override
  String get langPt => 'Português';

  @override
  String get loginWelcome => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to continue';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'your@email.com';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordHint => 'Enter your password';

  @override
  String get loginForgotPassword => 'Forgot password?';

  @override
  String get loginButton => 'Sign In';

  @override
  String get loginNoAccount => 'Don\'t have an account?';

  @override
  String get loginSignUp => 'Sign Up';

  @override
  String get loginErrorInvalidEmail => 'Please enter a valid email address.';

  @override
  String get loginErrorInvalidCredentials =>
      'Incorrect email or password. Please try again.';

  @override
  String get loginErrorNetwork =>
      'Unable to connect. Please check your internet connection.';

  @override
  String get loginErrorTooManyAttempts =>
      'Too many attempts. Please try again later.';

  @override
  String get registerTitle => 'Create your account';

  @override
  String get registerSubtitle => 'Start your journey in Japan';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerEmailHint => 'your@email.com';

  @override
  String get registerPasswordLabel => 'Password';

  @override
  String get registerPasswordHint => 'Create a password';

  @override
  String get registerPasswordHelper => '8 or more characters';

  @override
  String get registerConfirmLabel => 'Confirm password';

  @override
  String get registerConfirmHint => 'Re-enter your password';

  @override
  String get registerTermsAgree => 'I agree to the ';

  @override
  String get registerTermsLink => 'Terms of Service';

  @override
  String get registerPrivacyAnd => 'and';

  @override
  String get registerPrivacyLink => 'Privacy Policy';

  @override
  String get registerButton => 'Create Account';

  @override
  String get registerHasAccount => 'Already have an account?';

  @override
  String get registerSignIn => 'Sign In';

  @override
  String get registerErrorEmailInvalid => 'Please enter a valid email address.';

  @override
  String get registerErrorEmailInUse =>
      'This email is already registered. Try signing in instead.';

  @override
  String get registerErrorPasswordShort =>
      'Password must be at least 8 characters.';

  @override
  String get registerErrorPasswordMismatch => 'Passwords don\'t match.';

  @override
  String get registerErrorTermsRequired =>
      'Please agree to the Terms of Service.';

  @override
  String get resetTitle => 'Reset your password';

  @override
  String get resetSubtitle =>
      'Enter your email and we\'ll send you a reset link.';

  @override
  String get resetEmailLabel => 'Email';

  @override
  String get resetEmailHint => 'your@email.com';

  @override
  String get resetButton => 'Send Reset Link';

  @override
  String get resetBackToLogin => 'Back to Sign In';

  @override
  String get resetSuccessTitle => 'Check your email';

  @override
  String resetSuccessSubtitle(String email) {
    return 'We\'ve sent a reset link to $email';
  }

  @override
  String get resetResend => 'Didn\'t receive it? Resend';

  @override
  String get resetErrorEmailInvalid => 'Please enter a valid email address.';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String onboardingStepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get onboardingS1Title => 'What\'s your nationality?';

  @override
  String get onboardingS1Subtitle =>
      'This helps us give you relevant information.';

  @override
  String get onboardingS2Title => 'What\'s your residence status?';

  @override
  String get onboardingS2Subtitle =>
      'We can tailor visa-related information for you.';

  @override
  String get onboardingS3Title => 'Where do you live in Japan?';

  @override
  String get onboardingS3Subtitle => 'For location-specific guides.';

  @override
  String get onboardingS4Title => 'When did you arrive in Japan?';

  @override
  String get onboardingS4Subtitle =>
      'We\'ll suggest time-sensitive tasks you may need to complete.';

  @override
  String get onboardingS4Placeholder => 'Select date';

  @override
  String get onboardingS4NotYet => 'I haven\'t arrived yet';

  @override
  String get onboardingChangeDate => 'Change Date';

  @override
  String get onboardingErrorSave =>
      'Unable to save your information. Please try again.';

  @override
  String get statusEngineer => 'Engineer / Specialist in Humanities';

  @override
  String get statusStudent => 'Student';

  @override
  String get statusDependent => 'Dependent';

  @override
  String get statusPermanent => 'Permanent Resident';

  @override
  String get statusSpouse => 'Spouse of Japanese National';

  @override
  String get statusWorkingHoliday => 'Working Holiday';

  @override
  String get statusSpecifiedSkilled => 'Specified Skilled Worker';

  @override
  String get statusOther => 'Other';

  @override
  String get tabHome => 'Home';

  @override
  String get tabChat => 'Chat';

  @override
  String get tabGuide => 'Guide';

  @override
  String get tabSOS => 'SOS';

  @override
  String get tabProfile => 'Profile';

  @override
  String homeGreetingMorning(String name) {
    return 'Good morning, $name 👋';
  }

  @override
  String homeGreetingAfternoon(String name) {
    return 'Good afternoon, $name 👋';
  }

  @override
  String homeGreetingEvening(String name) {
    return 'Good evening, $name 👋';
  }

  @override
  String homeGreetingDefault(String name) {
    return 'Hello, $name 👋';
  }

  @override
  String get homeGreetingNoName => 'Welcome! 👋';

  @override
  String homeUsageFree(int remaining, int limit) {
    return 'Free • $remaining/$limit chats remaining today';
  }

  @override
  String get homeSectionQuickActions => 'Quick Actions';

  @override
  String get homeSectionExplore => 'Explore Guides';

  @override
  String get homeQaChatTitle => 'AI Chat';

  @override
  String get homeQaChatSubtitle => 'Ask anything about life in Japan';

  @override
  String get homeQaBankingTitle => 'Banking';

  @override
  String get homeQaBankingSubtitle => 'Account opening, transfers & more';

  @override
  String get homeQaVisaTitle => 'Visa';

  @override
  String get homeQaVisaSubtitle => 'Immigration guides & procedures';

  @override
  String get homeQaMedicalTitle => 'Medical';

  @override
  String get homeQaMedicalSubtitle => 'Health guides & emergency info';

  @override
  String get homeExploreGuides => 'Browse all guides';

  @override
  String get homeExploreEmergency => 'Emergency contacts';

  @override
  String get homeUpgradeTitle => 'Get more from your AI assistant';

  @override
  String get homeUpgradeCta => 'Upgrade now';

  @override
  String get chatTitle => 'AI Chat';

  @override
  String get chatInputPlaceholder => 'Type your message...';

  @override
  String get chatEmptyTitle => 'Ask me anything!';

  @override
  String get chatEmptySubtitle =>
      'I can help you with banking, visa, medical questions and more about life in Japan.';

  @override
  String get chatSuggestBank => 'How do I open a bank account?';

  @override
  String get chatSuggestVisa => 'How to renew my visa?';

  @override
  String get chatSuggestMedical => 'How to see a doctor?';

  @override
  String get chatSuggestGeneral => 'What do I need after arriving in Japan?';

  @override
  String get chatSourcesHeader => 'Sources';

  @override
  String get chatDisclaimer =>
      'This is general information only. It does not constitute legal advice. Please verify with relevant authorities.';

  @override
  String chatLimitRemaining(int remaining, int limit) {
    return '$remaining/$limit free chats remaining today.';
  }

  @override
  String get chatLimitUpgrade => 'Upgrade';

  @override
  String get chatLimitExhausted =>
      'You\'ve used all your free chats for today. Upgrade to keep chatting!';

  @override
  String get chatErrorSend => 'Unable to send your message. Please try again.';

  @override
  String get chatErrorRetry => 'Retry';

  @override
  String get chatDateToday => 'Today';

  @override
  String get chatDateYesterday => 'Yesterday';

  @override
  String get chatNewSession => 'New Chat';

  @override
  String get chatUntitledSession => 'New Conversation';

  @override
  String get chatDeleteTitle => 'Delete Chat';

  @override
  String get chatDeleteConfirm => 'Are you sure you want to delete this chat?';

  @override
  String get chatDeleteCancel => 'Cancel';

  @override
  String get chatDeleteAction => 'Delete';

  @override
  String get chatRetry => 'Retry';

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
  String get genericError => 'Something went wrong. Please try again.';

  @override
  String get networkError => 'Network error. Please check your connection.';

  @override
  String get logout => 'Logout';

  @override
  String get bankingTitle => 'Banking Navigator';

  @override
  String get bankingFriendlyScore => 'Foreigner-Friendly Score';

  @override
  String get bankingEmpty => 'No banks found';

  @override
  String get bankingRecommendButton => 'Recommend';

  @override
  String get bankingRecommendTitle => 'Bank Recommendations';

  @override
  String get bankingSelectPriorities => 'Select your priorities';

  @override
  String get bankingPriorityMultilingual => 'Multilingual Support';

  @override
  String get bankingPriorityLowFee => 'Low Fees';

  @override
  String get bankingPriorityAtm => 'ATM Network';

  @override
  String get bankingPriorityOnline => 'Online Banking';

  @override
  String get bankingGetRecommendations => 'Get Recommendations';

  @override
  String get bankingRecommendHint =>
      'Select your priorities and tap Get Recommendations';

  @override
  String get bankingNoRecommendations => 'No recommendations found';

  @override
  String get bankingViewGuide => 'View Guide';

  @override
  String get bankingGuideTitle => 'Account Opening Guide';

  @override
  String get bankingRequiredDocs => 'Required Documents';

  @override
  String get bankingConversationTemplates => 'Useful Phrases at the Bank';

  @override
  String get bankingTroubleshooting => 'Troubleshooting Tips';

  @override
  String get bankingSource => 'Source';

  @override
  String get visaTitle => 'Visa Navigator';

  @override
  String get visaEmpty => 'No procedures found';

  @override
  String get visaFilterAll => 'All';

  @override
  String get visaDetailTitle => 'Procedure Details';

  @override
  String get visaSteps => 'Steps';

  @override
  String get visaRequiredDocuments => 'Required Documents';

  @override
  String get visaFees => 'Fees';

  @override
  String get visaProcessingTime => 'Processing Time';

  @override
  String get visaDisclaimer =>
      'IMPORTANT: This is general information about visa procedures and does not constitute immigration advice.';

  @override
  String get trackerTitle => 'Admin Tracker';

  @override
  String get trackerEmpty => 'No procedures tracked';

  @override
  String get trackerEmptyHint => 'Tap + to add procedures to track';

  @override
  String get trackerAddProcedure => 'Add Procedure';

  @override
  String get trackerStatusNotStarted => 'Not Started';

  @override
  String get trackerStatusInProgress => 'In Progress';

  @override
  String get trackerStatusCompleted => 'Completed';

  @override
  String get trackerDueDate => 'Due Date';

  @override
  String get trackerFreeLimitInfo =>
      'Free plan: up to 3 procedures. Upgrade for unlimited.';

  @override
  String get trackerDetailTitle => 'Procedure Details';

  @override
  String get trackerCurrentStatus => 'Current Status';

  @override
  String get trackerNotes => 'Notes';

  @override
  String get trackerChangeStatus => 'Change Status';

  @override
  String get trackerMarkInProgress => 'Mark as In Progress';

  @override
  String get trackerMarkCompleted => 'Mark as Completed';

  @override
  String get trackerMarkIncomplete => 'Mark as Incomplete';

  @override
  String get trackerStatusUpdated => 'Status updated';

  @override
  String get trackerDeleteTitle => 'Delete Procedure';

  @override
  String get trackerDeleteConfirm =>
      'Are you sure you want to remove this procedure from your tracker?';

  @override
  String get trackerProcedureAdded => 'Procedure added to tracker';

  @override
  String get trackerLimitReached =>
      'Free plan limit reached (3 procedures). Upgrade to Premium for unlimited.';

  @override
  String get trackerAlreadyTracking =>
      'You are already tracking this procedure';

  @override
  String get trackerEssentialProcedures => 'Essential (After Arrival)';

  @override
  String get trackerOtherProcedures => 'Other Procedures';

  @override
  String get trackerNoTemplates => 'No procedure templates available';

  @override
  String get scannerTitle => 'Document Scanner';

  @override
  String get scannerDescription =>
      'Scan Japanese documents to get instant translations and explanations';

  @override
  String get scannerFromCamera => 'Scan from Camera';

  @override
  String get scannerFromGallery => 'Choose from Gallery';

  @override
  String get scannerHistory => 'History';

  @override
  String get scannerHistoryTitle => 'Scan History';

  @override
  String get scannerHistoryEmpty => 'No scans yet';

  @override
  String get scannerUnknownType => 'Unknown Document';

  @override
  String get scannerResultTitle => 'Scan Result';

  @override
  String get scannerOriginalText => 'Original Text (Japanese)';

  @override
  String get scannerTranslation => 'Translation';

  @override
  String get scannerExplanation => 'What This Means';

  @override
  String get scannerProcessing => 'Processing your document...';

  @override
  String get scannerRefresh => 'Refresh';

  @override
  String get scannerFailed => 'Scan failed. Please try again.';

  @override
  String get scannerFreeLimitInfo =>
      'Free plan: 3 scans/month. Upgrade for more.';

  @override
  String get scannerLimitReached =>
      'Monthly scan limit reached. Upgrade to Premium for more scans.';

  @override
  String get medicalTitle => 'Medical Guide';

  @override
  String get medicalTabEmergency => 'Emergency';

  @override
  String get medicalTabPhrases => 'Phrases';

  @override
  String get medicalEmergencyNumber => 'Emergency Number';

  @override
  String get medicalHowToCall => 'How to Call';

  @override
  String get medicalWhatToPrepare => 'What to Prepare';

  @override
  String get medicalUsefulPhrases => 'Useful Phrases';

  @override
  String get medicalCategoryAll => 'All';

  @override
  String get medicalCategoryEmergency => 'Emergency';

  @override
  String get medicalCategorySymptom => 'Symptoms';

  @override
  String get medicalCategoryInsurance => 'Insurance';

  @override
  String get medicalCategoryGeneral => 'General';

  @override
  String get medicalNoPhrases => 'No phrases found';

  @override
  String get medicalDisclaimer =>
      'This guide provides general health information and is not a substitute for professional medical advice. In an emergency, call 119 immediately.';

  @override
  String get navigateBanking => 'Banking';

  @override
  String get navigateBankingDesc => 'Find foreigner-friendly banks';

  @override
  String get navigateVisa => 'Visa';

  @override
  String get navigateVisaDesc => 'Visa procedures & documents';

  @override
  String get navigateScanner => 'Scanner';

  @override
  String get navigateScannerDesc => 'Translate Japanese documents';

  @override
  String get navigateMedical => 'Medical';

  @override
  String get navigateMedicalDesc => 'Emergency guide & phrases';

  @override
  String get navigateCommunity => 'Community';

  @override
  String get navigateCommunityDesc => 'Q&A with other foreigners';

  @override
  String get upgradeToPremium => 'Upgrade to Premium';

  @override
  String get communityTitle => 'Community Q&A';

  @override
  String get communityEmpty => 'No posts yet';

  @override
  String get communityNewPost => 'New Post';

  @override
  String get communityDetailTitle => 'Post Detail';

  @override
  String get communityAnswered => 'Answered';

  @override
  String get communityBestAnswer => 'Best Answer';

  @override
  String get communityFilterAll => 'All';

  @override
  String get communitySortNewest => 'Newest';

  @override
  String get communitySortPopular => 'Popular';

  @override
  String get communityCategoryVisa => 'Visa';

  @override
  String get communityCategoryHousing => 'Housing';

  @override
  String get communityCategoryBanking => 'Banking';

  @override
  String get communityCategoryWork => 'Work';

  @override
  String get communityCategoryDailyLife => 'Daily Life';

  @override
  String get communityCategoryMedical => 'Medical';

  @override
  String get communityCategoryEducation => 'Education';

  @override
  String get communityCategoryTax => 'Tax';

  @override
  String get communityCategoryOther => 'Other';

  @override
  String communityReplies(int count) {
    return '$count Replies';
  }

  @override
  String get communityNoReplies => 'No replies yet. Be the first to answer!';

  @override
  String get communityReplyHint => 'Write a reply...';

  @override
  String get communityReplyPremiumOnly =>
      'Posting and replying requires a Premium subscription.';

  @override
  String communityVoteCount(int count) {
    return '$count votes';
  }

  @override
  String get communityModerationPending => 'Under review';

  @override
  String get communityModerationFlagged => 'Flagged for review';

  @override
  String get communityModerationNotice =>
      'Your post will be reviewed by our AI moderation system before it becomes visible to others.';

  @override
  String get communityChannelLabel => 'Language Channel';

  @override
  String get communityCategoryLabel => 'Category';

  @override
  String get communityTitleLabel => 'Title';

  @override
  String get communityTitleHint => 'What\'s your question?';

  @override
  String get communityTitleMinLength => 'Title must be at least 5 characters';

  @override
  String get communityContentLabel => 'Details';

  @override
  String get communityContentHint =>
      'Describe your question or situation in detail...';

  @override
  String get communityContentMinLength =>
      'Content must be at least 10 characters';

  @override
  String get communitySubmit => 'Post';

  @override
  String communityTimeAgoDays(int days) {
    return '${days}d ago';
  }

  @override
  String communityTimeAgoHours(int hours) {
    return '${hours}h ago';
  }

  @override
  String communityTimeAgoMinutes(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String get subscriptionTitle => 'Subscription';

  @override
  String get subscriptionPlansTitle => 'Choose Your Plan';

  @override
  String get subscriptionPlansSubtitle =>
      'Unlock the full potential of Gaijin Life Navi';

  @override
  String get subscriptionCurrentPlan => 'Current Plan';

  @override
  String get subscriptionCurrentPlanBadge => 'Current Plan';

  @override
  String get subscriptionTierFree => 'Free';

  @override
  String get subscriptionTierPremium => 'Premium';

  @override
  String get subscriptionTierPremiumPlus => 'Premium+';

  @override
  String get subscriptionFreePrice => '¥0';

  @override
  String subscriptionPricePerMonth(int price) {
    return '¥$price/month';
  }

  @override
  String get subscriptionCheckout => 'Subscribe Now';

  @override
  String get subscriptionRecommended => 'RECOMMENDED';

  @override
  String get subscriptionCancelling => 'Cancelling...';

  @override
  String subscriptionCancellingAt(String date) {
    return 'Your plan will end on $date';
  }

  @override
  String get subscriptionFeatureFreeChat => '5 AI chats per day';

  @override
  String get subscriptionFeatureFreeScans => '3 document scans per month';

  @override
  String get subscriptionFeatureFreeTracker => 'Track up to 3 procedures';

  @override
  String get subscriptionFeatureFreeCommunityRead => 'Read community posts';

  @override
  String get subscriptionFeatureCommunityPost => 'Post & reply in community';

  @override
  String get subscriptionFeatureUnlimitedChat => 'Unlimited AI chats';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileEditTitle => 'Edit Profile';

  @override
  String get profileEdit => 'Edit Profile';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileNationality => 'Nationality';

  @override
  String get profileResidenceStatus => 'Residence Status';

  @override
  String get profileRegion => 'Region';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileArrivalDate => 'Arrival Date';

  @override
  String get profileDisplayName => 'Display Name';

  @override
  String get profileNoName => 'No Name';

  @override
  String get profileNameTooLong => 'Name must be 100 characters or less';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get profileSaveButton => 'Save';

  @override
  String get profileSaveError => 'Failed to save profile';

  @override
  String get profileLoadError => 'Failed to load profile';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguageSection => 'Language';

  @override
  String get settingsAccountSection => 'Account';

  @override
  String get settingsAboutSection => 'About';

  @override
  String get settingsLogout => 'Log Out';

  @override
  String get settingsDeleteAccount => 'Delete Account';

  @override
  String get settingsDeleteAccountSubtitle => 'This action cannot be undone';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsLogoutConfirmTitle => 'Log Out';

  @override
  String get settingsLogoutConfirmMessage =>
      'Are you sure you want to log out?';

  @override
  String get settingsDeleteConfirmTitle => 'Delete Account';

  @override
  String get settingsDeleteConfirmMessage =>
      'Are you sure you want to delete your account? This action cannot be undone. All your data will be permanently removed.';

  @override
  String get settingsDeleteError => 'Failed to delete account';

  @override
  String get settingsCancel => 'Cancel';

  @override
  String get settingsDelete => 'Delete';

  @override
  String get settingsConfirm => 'Confirm';
}
