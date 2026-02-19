// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Gaijin Life Navi';

  @override
  String get langTitle => 'Chọn ngôn ngữ của bạn';

  @override
  String get langContinue => 'Tiếp tục';

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
  String get loginWelcome => 'Đăng nhập tài khoản';

  @override
  String get loginSubtitle => 'Đăng nhập để tiếp tục';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'your@email.com';

  @override
  String get loginPasswordLabel => 'Mật khẩu';

  @override
  String get loginPasswordHint => 'Nhập mật khẩu';

  @override
  String get loginForgotPassword => 'Quên mật khẩu?';

  @override
  String get loginButton => 'Đăng nhập';

  @override
  String get loginNoAccount => 'Chưa có tài khoản?';

  @override
  String get loginSignUp => 'Đăng ký';

  @override
  String get loginErrorInvalidEmail => 'Vui lòng nhập địa chỉ email hợp lệ.';

  @override
  String get loginErrorInvalidCredentials =>
      'Email hoặc mật khẩu không đúng. Vui lòng thử lại.';

  @override
  String get loginErrorNetwork =>
      'Không thể kết nối. Vui lòng kiểm tra kết nối internet.';

  @override
  String get loginErrorTooManyAttempts =>
      'Quá nhiều lần thử. Vui lòng thử lại sau.';

  @override
  String get registerTitle => 'Tạo tài khoản của bạn';

  @override
  String get registerSubtitle => 'Bắt đầu hành trình tại Nhật Bản';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerEmailHint => 'your@email.com';

  @override
  String get registerPasswordLabel => 'Mật khẩu';

  @override
  String get registerPasswordHint => 'Tạo mật khẩu';

  @override
  String get registerPasswordHelper => '8 ký tự trở lên';

  @override
  String get registerConfirmLabel => 'Xác nhận mật khẩu';

  @override
  String get registerConfirmHint => 'Nhập lại mật khẩu';

  @override
  String get registerTermsAgree => 'Tôi đồng ý với ';

  @override
  String get registerTermsLink => 'Điều khoản dịch vụ';

  @override
  String get registerPrivacyAnd => 'và';

  @override
  String get registerPrivacyLink => 'Chính sách bảo mật';

  @override
  String get registerButton => 'Tạo tài khoản';

  @override
  String get registerHasAccount => 'Đã có tài khoản?';

  @override
  String get registerSignIn => 'Đăng nhập';

  @override
  String get registerErrorEmailInvalid => 'Vui lòng nhập địa chỉ email hợp lệ.';

  @override
  String get registerErrorEmailInUse =>
      'Email này đã được đăng ký. Hãy thử đăng nhập.';

  @override
  String get registerErrorPasswordShort => 'Mật khẩu phải có ít nhất 8 ký tự.';

  @override
  String get registerErrorPasswordMismatch => 'Mật khẩu không khớp.';

  @override
  String get registerErrorTermsRequired =>
      'Vui lòng đồng ý với Điều khoản dịch vụ.';

  @override
  String get resetTitle => 'Đặt lại mật khẩu';

  @override
  String get resetSubtitle =>
      'Nhập email và chúng tôi sẽ gửi liên kết đặt lại.';

  @override
  String get resetEmailLabel => 'Email';

  @override
  String get resetEmailHint => 'your@email.com';

  @override
  String get resetButton => 'Gửi liên kết đặt lại';

  @override
  String get resetBackToLogin => 'Quay lại đăng nhập';

  @override
  String get resetSuccessTitle => 'Kiểm tra email của bạn';

  @override
  String resetSuccessSubtitle(String email) {
    return 'Chúng tôi đã gửi liên kết đặt lại đến $email';
  }

  @override
  String get resetResend => 'Không nhận được? Gửi lại';

  @override
  String get resetErrorEmailInvalid => 'Vui lòng nhập địa chỉ email hợp lệ.';

  @override
  String get onboardingSkip => 'Bỏ qua';

  @override
  String get onboardingNext => 'Tiếp theo';

  @override
  String get onboardingGetStarted => 'Bắt đầu';

  @override
  String onboardingStepOf(int current, int total) {
    return 'Bước $current/$total';
  }

  @override
  String get onboardingS1Title => 'Quốc tịch của bạn là gì?';

  @override
  String get onboardingS1Subtitle =>
      'Điều này giúp chúng tôi cung cấp thông tin phù hợp.';

  @override
  String get onboardingS2Title => 'Tình trạng cư trú của bạn là gì?';

  @override
  String get onboardingS2Subtitle =>
      'Chúng tôi có thể điều chỉnh thông tin visa cho bạn.';

  @override
  String get onboardingS3Title => 'Bạn sống ở đâu tại Nhật Bản?';

  @override
  String get onboardingS3Subtitle => 'Để cung cấp hướng dẫn theo khu vực.';

  @override
  String get onboardingS4Title => 'Bạn đến Nhật Bản khi nào?';

  @override
  String get onboardingS4Subtitle =>
      'Chúng tôi sẽ gợi ý các nhiệm vụ cần hoàn thành đúng hạn.';

  @override
  String get onboardingS4Placeholder => 'Chọn ngày';

  @override
  String get onboardingS4NotYet => 'Tôi chưa đến Nhật';

  @override
  String get onboardingChangeDate => 'Thay đổi ngày';

  @override
  String get onboardingErrorSave =>
      'Không thể lưu thông tin. Vui lòng thử lại.';

  @override
  String get statusEngineer => 'Kỹ sư / Chuyên gia nhân văn';

  @override
  String get statusStudent => 'Du học sinh';

  @override
  String get statusDependent => 'Người phụ thuộc';

  @override
  String get statusPermanent => 'Thường trú nhân';

  @override
  String get statusSpouse => 'Vợ/chồng công dân Nhật';

  @override
  String get statusWorkingHoliday => 'Kỳ nghỉ làm việc';

  @override
  String get statusSpecifiedSkilled => 'Lao động kỹ năng đặc định';

  @override
  String get statusOther => 'Khác';

  @override
  String get tabHome => 'Trang chủ';

  @override
  String get tabChat => 'AI Hướng dẫn';

  @override
  String get tabGuide => 'Hướng dẫn';

  @override
  String get tabSOS => 'SOS';

  @override
  String get tabProfile => 'Hồ sơ';

  @override
  String homeGreetingMorning(String name) {
    return 'Chào buổi sáng, $name 👋';
  }

  @override
  String homeGreetingAfternoon(String name) {
    return 'Chào buổi chiều, $name 👋';
  }

  @override
  String homeGreetingEvening(String name) {
    return 'Chào buổi tối, $name 👋';
  }

  @override
  String homeGreetingDefault(String name) {
    return 'Xin chào, $name 👋';
  }

  @override
  String get homeGreetingNoName => 'Chào mừng! 👋';

  @override
  String homeUsageFree(int remaining, int limit) {
    return 'Miễn phí • Còn $remaining/$limit lượt chat hôm nay';
  }

  @override
  String get homeSectionQuickActions => 'Thao tác nhanh';

  @override
  String get homeSectionExplore => 'Khám phá';

  @override
  String get homeTrackerSummary => 'Việc cần làm';

  @override
  String get homePopularGuides => 'Hướng dẫn phổ biến';

  @override
  String get homeTrackerNoItems => 'Chưa có việc cần làm. Nhấn để thêm.';

  @override
  String get homeQaChatTitle => 'AI Chat';

  @override
  String get homeQaChatSubtitle => 'Hỏi bất kỳ điều gì về cuộc sống tại Nhật';

  @override
  String get homeQaBankingTitle => 'Ngân hàng';

  @override
  String get homeQaBankingSubtitle => 'Mở tài khoản, chuyển tiền & hơn thế';

  @override
  String get homeQaVisaTitle => 'Visa';

  @override
  String get homeQaVisaSubtitle => 'Hướng dẫn nhập cư & thủ tục';

  @override
  String get homeQaMedicalTitle => 'Y tế';

  @override
  String get homeQaMedicalSubtitle => 'Hướng dẫn sức khỏe & thông tin khẩn cấp';

  @override
  String get homeExploreGuides => 'Xem tất cả hướng dẫn';

  @override
  String get homeExploreEmergency => 'Liên hệ khẩn cấp';

  @override
  String get homeUpgradeTitle => 'Nhận thêm từ trợ lý AI của bạn';

  @override
  String get homeUpgradeCta => 'Nâng cấp ngay';

  @override
  String get chatTitle => 'AI Hướng dẫn';

  @override
  String get chatInputPlaceholder => 'Nhập tin nhắn...';

  @override
  String get chatEmptyTitle => 'Hãy hỏi bất cứ điều gì!';

  @override
  String get chatEmptySubtitle =>
      'Tôi có thể giúp bạn về ngân hàng, visa, y tế và nhiều vấn đề khác về cuộc sống tại Nhật.';

  @override
  String get chatSuggestBank => 'Làm sao để mở tài khoản ngân hàng?';

  @override
  String get chatSuggestVisa => 'Làm sao để gia hạn visa?';

  @override
  String get chatSuggestMedical => 'Làm sao để khám bệnh?';

  @override
  String get chatSuggestGeneral => 'Cần làm gì sau khi đến Nhật?';

  @override
  String get chatSourcesHeader => 'Nguồn tham khảo';

  @override
  String get chatDisclaimer =>
      'Đây chỉ là thông tin chung, không phải tư vấn pháp lý. Vui lòng xác nhận với cơ quan liên quan.';

  @override
  String chatLimitRemaining(int remaining, int limit) {
    return 'Còn $remaining/$limit lượt chat miễn phí hôm nay.';
  }

  @override
  String get chatLimitUpgrade => 'Nâng cấp';

  @override
  String get chatLimitExhausted =>
      'Bạn đã dùng hết lượt chat miễn phí hôm nay. Nâng cấp để tiếp tục!';

  @override
  String get chatErrorSend => 'Không thể gửi tin nhắn. Vui lòng thử lại.';

  @override
  String get chatErrorRetry => 'Thử lại';

  @override
  String get chatDateToday => 'Hôm nay';

  @override
  String get chatDateYesterday => 'Hôm qua';

  @override
  String get chatNewSession => 'Chat mới';

  @override
  String get chatUntitledSession => 'Cuộc trò chuyện mới';

  @override
  String get chatDeleteTitle => 'Xóa chat';

  @override
  String get chatDeleteConfirm => 'Bạn có chắc muốn xóa cuộc trò chuyện này?';

  @override
  String get chatDeleteCancel => 'Hủy';

  @override
  String get chatDeleteAction => 'Xóa';

  @override
  String get chatRetry => 'Thử lại';

  @override
  String get countryCN => 'Trung Quốc';

  @override
  String get countryVN => 'Việt Nam';

  @override
  String get countryKR => 'Hàn Quốc';

  @override
  String get countryPH => 'Philippines';

  @override
  String get countryBR => 'Brazil';

  @override
  String get countryNP => 'Nepal';

  @override
  String get countryID => 'Indonesia';

  @override
  String get countryUS => 'Hoa Kỳ';

  @override
  String get countryTH => 'Thái Lan';

  @override
  String get countryIN => 'Ấn Độ';

  @override
  String get countryMM => 'Myanmar';

  @override
  String get countryTW => 'Đài Loan';

  @override
  String get countryPE => 'Peru';

  @override
  String get countryGB => 'Vương quốc Anh';

  @override
  String get countryPK => 'Pakistan';

  @override
  String get countryBD => 'Bangladesh';

  @override
  String get countryLK => 'Sri Lanka';

  @override
  String get countryFR => 'Pháp';

  @override
  String get countryDE => 'Đức';

  @override
  String get countryOther => 'Khác';

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
  String get regionOther => 'Khác';

  @override
  String get genericError => 'Đã xảy ra lỗi. Vui lòng thử lại.';

  @override
  String get networkError => 'Lỗi mạng. Vui lòng kiểm tra kết nối.';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get bankingTitle => 'Hướng dẫn Ngân hàng';

  @override
  String get bankingFriendlyScore => 'Điểm thân thiện với người nước ngoài';

  @override
  String get bankingEmpty => 'Không tìm thấy ngân hàng';

  @override
  String get bankingRecommendButton => 'Gợi ý';

  @override
  String get bankingRecommendTitle => 'Gợi ý ngân hàng';

  @override
  String get bankingSelectPriorities => 'Chọn ưu tiên của bạn';

  @override
  String get bankingPriorityMultilingual => 'Hỗ trợ đa ngôn ngữ';

  @override
  String get bankingPriorityLowFee => 'Phí thấp';

  @override
  String get bankingPriorityAtm => 'Mạng ATM';

  @override
  String get bankingPriorityOnline => 'Ngân hàng trực tuyến';

  @override
  String get bankingGetRecommendations => 'Nhận gợi ý';

  @override
  String get bankingRecommendHint => 'Chọn ưu tiên và nhấn Nhận gợi ý';

  @override
  String get bankingNoRecommendations => 'Không tìm thấy gợi ý';

  @override
  String get bankingViewGuide => 'Xem hướng dẫn';

  @override
  String get bankingGuideTitle => 'Hướng dẫn mở tài khoản';

  @override
  String get bankingRequiredDocs => 'Giấy tờ cần thiết';

  @override
  String get bankingConversationTemplates => 'Cụm từ hữu ích tại ngân hàng';

  @override
  String get bankingTroubleshooting => 'Xử lý sự cố';

  @override
  String get bankingSource => 'Nguồn';

  @override
  String get visaTitle => 'Hướng dẫn Visa';

  @override
  String get visaEmpty => 'Không tìm thấy thủ tục';

  @override
  String get visaFilterAll => 'Tất cả';

  @override
  String get visaDetailTitle => 'Chi tiết thủ tục';

  @override
  String get visaSteps => 'Các bước';

  @override
  String get visaRequiredDocuments => 'Giấy tờ cần thiết';

  @override
  String get visaFees => 'Phí';

  @override
  String get visaProcessingTime => 'Thời gian xử lý';

  @override
  String get visaDisclaimer =>
      'QUAN TRỌNG: Đây là thông tin chung về thủ tục visa, không phải tư vấn nhập cư.';

  @override
  String get trackerTitle => 'Việc cần làm';

  @override
  String get trackerAddItem => 'Thêm việc mới';

  @override
  String get trackerNoItems => 'Chưa có việc cần làm';

  @override
  String get trackerNoItemsHint => 'Nhấn + để thêm việc cần làm đầu tiên';

  @override
  String get trackerAddTitle => 'Tiêu đề';

  @override
  String get trackerAddMemo => 'Ghi chú (tùy chọn)';

  @override
  String get trackerAddDueDate => 'Hạn chót (tùy chọn)';

  @override
  String get trackerDueToday => 'Hôm nay hết hạn';

  @override
  String get trackerOverdue => 'Quá hạn';

  @override
  String get trackerViewAll => 'Xem tất cả →';

  @override
  String get trackerDeleteTitle => 'Xóa việc cần làm';

  @override
  String get trackerDeleteConfirm => 'Bạn có chắc muốn xóa việc này?';

  @override
  String get trackerLimitReached =>
      'Gói miễn phí tối đa 3. Nâng cấp để không giới hạn.';

  @override
  String get trackerAlreadyTracking => 'Việc này đã có trong danh sách';

  @override
  String get scannerTitle => 'Quét tài liệu';

  @override
  String get scannerDescription =>
      'Quét tài liệu tiếng Nhật để dịch và giải thích ngay';

  @override
  String get scannerFromCamera => 'Quét từ Camera';

  @override
  String get scannerFromGallery => 'Chọn từ Thư viện';

  @override
  String get scannerHistory => 'Lịch sử';

  @override
  String get scannerHistoryTitle => 'Lịch sử quét';

  @override
  String get scannerHistoryEmpty => 'Chưa có lần quét nào';

  @override
  String get scannerUnknownType => 'Tài liệu không xác định';

  @override
  String get scannerResultTitle => 'Kết quả quét';

  @override
  String get scannerOriginalText => 'Văn bản gốc (Nhật)';

  @override
  String get scannerTranslation => 'Bản dịch';

  @override
  String get scannerExplanation => 'Ý nghĩa';

  @override
  String get scannerProcessing => 'Đang xử lý...';

  @override
  String get scannerRefresh => 'Làm mới';

  @override
  String get scannerFailed => 'Quét thất bại. Vui lòng thử lại.';

  @override
  String get scannerFreeLimitInfo =>
      'Miễn phí: 3 lần quét/tháng. Nâng cấp để có thêm.';

  @override
  String get scannerLimitReached =>
      'Đã hết lượt quét tháng này. Nâng cấp để có thêm.';

  @override
  String get medicalTitle => 'Hướng dẫn Y tế';

  @override
  String get medicalTabEmergency => 'Cấp cứu';

  @override
  String get medicalTabPhrases => 'Cụm từ';

  @override
  String get medicalEmergencyNumber => 'Số cấp cứu';

  @override
  String get medicalHowToCall => 'Cách gọi';

  @override
  String get medicalWhatToPrepare => 'Cần chuẩn bị';

  @override
  String get medicalUsefulPhrases => 'Cụm từ hữu ích';

  @override
  String get medicalCategoryAll => 'Tất cả';

  @override
  String get medicalCategoryEmergency => 'Cấp cứu';

  @override
  String get medicalCategorySymptom => 'Triệu chứng';

  @override
  String get medicalCategoryInsurance => 'Bảo hiểm';

  @override
  String get medicalCategoryGeneral => 'Chung';

  @override
  String get medicalNoPhrases => 'Không tìm thấy cụm từ';

  @override
  String get medicalDisclaimer =>
      'Hướng dẫn này cung cấp thông tin sức khỏe chung, không thay thế tư vấn y tế chuyên nghiệp. Trong trường hợp khẩn cấp, hãy gọi 119 ngay.';

  @override
  String get navigateBanking => 'Ngân hàng';

  @override
  String get navigateBankingDesc =>
      'Tìm ngân hàng thân thiện với người nước ngoài';

  @override
  String get navigateVisa => 'Visa';

  @override
  String get navigateVisaDesc => 'Thủ tục & giấy tờ visa';

  @override
  String get navigateScanner => 'Quét';

  @override
  String get navigateScannerDesc => 'Dịch tài liệu tiếng Nhật';

  @override
  String get navigateMedical => 'Y tế';

  @override
  String get navigateMedicalDesc => 'Hướng dẫn cấp cứu & cụm từ';

  @override
  String get navigateCommunity => 'Cộng đồng';

  @override
  String get navigateCommunityDesc => 'Hỏi đáp với người nước ngoài khác';

  @override
  String get upgradeToPremium => 'Nâng cấp lên Premium';

  @override
  String get communityTitle => 'Hỏi đáp Cộng đồng';

  @override
  String get communityEmpty => 'Chưa có bài viết';

  @override
  String get communityNewPost => 'Bài mới';

  @override
  String get communityDetailTitle => 'Chi tiết bài viết';

  @override
  String get communityAnswered => 'Đã trả lời';

  @override
  String get communityBestAnswer => 'Câu trả lời hay nhất';

  @override
  String get communityFilterAll => 'Tất cả';

  @override
  String get communitySortNewest => 'Mới nhất';

  @override
  String get communitySortPopular => 'Phổ biến';

  @override
  String get communityCategoryVisa => 'Visa';

  @override
  String get communityCategoryHousing => 'Nhà ở';

  @override
  String get communityCategoryBanking => 'Ngân hàng';

  @override
  String get communityCategoryWork => 'Công việc';

  @override
  String get communityCategoryDailyLife => 'Cuộc sống';

  @override
  String get communityCategoryMedical => 'Y tế';

  @override
  String get communityCategoryEducation => 'Giáo dục';

  @override
  String get communityCategoryTax => 'Thuế';

  @override
  String get communityCategoryOther => 'Khác';

  @override
  String communityReplies(int count) {
    return '$count Phản hồi';
  }

  @override
  String get communityNoReplies => 'Chưa có phản hồi. Hãy là người đầu tiên!';

  @override
  String get communityReplyHint => 'Viết phản hồi...';

  @override
  String get communityReplyPremiumOnly =>
      'Đăng và phản hồi yêu cầu đăng ký Premium.';

  @override
  String communityVoteCount(int count) {
    return '$count phiếu';
  }

  @override
  String get communityModerationPending => 'Đang xem xét';

  @override
  String get communityModerationFlagged => 'Đã đánh dấu xem xét';

  @override
  String get communityModerationNotice =>
      'Bài viết của bạn sẽ được hệ thống AI kiểm duyệt trước khi hiển thị.';

  @override
  String get communityChannelLabel => 'Kênh ngôn ngữ';

  @override
  String get communityCategoryLabel => 'Danh mục';

  @override
  String get communityTitleLabel => 'Tiêu đề';

  @override
  String get communityTitleHint => 'Câu hỏi của bạn là gì?';

  @override
  String get communityTitleMinLength => 'Tiêu đề ít nhất 5 ký tự';

  @override
  String get communityContentLabel => 'Chi tiết';

  @override
  String get communityContentHint =>
      'Mô tả câu hỏi hoặc tình huống chi tiết...';

  @override
  String get communityContentMinLength => 'Nội dung ít nhất 10 ký tự';

  @override
  String get communitySubmit => 'Đăng';

  @override
  String communityTimeAgoDays(int days) {
    return '$days ngày trước';
  }

  @override
  String communityTimeAgoHours(int hours) {
    return '$hours giờ trước';
  }

  @override
  String communityTimeAgoMinutes(int minutes) {
    return '$minutes phút trước';
  }

  @override
  String get subscriptionTitle => 'Đăng ký';

  @override
  String get subscriptionPlansTitle => 'Chọn gói của bạn';

  @override
  String get subscriptionPlansSubtitle =>
      'Mở khóa toàn bộ tiềm năng của Gaijin Life Navi';

  @override
  String get subscriptionCurrentPlan => 'Gói hiện tại';

  @override
  String get subscriptionCurrentPlanBadge => 'Gói hiện tại';

  @override
  String get subscriptionTierFree => 'Miễn phí';

  @override
  String get subscriptionTierPremium => 'Premium';

  @override
  String get subscriptionTierPremiumPlus => 'Premium+';

  @override
  String get subscriptionFreePrice => '¥0';

  @override
  String subscriptionPricePerMonth(int price) {
    return '¥$price/tháng';
  }

  @override
  String get subscriptionCheckout => 'Đăng ký ngay';

  @override
  String get subscriptionRecommended => 'ĐỀ XUẤT';

  @override
  String get subscriptionCancelling => 'Đang hủy...';

  @override
  String subscriptionCancellingAt(String date) {
    return 'Gói của bạn sẽ kết thúc vào $date';
  }

  @override
  String get subscriptionFeatureFreeChat => '5 lượt chat AI mỗi ngày';

  @override
  String get subscriptionFeatureFreeScans => '3 lượt quét tài liệu mỗi tháng';

  @override
  String get subscriptionFeatureFreeTracker => 'Theo dõi tối đa 3 thủ tục';

  @override
  String get subscriptionFeatureFreeCommunityRead => 'Đọc bài viết cộng đồng';

  @override
  String get subscriptionFeatureCommunityPost =>
      'Đăng & phản hồi trong cộng đồng';

  @override
  String get subscriptionFeatureUnlimitedChat => 'Chat AI không giới hạn';

  @override
  String get profileTitle => 'Tài khoản';

  @override
  String get profileEditTitle => 'Chỉnh sửa hồ sơ';

  @override
  String get profileEdit => 'Chỉnh sửa hồ sơ';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileNationality => 'Quốc tịch';

  @override
  String get profileResidenceStatus => 'Tình trạng cư trú';

  @override
  String get profileRegion => 'Khu vực';

  @override
  String get profileLanguage => 'Ngôn ngữ';

  @override
  String get profileArrivalDate => 'Ngày đến';

  @override
  String get profileDisplayName => 'Tên hiển thị';

  @override
  String get profileNoName => 'Chưa đặt tên';

  @override
  String get profileNameTooLong => 'Tên không được quá 100 ký tự';

  @override
  String get profileSaved => 'Đã lưu hồ sơ';

  @override
  String get profileSaveButton => 'Lưu';

  @override
  String get profileSaveError => 'Lưu thất bại';

  @override
  String get profileLoadError => 'Tải thất bại';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsLanguageSection => 'Ngôn ngữ';

  @override
  String get settingsAccountSection => 'Tài khoản';

  @override
  String get settingsAboutSection => 'Thông tin';

  @override
  String get settingsLogout => 'Đăng xuất';

  @override
  String get settingsDeleteAccount => 'Xóa tài khoản';

  @override
  String get settingsDeleteAccountSubtitle =>
      'Hành động này không thể hoàn tác';

  @override
  String get settingsVersion => 'Phiên bản';

  @override
  String get settingsLogoutConfirmTitle => 'Đăng xuất';

  @override
  String get settingsLogoutConfirmMessage => 'Bạn có chắc muốn đăng xuất?';

  @override
  String get settingsDeleteConfirmTitle => 'Xóa tài khoản';

  @override
  String get settingsDeleteConfirmMessage =>
      'Bạn có chắc muốn xóa tài khoản? Hành động này không thể hoàn tác. Tất cả dữ liệu sẽ bị xóa vĩnh viễn.';

  @override
  String get settingsDeleteError => 'Xóa thất bại';

  @override
  String get settingsCancel => 'Hủy';

  @override
  String get settingsDelete => 'Xóa';

  @override
  String get settingsConfirm => 'Xác nhận';

  @override
  String get navTitle => 'Hướng dẫn';

  @override
  String get navSubtitle => 'Khám phá các chủ đề giúp bạn sống tại Nhật Bản.';

  @override
  String navGuideCount(int count) {
    return '$count hướng dẫn';
  }

  @override
  String get navGuideCountOne => '1 hướng dẫn';

  @override
  String get navComingSoon => 'Sắp ra mắt';

  @override
  String get navComingSoonSnackbar => 'Sắp ra mắt! Chúng tôi đang thực hiện.';

  @override
  String get navErrorLoad => 'Không thể tải hướng dẫn.';

  @override
  String get navErrorRetry => 'Nhấn để thử lại';

  @override
  String get domainBanking => 'Ngân hàng & Tài chính';

  @override
  String get domainVisa => 'Visa & Nhập cư';

  @override
  String get domainMedical => 'Y tế & Sức khỏe';

  @override
  String get domainConcierge => 'Cuộc sống & Tổng hợp';

  @override
  String get domainHousing => 'Nhà ở & Tiện ích';

  @override
  String get domainEmployment => 'Việc làm & Thuế';

  @override
  String get domainEducation => 'Giáo dục & Chăm sóc trẻ';

  @override
  String get domainLegal => 'Pháp lý & Bảo hiểm';

  @override
  String get guideSearchPlaceholder => 'Tìm kiếm hướng dẫn...';

  @override
  String get guideComingSoonTitle => 'Sắp ra mắt';

  @override
  String guideComingSoonSubtitle(String domain) {
    return 'Chúng tôi đang chuẩn bị hướng dẫn về $domain. Hãy quay lại sau!';
  }

  @override
  String guideComingSoonAskAi(String domain) {
    return 'Hỏi AI về $domain';
  }

  @override
  String guideSearchEmpty(String query) {
    return 'Không tìm thấy hướng dẫn cho \"$query\".';
  }

  @override
  String get guideSearchTry => 'Thử từ khóa khác.';

  @override
  String get guideErrorLoad => 'Không thể tải hướng dẫn cho danh mục này.';

  @override
  String get guideAskAi => 'Hỏi AI về chủ đề này';

  @override
  String get guideDisclaimer =>
      'Đây là thông tin chung và không phải tư vấn pháp lý. Vui lòng xác nhận với cơ quan liên quan.';

  @override
  String get guideShare => 'Chia sẻ';

  @override
  String get guideErrorNotFound => 'Hướng dẫn này không còn khả dụng.';

  @override
  String get guideErrorLoadDetail =>
      'Không thể tải hướng dẫn này. Vui lòng thử lại.';

  @override
  String get guideErrorRetryBack => 'Quay lại';

  @override
  String get emergencyTitle => 'Khẩn cấp';

  @override
  String get emergencyWarning =>
      'Nếu bạn đang gặp nguy hiểm, hãy gọi 110 (Cảnh sát) hoặc 119 (Cứu hỏa/Cứu thương) ngay lập tức.';

  @override
  String get emergencySectionContacts => 'Liên hệ khẩn cấp';

  @override
  String get emergencySectionAmbulance => 'Cách gọi xe cứu thương';

  @override
  String get emergencySectionMoreHelp => 'Cần thêm trợ giúp?';

  @override
  String get emergencyPoliceName => 'Cảnh sát';

  @override
  String get emergencyPoliceNumber => '110';

  @override
  String get emergencyFireName => 'Cứu hỏa / Cứu thương';

  @override
  String get emergencyFireNumber => '119';

  @override
  String get emergencyMedicalName => 'Tư vấn y tế';

  @override
  String get emergencyMedicalNumber => '#7119';

  @override
  String get emergencyMedicalNote => 'Tư vấn y tế không khẩn cấp';

  @override
  String get emergencyTellName => 'TELL Japan (Sức khỏe tâm thần)';

  @override
  String get emergencyTellNumber => '03-5774-0992';

  @override
  String get emergencyTellNote => 'Tư vấn bằng tiếng Anh';

  @override
  String get emergencyHelplineName => 'Japan Helpline';

  @override
  String get emergencyHelplineNumber => '0570-064-211';

  @override
  String get emergencyHelplineNote => '24 giờ, đa ngôn ngữ';

  @override
  String get emergencyStep1 => 'Gọi 119';

  @override
  String get emergencyStep2 =>
      'Nói \"Kyuukyuu desu\" (救急です — Đây là trường hợp khẩn cấp)';

  @override
  String get emergencyStep3 =>
      'Giải thích vị trí của bạn (địa chỉ, mốc gần đó)';

  @override
  String get emergencyStep4 =>
      'Mô tả tình huống (chuyện gì xảy ra, triệu chứng)';

  @override
  String get emergencyStep5 => 'Đợi xe cứu thương ở lối vào tòa nhà';

  @override
  String get emergencyPhraseEmergencyHelp => 'Đây là trường hợp khẩn cấp';

  @override
  String get emergencyPhraseHelpHelp => 'Xin giúp đỡ';

  @override
  String get emergencyPhraseAmbulanceHelp => 'Xin gọi xe cứu thương';

  @override
  String get emergencyPhraseAddressHelp => 'Địa chỉ là ○○';

  @override
  String get emergencyAskAi => 'Chat với AI về tình huống khẩn cấp';

  @override
  String get emergencyDisclaimer =>
      'Hướng dẫn này cung cấp thông tin sức khỏe chung, không thay thế tư vấn y tế chuyên nghiệp. Trong trường hợp khẩn cấp, hãy gọi 119 ngay.';

  @override
  String get emergencyCallButton => 'Gọi';

  @override
  String get emergencyOffline =>
      'Không thể tải thêm thông tin. Gọi 110 hoặc 119 nếu bạn cần giúp đỡ.';

  @override
  String get subTitle => 'Gói đăng ký';

  @override
  String get subSectionCurrent => 'Gói hiện tại';

  @override
  String get subSectionChoose => 'Chọn gói';

  @override
  String get subSectionCharge => 'Cần thêm lượt chat?';

  @override
  String get subSectionFaq => 'Câu hỏi thường gặp';

  @override
  String get subCurrentFree => 'Gói miễn phí';

  @override
  String get subCurrentStandard => 'Gói tiêu chuẩn';

  @override
  String get subCurrentPremium => 'Gói cao cấp';

  @override
  String get subUpgradeNow => 'Nâng cấp ngay';

  @override
  String get subPlanFree => 'Miễn phí';

  @override
  String get subPlanStandard => 'Tiêu chuẩn';

  @override
  String get subPlanPremium => 'Cao cấp';

  @override
  String get subPriceFree => '¥0';

  @override
  String get subPriceStandard => '¥720';

  @override
  String get subPricePremium => '¥1,360';

  @override
  String get subPriceInterval => '/tháng';

  @override
  String get subRecommended => 'ĐỀ XUẤT';

  @override
  String get subFeatureChatFree => '20 lượt AI Guide khi đăng ký';

  @override
  String get subFeatureChatStandard => '300 lượt AI Guide/tháng';

  @override
  String get subFeatureChatPremium => 'AI Guide không giới hạn';

  @override
  String get subFeatureTrackerFree => 'Tối đa 3 mục theo dõi';

  @override
  String get subFeatureTrackerPaid => 'Mục theo dõi không giới hạn';

  @override
  String get subFeatureAdsYes => 'Có quảng cáo';

  @override
  String get subFeatureAdsNo => 'Không quảng cáo';

  @override
  String get subFeatureGuideFree => 'Xem một số hướng dẫn';

  @override
  String get subFeatureGuidePaid => 'Xem tất cả hướng dẫn';

  @override
  String get subFeatureImageNo => 'Phân tích ảnh AI (trong trò chuyện)';

  @override
  String get subFeatureImageYes => 'Phân tích ảnh AI (trong trò chuyện)';

  @override
  String get subButtonCurrent => 'Gói hiện tại';

  @override
  String subButtonChoose(String plan) {
    return 'Chọn $plan';
  }

  @override
  String get subCharge100 => 'Gói 100 lượt chat';

  @override
  String get subCharge50 => 'Gói 50 lượt chat';

  @override
  String get subCharge100Price => '¥360 (¥3.6/lượt)';

  @override
  String get subCharge50Price => '¥180 (¥3.6/lượt)';

  @override
  String get subChargeDescription =>
      'Lượt chat thêm không hết hạn. Sử dụng sau khi hết hạn mức gói.';

  @override
  String get subFaqBillingQ => 'Thanh toán hoạt động thế nào?';

  @override
  String get subFaqBillingA =>
      'Gói đăng ký được thanh toán hàng tháng qua App Store hoặc Google Play. Bạn có thể quản lý trong cài đặt thiết bị.';

  @override
  String get subFaqCancelQ => 'Tôi có thể hủy bất kỳ lúc nào?';

  @override
  String get subFaqCancelA =>
      'Có! Bạn có thể hủy bất kỳ lúc nào. Gói sẽ hoạt động đến cuối kỳ thanh toán.';

  @override
  String get subFaqDowngradeQ => 'Điều gì xảy ra khi hạ gói?';

  @override
  String get subFaqDowngradeA =>
      'Khi hạ gói, bạn vẫn giữ quyền lợi gói hiện tại đến cuối kỳ thanh toán, sau đó chuyển sang gói mới.';

  @override
  String get subFooter =>
      'Gói đăng ký được quản lý qua App Store / Google Play';

  @override
  String subPurchaseSuccess(String plan) {
    return 'Chào mừng đến $plan! Nâng cấp đã được kích hoạt.';
  }

  @override
  String get subPurchaseError =>
      'Không thể hoàn tất mua hàng. Vui lòng thử lại.';

  @override
  String get subErrorLoad => 'Không thể tải gói đăng ký.';

  @override
  String get subErrorRetry => 'Nhấn để thử lại';

  @override
  String get profileSectionInfo => 'Thông tin của bạn';

  @override
  String get profileSectionStats => 'Thống kê sử dụng';

  @override
  String get profileChatsToday => 'Chat hôm nay';

  @override
  String get profileMemberSince => 'Thành viên từ';

  @override
  String get profileManageSubscription => 'Quản lý gói đăng ký';

  @override
  String get profileNotSet => 'Chưa đặt';

  @override
  String get editTitle => 'Chỉnh sửa hồ sơ';

  @override
  String get editSave => 'Lưu';

  @override
  String get editNameLabel => 'Tên hiển thị';

  @override
  String get editNameHint => 'Nhập tên của bạn';

  @override
  String get editNationalityLabel => 'Quốc tịch';

  @override
  String get editNationalityHint => 'Chọn quốc tịch';

  @override
  String get editStatusLabel => 'Tình trạng cư trú';

  @override
  String get editStatusHint => 'Chọn tình trạng';

  @override
  String get editRegionLabel => 'Khu vực';

  @override
  String get editRegionHint => 'Chọn khu vực';

  @override
  String get editLanguageLabel => 'Ngôn ngữ ưu tiên';

  @override
  String get editChangePhoto => 'Đổi ảnh';

  @override
  String get editSuccess => 'Hồ sơ đã được cập nhật.';

  @override
  String get editError => 'Không thể cập nhật hồ sơ. Vui lòng thử lại.';

  @override
  String get editUnsavedTitle => 'Thay đổi chưa lưu';

  @override
  String get editUnsavedMessage => 'Bạn có thay đổi chưa lưu. Bỏ đi?';

  @override
  String get editUnsavedDiscard => 'Bỏ';

  @override
  String get editUnsavedKeep => 'Tiếp tục chỉnh sửa';

  @override
  String get settingsSectionGeneral => 'Chung';

  @override
  String get settingsSectionAccount => 'Tài khoản';

  @override
  String get settingsSectionDanger => 'Vùng nguy hiểm';

  @override
  String get settingsSectionAbout => 'Giới thiệu';

  @override
  String get settingsLanguage => 'Ngôn ngữ';

  @override
  String get settingsNotifications => 'Thông báo';

  @override
  String get settingsSubscription => 'Gói đăng ký';

  @override
  String get settingsTerms => 'Điều khoản dịch vụ';

  @override
  String get settingsPrivacy => 'Chính sách bảo mật';

  @override
  String get settingsContact => 'Liên hệ';

  @override
  String get settingsFooter =>
      'Tạo với ❤️ cho mọi người đang sống tại Nhật Bản';

  @override
  String get settingsLogoutTitle => 'Đăng xuất';

  @override
  String get settingsLogoutMessage => 'Bạn có chắc muốn đăng xuất?';

  @override
  String get settingsLogoutConfirm => 'Đăng xuất';

  @override
  String get settingsLogoutCancel => 'Hủy';

  @override
  String get settingsDeleteTitle => 'Xóa tài khoản';

  @override
  String get settingsDeleteMessage =>
      'Hành động này không thể hoàn tác. Tất cả dữ liệu sẽ bị xóa vĩnh viễn. Bạn chắc chứ?';

  @override
  String get settingsDeleteConfirmAction => 'Xóa tài khoản của tôi';

  @override
  String get settingsDeleteCancel => 'Hủy';

  @override
  String get settingsDeleteSuccess => 'Tài khoản của bạn đã bị xóa.';

  @override
  String get settingsLanguageTitle => 'Chọn ngôn ngữ';

  @override
  String get settingsErrorLogout => 'Không thể đăng xuất. Vui lòng thử lại.';

  @override
  String get settingsErrorDelete =>
      'Không thể xóa tài khoản. Vui lòng thử lại.';

  @override
  String get chatGuestTitle => 'Hỏi AI bất cứ điều gì về cuộc sống tại Nhật';

  @override
  String get chatGuestFeature1 => 'Cách mở tài khoản ngân hàng';

  @override
  String get chatGuestFeature2 => 'Thủ tục gia hạn visa';

  @override
  String get chatGuestFeature3 => 'Cách đi khám bệnh';

  @override
  String get chatGuestFeature4 => 'Và bất cứ điều gì khác';

  @override
  String get chatGuestFreeOffer => 'Đăng ký miễn phí — 5 lần chat/ngày';

  @override
  String get chatGuestSignUp => 'Bắt đầu miễn phí';

  @override
  String get chatGuestLogin => 'Đã có tài khoản? Đăng nhập';

  @override
  String get guestRegisterCta => 'Đăng ký miễn phí để dùng AI Chat';

  @override
  String get guideReadMore => 'Đăng ký để đọc toàn bộ';

  @override
  String get guideAskAI => 'Hỏi AI chi tiết';

  @override
  String get guideGuestCtaButton => 'Tạo tài khoản miễn phí';

  @override
  String get homeGuestCtaText =>
      'Tạo tài khoản miễn phí để mở khóa AI chat và hướng dẫn cá nhân';

  @override
  String get homeGuestCtaButton => 'Bắt đầu';

  @override
  String get chatUpgradeBanner => 'Nâng cấp lên Premium để chat không giới hạn';

  @override
  String get chatUpgradeButton => 'Xem gói';

  @override
  String get guidePremiumCta => 'Nội dung này yêu cầu đăng ký Premium';

  @override
  String get guidePremiumCtaButton => 'Xem gói';

  @override
  String get guideTierLimitError => 'Nâng cấp để truy cập toàn bộ nội dung';

  @override
  String get trackerSave => 'Lưu';

  @override
  String get trackerSaved => 'Đã lưu';

  @override
  String get trackerItemSaved => 'Đã thêm vào danh sách việc cần làm';

  @override
  String get homeQaTrackerTitle => 'Việc cần làm';

  @override
  String get homeQaTrackerSubtitle => 'Quản lý việc cần làm';

  @override
  String get chatAttachPhoto => 'Chụp ảnh';

  @override
  String get chatAttachGallery => 'Chọn từ Thư viện';

  @override
  String get chatAttachCancel => 'Hủy';

  @override
  String get chatImageTooLarge => 'Ảnh quá lớn (tối đa 5MB)';

  @override
  String get profilePersonalizationHint =>
      'Trợ lý AI sẽ đưa ra lời khuyên chính xác hơn dựa trên hồ sơ hoàn chỉnh của bạn';

  @override
  String get profileVisaExpiry => 'Hạn thị thực';

  @override
  String get profileResidenceRegion => 'Khu vực cư trú';

  @override
  String get profilePreferredLanguage => 'Ngôn ngữ ưa thích';

  @override
  String get profileSelectNationality => 'Chọn quốc tịch';

  @override
  String get profileSelectResidenceStatus => 'Chọn tư cách lưu trú';

  @override
  String get profileSelectPrefecture => 'Chọn tỉnh/thành';

  @override
  String get profileSelectCity => 'Chọn quận/huyện';

  @override
  String get profileSelectLanguage => 'Chọn ngôn ngữ';

  @override
  String get profileCommonStatuses => 'Phổ biến';

  @override
  String get profileOtherStatuses => 'Khác';

  @override
  String get profileSearchNationality => 'Tìm quốc tịch';

  @override
  String get visaRenewalPrepTitle => 'Chuẩn bị gia hạn tư cách lưu trú';

  @override
  String get visaRenewalDeadlineTitle => 'Hạn chót gia hạn tư cách lưu trú';

  @override
  String get profileSave => 'Lưu';

  @override
  String get profileUsageStats => 'Thống kê sử dụng';

  @override
  String get profileLogout => 'Đăng xuất';

  @override
  String get profileDeleteAccount => 'Xóa tài khoản';

  @override
  String get subUsageTitle => 'Tình trạng sử dụng';

  @override
  String subUsageCount(int used, int limit) {
    return 'Đã dùng $used / $limit lượt chat';
  }

  @override
  String get subUsageUnlimited => 'Chat không giới hạn';

  @override
  String get tabAccount => 'Tài khoản';

  @override
  String get accountSectionProfile => 'Hồ sơ';

  @override
  String get accountSectionManagement => 'Quản lý tài khoản';

  @override
  String get accountSectionDanger => 'Vùng nguy hiểm';

  @override
  String get notificationSettingsTitle => 'Thông báo';

  @override
  String get notificationTodoReminder => 'Nhắc nhở việc cần làm';

  @override
  String get notificationReminderTime => 'Thời gian nhắc nhở';

  @override
  String get notificationEnabled => 'Đã bật';

  @override
  String get notificationDisabled => 'Đã tắt';
}
