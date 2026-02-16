// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '외국인 생활 내비';

  @override
  String get languageSelectionTitle => '언어를 선택하세요';

  @override
  String get languageSelectionSubtitle => '나중에 설정에서 변경할 수 있습니다';

  @override
  String get continueButton => '계속';

  @override
  String get loginTitle => '다시 오신 것을 환영합니다';

  @override
  String get loginSubtitle => '계정에 로그인하세요';

  @override
  String get emailLabel => '이메일';

  @override
  String get passwordLabel => '비밀번호';

  @override
  String get loginButton => '로그인';

  @override
  String get forgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get noAccount => '계정이 없으신가요?';

  @override
  String get signUp => '회원가입';

  @override
  String get registerTitle => '계정 만들기';

  @override
  String get registerSubtitle => '자신감 있게 일본 생활을 시작하세요';

  @override
  String get confirmPasswordLabel => '비밀번호 확인';

  @override
  String get registerButton => '계정 만들기';

  @override
  String get hasAccount => '이미 계정이 있으신가요?';

  @override
  String get signIn => '로그인';

  @override
  String get resetPasswordTitle => '비밀번호 재설정';

  @override
  String get resetPasswordSubtitle => '재설정 링크를 받을 이메일을 입력하세요';

  @override
  String get sendResetLink => '재설정 링크 보내기';

  @override
  String get backToLogin => '로그인으로 돌아가기';

  @override
  String get resetPasswordSuccess => '비밀번호 재설정 이메일이 전송되었습니다. 받은 편지함을 확인하세요.';

  @override
  String get emailRequired => '이메일을 입력해주세요';

  @override
  String get emailInvalid => '유효한 이메일을 입력해주세요';

  @override
  String get passwordRequired => '비밀번호를 입력해주세요';

  @override
  String get passwordTooShort => '비밀번호는 최소 8자 이상이어야 합니다';

  @override
  String get passwordMismatch => '비밀번호가 일치하지 않습니다';

  @override
  String get tabHome => '홈';

  @override
  String get tabChat => '채팅';

  @override
  String get tabTracker => '추적';

  @override
  String get tabNavigate => '탐색';

  @override
  String get tabProfile => '프로필';

  @override
  String get homeWelcome => '외국인 생활 내비에 오신 것을 환영합니다';

  @override
  String get homeSubtitle => '일본 생활 가이드';

  @override
  String get homeQuickActions => '빠른 실행';

  @override
  String get homeActionAskAI => 'AI에게 질문';

  @override
  String get homeActionTracker => '추적기';

  @override
  String get homeActionBanking => '은행';

  @override
  String get homeActionChatHistory => '채팅 기록';

  @override
  String get homeRecentChats => '최근 채팅';

  @override
  String get homeNoRecentChats => '아직 채팅 기록이 없습니다';

  @override
  String get homeMessagesLabel => '개 메시지';

  @override
  String get chatPlaceholder => 'AI 채팅 — 곧 출시';

  @override
  String get chatTitle => 'AI 채팅';

  @override
  String get chatNewSession => '새 채팅';

  @override
  String get chatEmptyTitle => '대화를 시작하세요';

  @override
  String get chatEmptySubtitle => '일본 생활에 대해 AI에게 무엇이든 물어보세요';

  @override
  String get chatUntitledSession => '새 대화';

  @override
  String get chatConversationTitle => '대화';

  @override
  String get chatInputHint => '일본 생활에 대해 질문하세요...';

  @override
  String get chatTyping => '생각 중...';

  @override
  String get chatSources => '출처';

  @override
  String get chatRetry => '다시 시도';

  @override
  String get chatDeleteTitle => '채팅 삭제';

  @override
  String get chatDeleteConfirm => '이 채팅을 삭제하시겠습니까?';

  @override
  String get chatDeleteCancel => '취소';

  @override
  String get chatDeleteAction => '삭제';

  @override
  String get chatLimitReached => '일일 한도 도달';

  @override
  String chatRemainingCount(int remaining, int limit) {
    return '남은 횟수 $remaining/$limit';
  }

  @override
  String get chatLimitReachedTitle => '일일 한도에 도달했습니다';

  @override
  String get chatLimitReachedMessage =>
      '오늘의 무료 채팅을 모두 사용했습니다. 프리미엄으로 업그레이드하면 무제한으로 이용할 수 있습니다.';

  @override
  String get chatUpgradeToPremium => '프리미엄으로 업그레이드';

  @override
  String get chatWelcomePrompt => '오늘 무엇을 도와드릴까요?';

  @override
  String get chatWelcomeHint => '비자 절차, 은행, 주거 또는 일본 생활에 관한 모든 것을 물어보세요.';

  @override
  String get onboardingTitle => '프로필 설정';

  @override
  String get onboardingSkip => '건너뛰기';

  @override
  String get onboardingNext => '다음';

  @override
  String get onboardingComplete => '완료';

  @override
  String onboardingStepOf(int current, int total) {
    return '$total단계 중 $current단계';
  }

  @override
  String get onboardingNationalityTitle => '국적이 어떻게 되시나요?';

  @override
  String get onboardingNationalitySubtitle => '귀하의 상황에 맞는 정보를 제공하는 데 도움이 됩니다.';

  @override
  String get onboardingResidenceStatusTitle => '재류 자격은 무엇인가요?';

  @override
  String get onboardingResidenceStatusSubtitle => '현재 일본에서의 비자 유형을 선택하세요.';

  @override
  String get onboardingRegionTitle => '어디에 살고 계신가요?';

  @override
  String get onboardingRegionSubtitle => '현재 거주하거나 이사할 예정인 지역을 선택하세요.';

  @override
  String get onboardingArrivalDateTitle => '일본에 언제 도착하셨나요?';

  @override
  String get onboardingArrivalDateSubtitle => '관련 절차와 기한을 제안하는 데 도움이 됩니다.';

  @override
  String get onboardingSelectDate => '날짜 선택';

  @override
  String get onboardingChangeDate => '날짜 변경';

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
  String get visaEngineer => '기술·인문지식·국제업무';

  @override
  String get visaStudent => '유학';

  @override
  String get visaDependent => '가족체재';

  @override
  String get visaPermanent => '영주자';

  @override
  String get visaSpouse => '일본인 배우자';

  @override
  String get visaWorkingHoliday => '워킹홀리데이';

  @override
  String get visaSpecifiedSkilled => '특정기능';

  @override
  String get visaTechnicalIntern => '기능실습';

  @override
  String get visaHighlySkilled => '고도전문직';

  @override
  String get visaOther => '기타';

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
  String get trackerPlaceholder => '행정 추적 — 곧 출시';

  @override
  String get navigatePlaceholder => '탐색 — 곧 출시';

  @override
  String get profilePlaceholder => '프로필 — 곧 출시';

  @override
  String get genericError => '문제가 발생했습니다. 다시 시도해주세요.';

  @override
  String get networkError => '네트워크 오류. 연결을 확인해주세요.';

  @override
  String get logout => '로그아웃';

  @override
  String get bankingTitle => '은행 가이드';

  @override
  String get bankingFriendlyScore => '외국인 친화 점수';

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
  String get bankingRecommendHint => '우선순위를 선택하고 추천 받기를 눌러주세요';

  @override
  String get bankingNoRecommendations => '추천을 찾을 수 없습니다';

  @override
  String get bankingViewGuide => '가이드 보기';

  @override
  String get bankingGuideTitle => '계좌 개설 가이드';

  @override
  String get bankingRequiredDocs => '필요 서류';

  @override
  String get bankingConversationTemplates => '은행에서 유용한 표현';

  @override
  String get bankingTroubleshooting => '문제 해결 팁';

  @override
  String get bankingSource => '출처';

  @override
  String get visaTitle => '비자 가이드';

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
  String get visaProcessingTime => '처리 시간';

  @override
  String get visaDisclaimer =>
      '중요: 이것은 비자 절차에 대한 일반적인 정보이며 이민 조언을 구성하지 않습니다. 이민법과 절차는 변경될 수 있습니다. 구체적인 상황은 출입국관리국 또는 자격을 갖춘 행정서사(行政書士)에게 문의하세요.';

  @override
  String get trackerTitle => '행정 추적';

  @override
  String get trackerEmpty => '추적 중인 절차 없음';

  @override
  String get trackerEmptyHint => '+ 를 눌러 추적할 절차를 추가하세요';

  @override
  String get trackerAddProcedure => '절차 추가';

  @override
  String get trackerStatusNotStarted => '시작 전';

  @override
  String get trackerStatusInProgress => '진행 중';

  @override
  String get trackerStatusCompleted => '완료';

  @override
  String get trackerDueDate => '마감일';

  @override
  String get trackerFreeLimitInfo => '무료 플랜: 최대 3개 절차. 업그레이드하면 무제한.';

  @override
  String get trackerDetailTitle => '절차 상세';

  @override
  String get trackerCurrentStatus => '현재 상태';

  @override
  String get trackerNotes => '메모';

  @override
  String get trackerChangeStatus => '상태 변경';

  @override
  String get trackerMarkInProgress => '진행 중으로 변경';

  @override
  String get trackerMarkCompleted => '완료로 변경';

  @override
  String get trackerMarkIncomplete => '미완료로 변경';

  @override
  String get trackerStatusUpdated => '상태 업데이트됨';

  @override
  String get trackerDeleteTitle => '절차 삭제';

  @override
  String get trackerDeleteConfirm => '이 절차를 추적에서 삭제하시겠습니까?';

  @override
  String get trackerProcedureAdded => '절차가 추적에 추가되었습니다';

  @override
  String get trackerLimitReached => '무료 플랜 한도 도달 (3개 절차). 프리미엄으로 업그레이드하면 무제한.';

  @override
  String get trackerAlreadyTracking => '이미 이 절차를 추적 중입니다';

  @override
  String get trackerEssentialProcedures => '필수 (도착 후)';

  @override
  String get trackerOtherProcedures => '기타 절차';

  @override
  String get trackerNoTemplates => '사용 가능한 절차 템플릿 없음';

  @override
  String get scannerTitle => '문서 스캐너';

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
  String get scannerHistoryEmpty => '아직 스캔 기록이 없습니다';

  @override
  String get scannerUnknownType => '알 수 없는 문서';

  @override
  String get scannerResultTitle => '스캔 결과';

  @override
  String get scannerOriginalText => '원본 텍스트 (일본어)';

  @override
  String get scannerTranslation => '번역';

  @override
  String get scannerExplanation => '이것이 의미하는 바';

  @override
  String get scannerProcessing => '문서를 처리 중...';

  @override
  String get scannerRefresh => '새로고침';

  @override
  String get scannerFailed => '스캔 실패. 다시 시도해주세요.';

  @override
  String get scannerFreeLimitInfo => '무료 플랜: 월 3회 스캔. 업그레이드하면 더 많이.';

  @override
  String get scannerLimitReached =>
      '월간 스캔 한도에 도달했습니다. 프리미엄으로 업그레이드하면 더 많은 스캔이 가능합니다.';

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
  String get medicalWhatToPrepare => '준비 사항';

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
  String get medicalNoPhrases => '표현을 찾을 수 없습니다';

  @override
  String get medicalDisclaimer =>
      '이 가이드는 일반적인 건강 정보를 제공하며 전문적인 의료 조언을 대체하지 않습니다. 응급 상황에서는 즉시 119에 전화하세요.';

  @override
  String get navigateBanking => '은행';

  @override
  String get navigateBankingDesc => '외국인 친화적인 은행 찾기';

  @override
  String get navigateVisa => '비자';

  @override
  String get navigateVisaDesc => '비자 절차 및 서류';

  @override
  String get navigateScanner => '스캐너';

  @override
  String get navigateScannerDesc => '일본어 문서 번역';

  @override
  String get navigateMedical => '의료';

  @override
  String get navigateMedicalDesc => '응급 가이드 및 표현';
}
