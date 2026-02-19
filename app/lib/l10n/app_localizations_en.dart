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
  String get loginWelcome => 'Sign in to your account';

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
  String get tabChat => 'AI Guide';

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
    return 'Free • $remaining/$limit chats remaining';
  }

  @override
  String get homeSectionQuickActions => 'Quick Actions';

  @override
  String get homeSectionExplore => 'Explore';

  @override
  String get homeTrackerSummary => 'My To-Dos';

  @override
  String get homePopularGuides => 'Popular Guides';

  @override
  String get homeTrackerNoItems => 'No to-dos yet. Tap to add one.';

  @override
  String get homeQaChatTitle => 'Talk to AI Guide';

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
  String get chatTitle => 'AI Guide';

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
    return '$remaining/$limit free chats remaining.';
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
  String get trackerTitle => 'To-Do';

  @override
  String get trackerAddItem => 'New To-Do';

  @override
  String get trackerNoItems => 'No to-dos yet';

  @override
  String get trackerNoItemsHint => 'Tap + to add your first to-do';

  @override
  String get trackerAddTitle => 'Title';

  @override
  String get trackerAddMemo => 'Memo (optional)';

  @override
  String get trackerAddDueDate => 'Due date (optional)';

  @override
  String get trackerDueToday => 'Due today';

  @override
  String get trackerOverdue => 'Overdue';

  @override
  String get trackerViewAll => 'View all →';

  @override
  String get trackerDeleteTitle => 'Delete To-Do';

  @override
  String get trackerDeleteConfirm =>
      'Are you sure you want to delete this to-do?';

  @override
  String get trackerLimitReached =>
      'Free plan allows up to 3 to-dos. Upgrade for unlimited.';

  @override
  String get trackerAlreadyTracking =>
      'This item is already in your to-do list';

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
  String get subscriptionFeatureFreeChat => '20 free AI chats on signup';

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

  @override
  String get navTitle => 'Guide';

  @override
  String get navSubtitle =>
      'Explore topics to help you navigate life in Japan.';

  @override
  String navGuideCount(int count) {
    return '$count guides';
  }

  @override
  String get navGuideCountOne => '1 guide';

  @override
  String get navComingSoon => 'Coming Soon';

  @override
  String get navComingSoonSnackbar => 'Coming soon! We\'re working on it.';

  @override
  String get navErrorLoad => 'Unable to load guides.';

  @override
  String get navErrorRetry => 'Tap to retry';

  @override
  String get domainBanking => 'Banking & Finance';

  @override
  String get domainVisa => 'Visa & Immigration';

  @override
  String get domainMedical => 'Medical & Health';

  @override
  String get domainConcierge => 'Life & General';

  @override
  String get domainHousing => 'Housing & Utilities';

  @override
  String get domainEmployment => 'Employment & Tax';

  @override
  String get domainEducation => 'Education & Childcare';

  @override
  String get domainLegal => 'Legal & Insurance';

  @override
  String get guideSearchPlaceholder => 'Search guides...';

  @override
  String get guideComingSoonTitle => 'Coming Soon';

  @override
  String guideComingSoonSubtitle(String domain) {
    return 'We\'re working on $domain guides. Check back soon!';
  }

  @override
  String guideComingSoonAskAi(String domain) {
    return 'Ask AI about $domain';
  }

  @override
  String guideSearchEmpty(String query) {
    return 'No guides found for \"$query\".';
  }

  @override
  String get guideSearchTry => 'Try a different search term.';

  @override
  String get guideErrorLoad => 'Unable to load guides for this category.';

  @override
  String get guideAskAi => 'Ask AI about this topic';

  @override
  String get guideDisclaimer =>
      'This is general information and does not constitute legal advice. Please verify with relevant authorities.';

  @override
  String get guideShare => 'Share';

  @override
  String get guideErrorNotFound => 'This guide is no longer available.';

  @override
  String get guideErrorLoadDetail =>
      'Unable to load this guide. Please try again.';

  @override
  String get guideErrorRetryBack => 'Go back';

  @override
  String get emergencyTitle => 'Emergency';

  @override
  String get emergencyWarning =>
      'If you are in immediate danger, call 110 (Police) or 119 (Fire/Ambulance) immediately.';

  @override
  String get emergencySectionContacts => 'Emergency Contacts';

  @override
  String get emergencySectionAmbulance => 'How to Call an Ambulance';

  @override
  String get emergencySectionMoreHelp => 'Need more help?';

  @override
  String get emergencyPoliceName => 'Police';

  @override
  String get emergencyPoliceNumber => '110';

  @override
  String get emergencyFireName => 'Fire / Ambulance';

  @override
  String get emergencyFireNumber => '119';

  @override
  String get emergencyMedicalName => 'Medical Consultation';

  @override
  String get emergencyMedicalNumber => '#7119';

  @override
  String get emergencyMedicalNote => 'Non-emergency medical advice';

  @override
  String get emergencyTellName => 'TELL Japan (Mental Health)';

  @override
  String get emergencyTellNumber => '03-5774-0992';

  @override
  String get emergencyTellNote => 'Counseling in English';

  @override
  String get emergencyHelplineName => 'Japan Helpline';

  @override
  String get emergencyHelplineNumber => '0570-064-211';

  @override
  String get emergencyHelplineNote => '24 hours, multilingual';

  @override
  String get emergencyStep1 => 'Call 119';

  @override
  String get emergencyStep2 =>
      'Say \"Kyuukyuu desu\" (救急です — It\'s an emergency)';

  @override
  String get emergencyStep3 =>
      'Explain your location (address, nearby landmarks)';

  @override
  String get emergencyStep4 =>
      'Describe the situation (what happened, symptoms)';

  @override
  String get emergencyStep5 =>
      'Wait for the ambulance at the entrance of your building';

  @override
  String get emergencyPhraseEmergencyHelp => 'It\'s an emergency';

  @override
  String get emergencyPhraseHelpHelp => 'Please help';

  @override
  String get emergencyPhraseAmbulanceHelp => 'Please send an ambulance';

  @override
  String get emergencyPhraseAddressHelp => 'The address is ○○';

  @override
  String get emergencyAskAi => 'Chat with AI about emergency situations';

  @override
  String get emergencyDisclaimer =>
      'This guide provides general health information and is not a substitute for professional medical advice. In an emergency, call 119 immediately.';

  @override
  String get emergencyCallButton => 'Call';

  @override
  String get emergencyOffline =>
      'Unable to load additional information. Call 110 or 119 if you need help.';

  @override
  String get subTitle => 'Subscription';

  @override
  String get subSectionCurrent => 'Current Plan';

  @override
  String get subSectionChoose => 'Choose a Plan';

  @override
  String get subSectionCharge => 'Need More Chats?';

  @override
  String get subSectionFaq => 'FAQ';

  @override
  String get subCurrentFree => 'Free Plan';

  @override
  String get subCurrentStandard => 'Standard Plan';

  @override
  String get subCurrentPremium => 'Premium Plan';

  @override
  String get subUpgradeNow => 'Upgrade Now';

  @override
  String get subPlanFree => 'Free';

  @override
  String get subPlanStandard => 'Standard';

  @override
  String get subPlanPremium => 'Premium';

  @override
  String get subPriceFree => '¥0';

  @override
  String get subPriceStandard => '¥720';

  @override
  String get subPricePremium => '¥1,360';

  @override
  String get subPriceInterval => '/month';

  @override
  String get subRecommended => 'RECOMMENDED';

  @override
  String get subFeatureChatFree => '20 AI Guide chats on signup';

  @override
  String get subFeatureChatStandard => '300 AI Guide chats/month';

  @override
  String get subFeatureChatPremium => 'Unlimited AI Guide chats';

  @override
  String get subFeatureTrackerFree => 'Up to 3 tracker items';

  @override
  String get subFeatureTrackerPaid => 'Unlimited tracker items';

  @override
  String get subFeatureAdsYes => 'Contains ads';

  @override
  String get subFeatureAdsNo => 'No ads';

  @override
  String get subFeatureGuideFree => 'Browse selected guides';

  @override
  String get subFeatureGuidePaid => 'Browse all guides';

  @override
  String get subFeatureImageNo => 'AI image analysis (in chat)';

  @override
  String get subFeatureImageYes => 'AI image analysis (in chat)';

  @override
  String get subButtonCurrent => 'Current Plan';

  @override
  String subButtonChoose(String plan) {
    return 'Choose $plan';
  }

  @override
  String get subCharge100 => '100 Chats Pack';

  @override
  String get subCharge50 => '50 Chats Pack';

  @override
  String get subCharge100Price => '¥360 (¥3.6/chat)';

  @override
  String get subCharge50Price => '¥180 (¥3.6/chat)';

  @override
  String get subChargeDescription =>
      'Extra chats that never expire. Used after your plan\'s limit.';

  @override
  String get subFaqBillingQ => 'How does billing work?';

  @override
  String get subFaqBillingA =>
      'Subscriptions are billed monthly through the App Store or Google Play. You can manage your subscription in your device settings.';

  @override
  String get subFaqCancelQ => 'Can I cancel anytime?';

  @override
  String get subFaqCancelA =>
      'Yes! You can cancel anytime. Your plan will remain active until the end of the billing period.';

  @override
  String get subFaqDowngradeQ => 'What happens when I downgrade?';

  @override
  String get subFaqDowngradeA =>
      'When you downgrade, you\'ll keep your current plan benefits until the end of the billing period. Then your plan will switch to the new tier.';

  @override
  String get subFooter => 'Subscription managed via App Store / Google Play';

  @override
  String subPurchaseSuccess(String plan) {
    return 'Welcome to $plan! Your upgrade is now active.';
  }

  @override
  String get subPurchaseError =>
      'Unable to complete purchase. Please try again.';

  @override
  String get subErrorLoad => 'Unable to load subscription plans.';

  @override
  String get subErrorRetry => 'Tap to retry';

  @override
  String get profileSectionInfo => 'Your Information';

  @override
  String get profileSectionStats => 'Usage Statistics';

  @override
  String get profileChatsToday => 'Chats today';

  @override
  String get profileMemberSince => 'Member since';

  @override
  String get profileManageSubscription => 'Manage Subscription';

  @override
  String get profileNotSet => 'Not set';

  @override
  String get editTitle => 'Edit Profile';

  @override
  String get editSave => 'Save';

  @override
  String get editNameLabel => 'Display Name';

  @override
  String get editNameHint => 'Enter your name';

  @override
  String get editNationalityLabel => 'Nationality';

  @override
  String get editNationalityHint => 'Select your nationality';

  @override
  String get editStatusLabel => 'Residence Status';

  @override
  String get editStatusHint => 'Select your status';

  @override
  String get editRegionLabel => 'Region';

  @override
  String get editRegionHint => 'Select your region';

  @override
  String get editLanguageLabel => 'Preferred Language';

  @override
  String get editChangePhoto => 'Change photo';

  @override
  String get editSuccess => 'Profile updated successfully.';

  @override
  String get editError => 'Unable to update profile. Please try again.';

  @override
  String get editUnsavedTitle => 'Unsaved changes';

  @override
  String get editUnsavedMessage => 'You have unsaved changes. Discard them?';

  @override
  String get editUnsavedDiscard => 'Discard';

  @override
  String get editUnsavedKeep => 'Keep editing';

  @override
  String get settingsSectionGeneral => 'General';

  @override
  String get settingsSectionAccount => 'Account';

  @override
  String get settingsSectionDanger => 'Danger Zone';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsSubscription => 'Subscription';

  @override
  String get settingsTerms => 'Terms of Service';

  @override
  String get settingsPrivacy => 'Privacy Policy';

  @override
  String get settingsContact => 'Contact Us';

  @override
  String get settingsFooter =>
      'Made with ❤️ for everyone navigating life in Japan';

  @override
  String get settingsLogoutTitle => 'Log Out';

  @override
  String get settingsLogoutMessage => 'Are you sure you want to log out?';

  @override
  String get settingsLogoutConfirm => 'Log Out';

  @override
  String get settingsLogoutCancel => 'Cancel';

  @override
  String get settingsDeleteTitle => 'Delete Account';

  @override
  String get settingsDeleteMessage =>
      'This action cannot be undone. All your data will be permanently deleted. Are you sure?';

  @override
  String get settingsDeleteConfirmAction => 'Delete My Account';

  @override
  String get settingsDeleteCancel => 'Cancel';

  @override
  String get settingsDeleteSuccess => 'Your account has been deleted.';

  @override
  String get settingsLanguageTitle => 'Choose Language';

  @override
  String get settingsErrorLogout => 'Unable to log out. Please try again.';

  @override
  String get settingsErrorDelete =>
      'Unable to delete account. Please try again.';

  @override
  String get chatGuestTitle => 'Ask AI anything about life in Japan';

  @override
  String get chatGuestFeature1 => 'How to open a bank account';

  @override
  String get chatGuestFeature2 => 'Visa renewal procedures';

  @override
  String get chatGuestFeature3 => 'How to visit a hospital';

  @override
  String get chatGuestFeature4 => 'And anything else';

  @override
  String get chatGuestFreeOffer => 'Free signup — 20 chats included';

  @override
  String get chatGuestSignUp => 'Get started free';

  @override
  String get chatGuestLogin => 'Already have an account? Log in';

  @override
  String get guestRegisterCta => 'Sign up free to use AI Chat';

  @override
  String get guideReadMore => 'Sign up to read the full guide';

  @override
  String get guideAskAI => 'Ask AI for details';

  @override
  String get guideGuestCtaButton => 'Create Free Account';

  @override
  String get homeGuestCtaText =>
      'Create your free account to unlock AI chat and personalized guides';

  @override
  String get homeGuestCtaButton => 'Get Started';

  @override
  String get chatUpgradeBanner => 'Upgrade to Premium for unlimited chat';

  @override
  String get chatUpgradeButton => 'View Plans';

  @override
  String get guidePremiumCta =>
      'This content is available with a Premium subscription';

  @override
  String get guidePremiumCtaButton => 'View Plans';

  @override
  String get guideTierLimitError => 'Upgrade to access the full guide content';

  @override
  String get trackerSave => 'Save';

  @override
  String get trackerSaved => 'Saved';

  @override
  String get trackerItemSaved => 'Added to to-do list';

  @override
  String get homeQaTrackerTitle => 'To-Do';

  @override
  String get homeQaTrackerSubtitle => 'Manage your to-do list';

  @override
  String get chatAttachPhoto => 'Take Photo';

  @override
  String get chatAttachGallery => 'Choose from Gallery';

  @override
  String get chatAttachCancel => 'Cancel';

  @override
  String get chatImageTooLarge => 'Image is too large (max 5MB)';

  @override
  String get profilePersonalizationHint =>
      'The AI guide will provide more personalized advice based on your completed profile';

  @override
  String get profileVisaExpiry => 'Visa Expiry';

  @override
  String get profileResidenceRegion => 'Residence Area';

  @override
  String get profilePreferredLanguage => 'Preferred Language';

  @override
  String get profileSelectNationality => 'Select Nationality';

  @override
  String get profileSelectResidenceStatus => 'Select Residence Status';

  @override
  String get profileSelectPrefecture => 'Select Prefecture';

  @override
  String get profileSelectCity => 'Select City';

  @override
  String get profileSelectLanguage => 'Select Language';

  @override
  String get profileCommonStatuses => 'Common';

  @override
  String get profileOtherStatuses => 'Other';

  @override
  String get profileSearchNationality => 'Search nationality';

  @override
  String get visaRenewalPrepTitle => 'Prepare visa renewal application';

  @override
  String get visaRenewalDeadlineTitle => 'Visa renewal deadline';

  @override
  String get profileSave => 'Save';

  @override
  String get profileUsageStats => 'Usage Statistics';

  @override
  String get profileLogout => 'Log Out';

  @override
  String get profileDeleteAccount => 'Delete Account';

  @override
  String get subUsageTitle => 'Your Usage';

  @override
  String subUsageCount(int used, int limit) {
    return 'Used $used / $limit chats';
  }

  @override
  String get subUsageUnlimited => 'Unlimited chats';
}
