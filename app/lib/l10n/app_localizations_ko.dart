// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Gaijin Life Navi';

  @override
  String get langTitle => '언어를 선택하세요';

  @override
  String get langContinue => '계속';

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
  String get loginWelcome => '다시 오신 것을 환영합니다';

  @override
  String get loginSubtitle => '로그인하여 계속하기';

  @override
  String get loginEmailLabel => '이메일';

  @override
  String get loginEmailHint => 'your@email.com';

  @override
  String get loginPasswordLabel => '비밀번호';

  @override
  String get loginPasswordHint => '비밀번호를 입력하세요';

  @override
  String get loginForgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get loginButton => '로그인';

  @override
  String get loginNoAccount => '계정이 없으신가요?';

  @override
  String get loginSignUp => '회원가입';

  @override
  String get loginErrorInvalidEmail => '유효한 이메일 주소를 입력해주세요.';

  @override
  String get loginErrorInvalidCredentials =>
      '이메일 또는 비밀번호가 올바르지 않습니다. 다시 시도해주세요.';

  @override
  String get loginErrorNetwork => '연결할 수 없습니다. 인터넷 연결을 확인해주세요.';

  @override
  String get loginErrorTooManyAttempts => '시도 횟수가 너무 많습니다. 나중에 다시 시도해주세요.';

  @override
  String get registerTitle => '계정 만들기';

  @override
  String get registerSubtitle => '일본에서의 여정을 시작하세요';

  @override
  String get registerEmailLabel => '이메일';

  @override
  String get registerEmailHint => 'your@email.com';

  @override
  String get registerPasswordLabel => '비밀번호';

  @override
  String get registerPasswordHint => '비밀번호를 만드세요';

  @override
  String get registerPasswordHelper => '8자 이상';

  @override
  String get registerConfirmLabel => '비밀번호 확인';

  @override
  String get registerConfirmHint => '비밀번호를 다시 입력하세요';

  @override
  String get registerTermsAgree => '에 동의합니다 ';

  @override
  String get registerTermsLink => '서비스 이용약관';

  @override
  String get registerPrivacyAnd => '및';

  @override
  String get registerPrivacyLink => '개인정보 처리방침';

  @override
  String get registerButton => '계정 만들기';

  @override
  String get registerHasAccount => '이미 계정이 있으신가요?';

  @override
  String get registerSignIn => '로그인';

  @override
  String get registerErrorEmailInvalid => '유효한 이메일 주소를 입력해주세요.';

  @override
  String get registerErrorEmailInUse => '이미 등록된 이메일입니다. 로그인을 시도해보세요.';

  @override
  String get registerErrorPasswordShort => '비밀번호는 8자 이상이어야 합니다.';

  @override
  String get registerErrorPasswordMismatch => '비밀번호가 일치하지 않습니다.';

  @override
  String get registerErrorTermsRequired => '서비스 이용약관에 동의해주세요.';

  @override
  String get resetTitle => '비밀번호 재설정';

  @override
  String get resetSubtitle => '이메일을 입력하면 재설정 링크를 보내드립니다.';

  @override
  String get resetEmailLabel => '이메일';

  @override
  String get resetEmailHint => 'your@email.com';

  @override
  String get resetButton => '재설정 링크 보내기';

  @override
  String get resetBackToLogin => '로그인으로 돌아가기';

  @override
  String get resetSuccessTitle => '이메일을 확인하세요';

  @override
  String resetSuccessSubtitle(String email) {
    return '$email로 재설정 링크를 보냈습니다';
  }

  @override
  String get resetResend => '받지 못하셨나요? 재전송';

  @override
  String get resetErrorEmailInvalid => '유효한 이메일 주소를 입력해주세요.';

  @override
  String get onboardingSkip => '건너뛰기';

  @override
  String get onboardingNext => '다음';

  @override
  String get onboardingGetStarted => '시작하기';

  @override
  String onboardingStepOf(int current, int total) {
    return '$total단계 중 $current단계';
  }

  @override
  String get onboardingS1Title => '국적이 어디인가요?';

  @override
  String get onboardingS1Subtitle => '관련 정보를 제공하는 데 도움이 됩니다.';

  @override
  String get onboardingS2Title => '체류 자격이 무엇인가요?';

  @override
  String get onboardingS2Subtitle => '비자 관련 정보를 맞춤 제공해드립니다.';

  @override
  String get onboardingS3Title => '일본 어디에 살고 계신가요?';

  @override
  String get onboardingS3Subtitle => '지역별 가이드를 제공해드립니다.';

  @override
  String get onboardingS4Title => '일본에 언제 도착하셨나요?';

  @override
  String get onboardingS4Subtitle => '기한이 있는 할 일을 안내해드립니다.';

  @override
  String get onboardingS4Placeholder => '날짜를 선택하세요';

  @override
  String get onboardingS4NotYet => '아직 도착하지 않았습니다';

  @override
  String get onboardingChangeDate => '날짜 변경';

  @override
  String get onboardingErrorSave => '정보를 저장할 수 없습니다. 다시 시도해주세요.';

  @override
  String get statusEngineer => '기술·인문지식·국제업무';

  @override
  String get statusStudent => '유학';

  @override
  String get statusDependent => '가족체재';

  @override
  String get statusPermanent => '영주자';

  @override
  String get statusSpouse => '일본인의 배우자';

  @override
  String get statusWorkingHoliday => '워킹홀리데이';

  @override
  String get statusSpecifiedSkilled => '특정기능';

  @override
  String get statusOther => '기타';

  @override
  String get tabHome => '홈';

  @override
  String get tabChat => '채팅';

  @override
  String get tabGuide => '가이드';

  @override
  String get tabSOS => 'SOS';

  @override
  String get tabProfile => '프로필';

  @override
  String homeGreetingMorning(String name) {
    return '좋은 아침이에요, $name 👋';
  }

  @override
  String homeGreetingAfternoon(String name) {
    return '좋은 오후예요, $name 👋';
  }

  @override
  String homeGreetingEvening(String name) {
    return '좋은 저녁이에요, $name 👋';
  }

  @override
  String homeGreetingDefault(String name) {
    return '안녕하세요, $name 👋';
  }

  @override
  String get homeGreetingNoName => '환영합니다! 👋';

  @override
  String homeUsageFree(int remaining, int limit) {
    return '무료 • 오늘 $remaining/$limit회 채팅 남음';
  }

  @override
  String get homeSectionQuickActions => '빠른 실행';

  @override
  String get homeSectionExplore => '가이드 둘러보기';

  @override
  String get homeQaChatTitle => 'AI 채팅';

  @override
  String get homeQaChatSubtitle => '일본 생활에 대해 무엇이든 물어보세요';

  @override
  String get homeQaBankingTitle => '은행';

  @override
  String get homeQaBankingSubtitle => '계좌 개설, 송금 등';

  @override
  String get homeQaVisaTitle => '비자';

  @override
  String get homeQaVisaSubtitle => '이민 가이드 및 절차';

  @override
  String get homeQaMedicalTitle => '의료';

  @override
  String get homeQaMedicalSubtitle => '건강 가이드 및 응급 정보';

  @override
  String get homeExploreGuides => '모든 가이드 보기';

  @override
  String get homeExploreEmergency => '긴급 연락처';

  @override
  String get homeUpgradeTitle => 'AI 어시스턴트를 더 활용하세요';

  @override
  String get homeUpgradeCta => '지금 업그레이드';

  @override
  String get chatTitle => 'AI 채팅';

  @override
  String get chatInputPlaceholder => '메시지를 입력하세요...';

  @override
  String get chatEmptyTitle => '무엇이든 물어보세요!';

  @override
  String get chatEmptySubtitle => '은행, 비자, 의료 등 일본 생활에 대한 질문에 도움을 드릴 수 있습니다.';

  @override
  String get chatSuggestBank => '은행 계좌는 어떻게 만드나요?';

  @override
  String get chatSuggestVisa => '비자 갱신은 어떻게 하나요?';

  @override
  String get chatSuggestMedical => '병원에 가려면 어떻게 하나요?';

  @override
  String get chatSuggestGeneral => '일본에 도착하면 무엇을 해야 하나요?';

  @override
  String get chatSourcesHeader => '출처';

  @override
  String get chatDisclaimer => '이 정보는 일반적인 안내이며 법적 조언이 아닙니다. 관련 기관에 확인하세요.';

  @override
  String chatLimitRemaining(int remaining, int limit) {
    return '오늘 무료 채팅 $remaining/$limit회 남음.';
  }

  @override
  String get chatLimitUpgrade => '업그레이드';

  @override
  String get chatLimitExhausted => '오늘의 무료 채팅을 모두 사용했습니다. 업그레이드하여 계속하세요!';

  @override
  String get chatErrorSend => '메시지를 보낼 수 없습니다. 다시 시도해주세요.';

  @override
  String get chatErrorRetry => '다시 시도';

  @override
  String get chatDateToday => '오늘';

  @override
  String get chatDateYesterday => '어제';

  @override
  String get chatNewSession => '새 채팅';

  @override
  String get chatUntitledSession => '새 대화';

  @override
  String get chatDeleteTitle => '채팅 삭제';

  @override
  String get chatDeleteConfirm => '이 채팅을 삭제하시겠습니까?';

  @override
  String get chatDeleteCancel => '취소';

  @override
  String get chatDeleteAction => '삭제';

  @override
  String get chatRetry => '다시 시도';

  @override
  String get countryCN => '중국';

  @override
  String get countryVN => '베트남';

  @override
  String get countryKR => '한국';

  @override
  String get countryPH => '필리핀';

  @override
  String get countryBR => '브라질';

  @override
  String get countryNP => '네팔';

  @override
  String get countryID => '인도네시아';

  @override
  String get countryUS => '미국';

  @override
  String get countryTH => '태국';

  @override
  String get countryIN => '인도';

  @override
  String get countryMM => '미얀마';

  @override
  String get countryTW => '대만';

  @override
  String get countryPE => '페루';

  @override
  String get countryGB => '영국';

  @override
  String get countryPK => '파키스탄';

  @override
  String get countryBD => '방글라데시';

  @override
  String get countryLK => '스리랑카';

  @override
  String get countryFR => '프랑스';

  @override
  String get countryDE => '독일';

  @override
  String get countryOther => '기타';

  @override
  String get regionTokyo => '도쿄';

  @override
  String get regionOsaka => '오사카';

  @override
  String get regionNagoya => '나고야';

  @override
  String get regionYokohama => '요코하마';

  @override
  String get regionFukuoka => '후쿠오카';

  @override
  String get regionSapporo => '삿포로';

  @override
  String get regionKobe => '고베';

  @override
  String get regionKyoto => '교토';

  @override
  String get regionSendai => '센다이';

  @override
  String get regionHiroshima => '히로시마';

  @override
  String get regionOther => '기타';

  @override
  String get genericError => '문제가 발생했습니다. 다시 시도해주세요.';

  @override
  String get networkError => '네트워크 오류. 연결을 확인해주세요.';

  @override
  String get logout => '로그아웃';

  @override
  String get bankingTitle => '은행 안내';

  @override
  String get bankingFriendlyScore => '외국인 친화도';

  @override
  String get bankingEmpty => '은행을 찾을 수 없습니다';

  @override
  String get bankingRecommendButton => '추천';

  @override
  String get bankingRecommendTitle => '은행 추천';

  @override
  String get bankingSelectPriorities => '우선순위를 선택하세요';

  @override
  String get bankingPriorityMultilingual => '다국어 지원';

  @override
  String get bankingPriorityLowFee => '낮은 수수료';

  @override
  String get bankingPriorityAtm => 'ATM 네트워크';

  @override
  String get bankingPriorityOnline => '온라인 뱅킹';

  @override
  String get bankingGetRecommendations => '추천 받기';

  @override
  String get bankingRecommendHint => '우선순위를 선택하고 추천 받기를 누르세요';

  @override
  String get bankingNoRecommendations => '추천 결과 없음';

  @override
  String get bankingViewGuide => '가이드 보기';

  @override
  String get bankingGuideTitle => '계좌 개설 가이드';

  @override
  String get bankingRequiredDocs => '필요 서류';

  @override
  String get bankingConversationTemplates => '은행에서 유용한 표현';

  @override
  String get bankingTroubleshooting => '문제 해결';

  @override
  String get bankingSource => '출처';

  @override
  String get visaTitle => '비자 안내';

  @override
  String get visaEmpty => '절차를 찾을 수 없습니다';

  @override
  String get visaFilterAll => '전체';

  @override
  String get visaDetailTitle => '절차 상세';

  @override
  String get visaSteps => '단계';

  @override
  String get visaRequiredDocuments => '필요 서류';

  @override
  String get visaFees => '수수료';

  @override
  String get visaProcessingTime => '처리 기간';

  @override
  String get visaDisclaimer => '중요: 비자 절차에 대한 일반적인 정보이며 이민 조언이 아닙니다.';

  @override
  String get trackerTitle => '행정 추적';

  @override
  String get trackerEmpty => '추적 중인 절차 없음';

  @override
  String get trackerEmptyHint => '+를 눌러 절차를 추가하세요';

  @override
  String get trackerAddProcedure => '절차 추가';

  @override
  String get trackerStatusNotStarted => '미시작';

  @override
  String get trackerStatusInProgress => '진행 중';

  @override
  String get trackerStatusCompleted => '완료';

  @override
  String get trackerDueDate => '마감일';

  @override
  String get trackerFreeLimitInfo => '무료: 최대 3개 절차. 업그레이드하면 무제한.';

  @override
  String get trackerDetailTitle => '절차 상세';

  @override
  String get trackerCurrentStatus => '현재 상태';

  @override
  String get trackerNotes => '메모';

  @override
  String get trackerChangeStatus => '상태 변경';

  @override
  String get trackerMarkInProgress => '진행 중으로 표시';

  @override
  String get trackerMarkCompleted => '완료로 표시';

  @override
  String get trackerMarkIncomplete => '미완료로 표시';

  @override
  String get trackerStatusUpdated => '상태 업데이트됨';

  @override
  String get trackerDeleteTitle => '절차 삭제';

  @override
  String get trackerDeleteConfirm => '이 절차를 삭제하시겠습니까?';

  @override
  String get trackerProcedureAdded => '추적에 추가됨';

  @override
  String get trackerLimitReached => '무료 한도 도달 (3개). 업그레이드하면 무제한.';

  @override
  String get trackerAlreadyTracking => '이미 추적 중인 절차입니다';

  @override
  String get trackerEssentialProcedures => '필수 (도착 후)';

  @override
  String get trackerOtherProcedures => '기타 절차';

  @override
  String get trackerNoTemplates => '절차 템플릿 없음';

  @override
  String get scannerTitle => '문서 스캔';

  @override
  String get scannerDescription => '일본어 문서를 스캔하여 즉시 번역과 설명을 받으세요';

  @override
  String get scannerFromCamera => '카메라로 스캔';

  @override
  String get scannerFromGallery => '갤러리에서 선택';

  @override
  String get scannerHistory => '기록';

  @override
  String get scannerHistoryTitle => '스캔 기록';

  @override
  String get scannerHistoryEmpty => '스캔 기록 없음';

  @override
  String get scannerUnknownType => '알 수 없는 문서';

  @override
  String get scannerResultTitle => '스캔 결과';

  @override
  String get scannerOriginalText => '원문 (일본어)';

  @override
  String get scannerTranslation => '번역';

  @override
  String get scannerExplanation => '의미 설명';

  @override
  String get scannerProcessing => '처리 중...';

  @override
  String get scannerRefresh => '새로고침';

  @override
  String get scannerFailed => '스캔 실패. 다시 시도해주세요.';

  @override
  String get scannerFreeLimitInfo => '무료: 월 3회 스캔. 업그레이드하면 추가.';

  @override
  String get scannerLimitReached => '월간 스캔 한도 도달. 업그레이드하면 추가.';

  @override
  String get medicalTitle => '의료 가이드';

  @override
  String get medicalTabEmergency => '응급';

  @override
  String get medicalTabPhrases => '표현';

  @override
  String get medicalEmergencyNumber => '응급 전화번호';

  @override
  String get medicalHowToCall => '전화 방법';

  @override
  String get medicalWhatToPrepare => '준비물';

  @override
  String get medicalUsefulPhrases => '유용한 표현';

  @override
  String get medicalCategoryAll => '전체';

  @override
  String get medicalCategoryEmergency => '응급';

  @override
  String get medicalCategorySymptom => '증상';

  @override
  String get medicalCategoryInsurance => '보험';

  @override
  String get medicalCategoryGeneral => '일반';

  @override
  String get medicalNoPhrases => '표현을 찾을 수 없음';

  @override
  String get medicalDisclaimer =>
      '이 가이드는 일반적인 건강 정보를 제공하며 전문 의료 조언을 대체하지 않습니다. 응급 상황에서는 즉시 119에 전화하세요.';

  @override
  String get navigateBanking => '은행';

  @override
  String get navigateBankingDesc => '외국인 친화 은행 찾기';

  @override
  String get navigateVisa => '비자';

  @override
  String get navigateVisaDesc => '비자 절차 & 서류';

  @override
  String get navigateScanner => '스캐너';

  @override
  String get navigateScannerDesc => '일본어 문서 번역';

  @override
  String get navigateMedical => '의료';

  @override
  String get navigateMedicalDesc => '응급 가이드 & 표현';

  @override
  String get navigateCommunity => '커뮤니티';

  @override
  String get navigateCommunityDesc => '다른 외국인과 Q&A';

  @override
  String get upgradeToPremium => '프리미엄으로 업그레이드';

  @override
  String get communityTitle => '커뮤니티 Q&A';

  @override
  String get communityEmpty => '게시물 없음';

  @override
  String get communityNewPost => '새 게시물';

  @override
  String get communityDetailTitle => '게시물 상세';

  @override
  String get communityAnswered => '답변됨';

  @override
  String get communityBestAnswer => '베스트 답변';

  @override
  String get communityFilterAll => '전체';

  @override
  String get communitySortNewest => '최신순';

  @override
  String get communitySortPopular => '인기순';

  @override
  String get communityCategoryVisa => '비자';

  @override
  String get communityCategoryHousing => '주거';

  @override
  String get communityCategoryBanking => '은행';

  @override
  String get communityCategoryWork => '취업';

  @override
  String get communityCategoryDailyLife => '일상생활';

  @override
  String get communityCategoryMedical => '의료';

  @override
  String get communityCategoryEducation => '교육';

  @override
  String get communityCategoryTax => '세금';

  @override
  String get communityCategoryOther => '기타';

  @override
  String communityReplies(int count) {
    return '답변 $count개';
  }

  @override
  String get communityNoReplies => '아직 답변이 없습니다. 첫 번째 답변을 남겨보세요!';

  @override
  String get communityReplyHint => '답변 작성...';

  @override
  String get communityReplyPremiumOnly => '게시 및 답변은 프리미엄 구독이 필요합니다.';

  @override
  String communityVoteCount(int count) {
    return '투표 $count개';
  }

  @override
  String get communityModerationPending => '검토 중';

  @override
  String get communityModerationFlagged => '검토 대상';

  @override
  String get communityModerationNotice =>
      '게시물은 AI 검토 시스템을 통해 검토 후 다른 사용자에게 표시됩니다.';

  @override
  String get communityChannelLabel => '언어 채널';

  @override
  String get communityCategoryLabel => '카테고리';

  @override
  String get communityTitleLabel => '제목';

  @override
  String get communityTitleHint => '질문이 무엇인가요?';

  @override
  String get communityTitleMinLength => '제목은 5자 이상이어야 합니다';

  @override
  String get communityContentLabel => '내용';

  @override
  String get communityContentHint => '질문이나 상황을 자세히 설명해주세요...';

  @override
  String get communityContentMinLength => '내용은 10자 이상이어야 합니다';

  @override
  String get communitySubmit => '게시';

  @override
  String communityTimeAgoDays(int days) {
    return '$days일 전';
  }

  @override
  String communityTimeAgoHours(int hours) {
    return '$hours시간 전';
  }

  @override
  String communityTimeAgoMinutes(int minutes) {
    return '$minutes분 전';
  }

  @override
  String get subscriptionTitle => '구독';

  @override
  String get subscriptionPlansTitle => '요금제를 선택하세요';

  @override
  String get subscriptionPlansSubtitle => 'Gaijin Life Navi의 모든 기능을 활용하세요';

  @override
  String get subscriptionCurrentPlan => '현재 요금제';

  @override
  String get subscriptionCurrentPlanBadge => '현재 요금제';

  @override
  String get subscriptionTierFree => '무료';

  @override
  String get subscriptionTierPremium => '프리미엄';

  @override
  String get subscriptionTierPremiumPlus => '프리미엄+';

  @override
  String get subscriptionFreePrice => '¥0';

  @override
  String subscriptionPricePerMonth(int price) {
    return '¥$price/월';
  }

  @override
  String get subscriptionCheckout => '지금 구독';

  @override
  String get subscriptionRecommended => '추천';

  @override
  String get subscriptionCancelling => '해지 중...';

  @override
  String subscriptionCancellingAt(String date) {
    return '요금제가 $date에 종료됩니다';
  }

  @override
  String get subscriptionFeatureFreeChat => '하루 5회 AI 채팅';

  @override
  String get subscriptionFeatureFreeScans => '월 3회 문서 스캔';

  @override
  String get subscriptionFeatureFreeTracker => '최대 3개 절차 추적';

  @override
  String get subscriptionFeatureFreeCommunityRead => '커뮤니티 게시물 읽기';

  @override
  String get subscriptionFeatureCommunityPost => '커뮤니티 게시 & 답변';

  @override
  String get subscriptionFeatureUnlimitedChat => '무제한 AI 채팅';

  @override
  String get profileTitle => '프로필';

  @override
  String get profileEditTitle => '프로필 편집';

  @override
  String get profileEdit => '프로필 편집';

  @override
  String get profileEmail => '이메일';

  @override
  String get profileNationality => '국적';

  @override
  String get profileResidenceStatus => '체류 자격';

  @override
  String get profileRegion => '지역';

  @override
  String get profileLanguage => '언어';

  @override
  String get profileArrivalDate => '도착일';

  @override
  String get profileDisplayName => '표시 이름';

  @override
  String get profileNoName => '이름 없음';

  @override
  String get profileNameTooLong => '이름은 100자 이하여야 합니다';

  @override
  String get profileSaved => '프로필 저장됨';

  @override
  String get profileSaveButton => '저장';

  @override
  String get profileSaveError => '저장 실패';

  @override
  String get profileLoadError => '로딩 실패';

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsLanguageSection => '언어';

  @override
  String get settingsAccountSection => '계정';

  @override
  String get settingsAboutSection => '정보';

  @override
  String get settingsLogout => '로그아웃';

  @override
  String get settingsDeleteAccount => '계정 삭제';

  @override
  String get settingsDeleteAccountSubtitle => '이 작업은 취소할 수 없습니다';

  @override
  String get settingsVersion => '버전';

  @override
  String get settingsLogoutConfirmTitle => '로그아웃';

  @override
  String get settingsLogoutConfirmMessage => '로그아웃하시겠습니까?';

  @override
  String get settingsDeleteConfirmTitle => '계정 삭제';

  @override
  String get settingsDeleteConfirmMessage =>
      '계정을 삭제하시겠습니까? 이 작업은 취소할 수 없습니다. 모든 데이터가 영구적으로 삭제됩니다.';

  @override
  String get settingsDeleteError => '삭제 실패';

  @override
  String get settingsCancel => '취소';

  @override
  String get settingsDelete => '삭제';

  @override
  String get settingsConfirm => '확인';
}
