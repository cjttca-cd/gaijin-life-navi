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
  String get languageSelectionTitle => 'Chọn Ngôn Ngữ';

  @override
  String get languageSelectionSubtitle =>
      'Bạn có thể thay đổi sau trong cài đặt';

  @override
  String get continueButton => 'Tiếp tục';

  @override
  String get loginTitle => 'Chào Mừng Trở Lại';

  @override
  String get loginSubtitle => 'Đăng nhập vào tài khoản của bạn';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Mật khẩu';

  @override
  String get loginButton => 'Đăng nhập';

  @override
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get noAccount => 'Chưa có tài khoản?';

  @override
  String get signUp => 'Đăng ký';

  @override
  String get registerTitle => 'Tạo Tài Khoản';

  @override
  String get registerSubtitle => 'Bắt đầu cuộc sống tại Nhật Bản với sự tự tin';

  @override
  String get confirmPasswordLabel => 'Xác nhận mật khẩu';

  @override
  String get registerButton => 'Tạo Tài Khoản';

  @override
  String get hasAccount => 'Đã có tài khoản?';

  @override
  String get signIn => 'Đăng nhập';

  @override
  String get resetPasswordTitle => 'Đặt Lại Mật Khẩu';

  @override
  String get resetPasswordSubtitle => 'Nhập email để nhận liên kết đặt lại';

  @override
  String get sendResetLink => 'Gửi Liên Kết Đặt Lại';

  @override
  String get backToLogin => 'Quay lại Đăng nhập';

  @override
  String get resetPasswordSuccess =>
      'Email đặt lại mật khẩu đã được gửi. Kiểm tra hộp thư của bạn.';

  @override
  String get emailRequired => 'Vui lòng nhập email';

  @override
  String get emailInvalid => 'Vui lòng nhập email hợp lệ';

  @override
  String get passwordRequired => 'Vui lòng nhập mật khẩu';

  @override
  String get passwordTooShort => 'Mật khẩu phải có ít nhất 8 ký tự';

  @override
  String get passwordMismatch => 'Mật khẩu không khớp';

  @override
  String get tabHome => 'Trang chủ';

  @override
  String get tabChat => 'Trò chuyện';

  @override
  String get tabTracker => 'Theo dõi';

  @override
  String get tabNavigate => 'Điều hướng';

  @override
  String get tabProfile => 'Hồ sơ';

  @override
  String get homeWelcome => 'Chào mừng đến với Gaijin Life Navi';

  @override
  String get homeSubtitle => 'Hướng dẫn cuộc sống tại Nhật Bản';

  @override
  String get homeQuickActions => 'Thao tác nhanh';

  @override
  String get homeActionAskAI => 'Hỏi AI';

  @override
  String get homeActionTracker => 'Theo dõi';

  @override
  String get homeActionBanking => 'Ngân hàng';

  @override
  String get homeActionChatHistory => 'Lịch sử chat';

  @override
  String get homeRecentChats => 'Chat gần đây';

  @override
  String get homeNoRecentChats => 'Chưa có cuộc trò chuyện nào';

  @override
  String get homeMessagesLabel => 'tin nhắn';

  @override
  String get chatPlaceholder => 'AI Chat — Sắp ra mắt';

  @override
  String get chatTitle => 'AI Chat';

  @override
  String get chatNewSession => 'Chat mới';

  @override
  String get chatEmptyTitle => 'Bắt đầu cuộc trò chuyện';

  @override
  String get chatEmptySubtitle =>
      'Hỏi AI bất cứ điều gì về cuộc sống tại Nhật Bản';

  @override
  String get chatUntitledSession => 'Cuộc trò chuyện mới';

  @override
  String get chatConversationTitle => 'Trò chuyện';

  @override
  String get chatInputHint => 'Hỏi về cuộc sống tại Nhật Bản...';

  @override
  String get chatTyping => 'Đang suy nghĩ...';

  @override
  String get chatSources => 'Nguồn';

  @override
  String get chatRetry => 'Thử lại';

  @override
  String get chatDeleteTitle => 'Xóa chat';

  @override
  String get chatDeleteConfirm =>
      'Bạn có chắc chắn muốn xóa cuộc trò chuyện này?';

  @override
  String get chatDeleteCancel => 'Hủy';

  @override
  String get chatDeleteAction => 'Xóa';

  @override
  String get chatLimitReached => 'Đã đạt giới hạn hàng ngày';

  @override
  String chatRemainingCount(int remaining, int limit) {
    return 'Còn lại $remaining/$limit';
  }

  @override
  String get chatLimitReachedTitle => 'Đã đạt giới hạn hàng ngày';

  @override
  String get chatLimitReachedMessage =>
      'Bạn đã sử dụng hết lượt chat miễn phí hôm nay. Nâng cấp lên Premium để sử dụng không giới hạn.';

  @override
  String get chatUpgradeToPremium => 'Nâng cấp lên Premium';

  @override
  String get chatWelcomePrompt => 'Hôm nay tôi có thể giúp gì cho bạn?';

  @override
  String get chatWelcomeHint =>
      'Hỏi về thủ tục visa, ngân hàng, nhà ở, hoặc bất cứ điều gì về cuộc sống tại Nhật Bản.';

  @override
  String get onboardingTitle => 'Thiết lập hồ sơ';

  @override
  String get onboardingSkip => 'Bỏ qua';

  @override
  String get onboardingNext => 'Tiếp theo';

  @override
  String get onboardingComplete => 'Hoàn thành';

  @override
  String onboardingStepOf(int current, int total) {
    return 'Bước $current / $total';
  }

  @override
  String get onboardingNationalityTitle => 'Quốc tịch của bạn là gì?';

  @override
  String get onboardingNationalitySubtitle =>
      'Điều này giúp chúng tôi cung cấp thông tin phù hợp với tình huống của bạn.';

  @override
  String get onboardingResidenceStatusTitle => 'Tư cách cư trú của bạn là gì?';

  @override
  String get onboardingResidenceStatusSubtitle =>
      'Chọn loại visa hiện tại của bạn tại Nhật Bản.';

  @override
  String get onboardingRegionTitle => 'Bạn sống ở đâu?';

  @override
  String get onboardingRegionSubtitle =>
      'Chọn khu vực bạn đang sống hoặc dự định chuyển đến.';

  @override
  String get onboardingArrivalDateTitle => 'Bạn đến Nhật Bản khi nào?';

  @override
  String get onboardingArrivalDateSubtitle =>
      'Điều này giúp chúng tôi đề xuất các thủ tục và hạn chót liên quan.';

  @override
  String get onboardingSelectDate => 'Chọn ngày';

  @override
  String get onboardingChangeDate => 'Đổi ngày';

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
  String get visaEngineer => 'Kỹ sư / Chuyên gia';

  @override
  String get visaStudent => 'Du học sinh';

  @override
  String get visaDependent => 'Gia đình';

  @override
  String get visaPermanent => 'Thường trú nhân';

  @override
  String get visaSpouse => 'Vợ/chồng người Nhật';

  @override
  String get visaWorkingHoliday => 'Working Holiday';

  @override
  String get visaSpecifiedSkilled => 'Kỹ năng đặc định';

  @override
  String get visaTechnicalIntern => 'Thực tập kỹ thuật';

  @override
  String get visaHighlySkilled => 'Nhân lực trình độ cao';

  @override
  String get visaOther => 'Khác';

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
  String get trackerPlaceholder => 'Theo dõi thủ tục — Sắp ra mắt';

  @override
  String get navigatePlaceholder => 'Điều hướng — Sắp ra mắt';

  @override
  String get profilePlaceholder => 'Hồ sơ — Sắp ra mắt';

  @override
  String get genericError => 'Có lỗi xảy ra. Vui lòng thử lại.';

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
  String get bankingRecommendTitle => 'Gợi ý Ngân hàng';

  @override
  String get bankingSelectPriorities => 'Chọn ưu tiên của bạn';

  @override
  String get bankingPriorityMultilingual => 'Hỗ trợ đa ngôn ngữ';

  @override
  String get bankingPriorityLowFee => 'Phí thấp';

  @override
  String get bankingPriorityAtm => 'Mạng lưới ATM';

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
  String get bankingRequiredDocs => 'Tài liệu cần thiết';

  @override
  String get bankingConversationTemplates => 'Cụm từ hữu ích tại ngân hàng';

  @override
  String get bankingTroubleshooting => 'Mẹo xử lý sự cố';

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
  String get visaRequiredDocuments => 'Tài liệu cần thiết';

  @override
  String get visaFees => 'Lệ phí';

  @override
  String get visaProcessingTime => 'Thời gian xử lý';

  @override
  String get visaDisclaimer =>
      'QUAN TRỌNG: Đây là thông tin chung về thủ tục visa và không cấu thành tư vấn nhập cư. Luật và thủ tục nhập cư có thể thay đổi. Luôn tham khảo ý kiến của Cục Quản lý Xuất nhập cảnh hoặc luật sư nhập cư có chuyên môn (行政書士) cho tình huống cụ thể của bạn.';

  @override
  String get trackerTitle => 'Theo dõi Thủ tục';

  @override
  String get trackerEmpty => 'Chưa theo dõi thủ tục nào';

  @override
  String get trackerEmptyHint => 'Nhấn + để thêm thủ tục cần theo dõi';

  @override
  String get trackerAddProcedure => 'Thêm thủ tục';

  @override
  String get trackerStatusNotStarted => 'Chưa bắt đầu';

  @override
  String get trackerStatusInProgress => 'Đang tiến hành';

  @override
  String get trackerStatusCompleted => 'Đã hoàn thành';

  @override
  String get trackerDueDate => 'Hạn chót';

  @override
  String get trackerFreeLimitInfo =>
      'Gói miễn phí: tối đa 3 thủ tục. Nâng cấp để không giới hạn.';

  @override
  String get trackerDetailTitle => 'Chi tiết thủ tục';

  @override
  String get trackerCurrentStatus => 'Trạng thái hiện tại';

  @override
  String get trackerNotes => 'Ghi chú';

  @override
  String get trackerChangeStatus => 'Thay đổi trạng thái';

  @override
  String get trackerMarkInProgress => 'Đánh dấu đang tiến hành';

  @override
  String get trackerMarkCompleted => 'Đánh dấu hoàn thành';

  @override
  String get trackerMarkIncomplete => 'Đánh dấu chưa hoàn thành';

  @override
  String get trackerStatusUpdated => 'Đã cập nhật trạng thái';

  @override
  String get trackerDeleteTitle => 'Xóa thủ tục';

  @override
  String get trackerDeleteConfirm =>
      'Bạn có chắc chắn muốn xóa thủ tục này khỏi theo dõi?';

  @override
  String get trackerProcedureAdded => 'Đã thêm thủ tục vào theo dõi';

  @override
  String get trackerLimitReached =>
      'Đã đạt giới hạn gói miễn phí (3 thủ tục). Nâng cấp lên Premium để không giới hạn.';

  @override
  String get trackerAlreadyTracking => 'Bạn đã theo dõi thủ tục này';

  @override
  String get trackerEssentialProcedures => 'Thiết yếu (Sau khi đến)';

  @override
  String get trackerOtherProcedures => 'Thủ tục khác';

  @override
  String get trackerNoTemplates => 'Không có mẫu thủ tục';

  @override
  String get scannerTitle => 'Quét tài liệu';

  @override
  String get scannerDescription =>
      'Quét tài liệu tiếng Nhật để nhận bản dịch và giải thích ngay lập tức';

  @override
  String get scannerFromCamera => 'Quét từ Camera';

  @override
  String get scannerFromGallery => 'Chọn từ Thư viện';

  @override
  String get scannerHistory => 'Lịch sử';

  @override
  String get scannerHistoryTitle => 'Lịch sử quét';

  @override
  String get scannerHistoryEmpty => 'Chưa có bản quét nào';

  @override
  String get scannerUnknownType => 'Tài liệu không xác định';

  @override
  String get scannerResultTitle => 'Kết quả quét';

  @override
  String get scannerOriginalText => 'Văn bản gốc (Tiếng Nhật)';

  @override
  String get scannerTranslation => 'Bản dịch';

  @override
  String get scannerExplanation => 'Điều này có nghĩa gì';

  @override
  String get scannerProcessing => 'Đang xử lý tài liệu...';

  @override
  String get scannerRefresh => 'Làm mới';

  @override
  String get scannerFailed => 'Quét thất bại. Vui lòng thử lại.';

  @override
  String get scannerFreeLimitInfo =>
      'Gói miễn phí: 3 lần quét/tháng. Nâng cấp để có thêm.';

  @override
  String get scannerLimitReached =>
      'Đã đạt giới hạn quét hàng tháng. Nâng cấp lên Premium để quét thêm.';

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
  String get medicalWhatToPrepare => 'Chuẩn bị gì';

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
      'Hướng dẫn này cung cấp thông tin sức khỏe chung và không thay thế lời khuyên y tế chuyên nghiệp. Trong trường hợp khẩn cấp, hãy gọi 119 ngay lập tức.';

  @override
  String get navigateBanking => 'Ngân hàng';

  @override
  String get navigateBankingDesc =>
      'Tìm ngân hàng thân thiện với người nước ngoài';

  @override
  String get navigateVisa => 'Visa';

  @override
  String get navigateVisaDesc => 'Thủ tục visa và tài liệu';

  @override
  String get navigateScanner => 'Quét';

  @override
  String get navigateScannerDesc => 'Dịch tài liệu tiếng Nhật';

  @override
  String get navigateMedical => 'Y tế';

  @override
  String get navigateMedicalDesc => 'Hướng dẫn cấp cứu và cụm từ';

  @override
  String get upgradeToPremium => 'Nâng cấp lên Premium';

  @override
  String get communityTitle => 'Cộng đồng Hỏi đáp';

  @override
  String get communityEmpty => 'Chưa có bài viết';

  @override
  String get communityNewPost => 'Bài viết mới';

  @override
  String get communityDetailTitle => 'Chi tiết bài viết';

  @override
  String get communityAnswered => 'Đã trả lời';

  @override
  String get communityBestAnswer => 'Câu trả lời tốt nhất';

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
  String get communityCategoryDailyLife => 'Cuộc sống hàng ngày';

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
    return '$count Trả lời';
  }

  @override
  String get communityNoReplies =>
      'Chưa có câu trả lời. Hãy là người đầu tiên!';

  @override
  String get communityReplyHint => 'Viết câu trả lời...';

  @override
  String get communityReplyPremiumOnly =>
      'Đăng bài và trả lời cần đăng ký Premium.';

  @override
  String communityVoteCount(int count) {
    return '$count phiếu';
  }

  @override
  String get communityModerationPending => 'Đang xem xét';

  @override
  String get communityModerationFlagged => 'Đã gắn cờ để xem xét';

  @override
  String get communityModerationNotice =>
      'Bài viết của bạn sẽ được hệ thống AI kiểm duyệt trước khi hiển thị cho người khác.';

  @override
  String get communityChannelLabel => 'Kênh ngôn ngữ';

  @override
  String get communityCategoryLabel => 'Danh mục';

  @override
  String get communityTitleLabel => 'Tiêu đề';

  @override
  String get communityTitleHint => 'Câu hỏi của bạn là gì?';

  @override
  String get communityTitleMinLength => 'Tiêu đề phải có ít nhất 5 ký tự';

  @override
  String get communityContentLabel => 'Chi tiết';

  @override
  String get communityContentHint =>
      'Mô tả chi tiết câu hỏi hoặc tình huống của bạn...';

  @override
  String get communityContentMinLength => 'Nội dung phải có ít nhất 10 ký tự';

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
  String get navigateCommunity => 'Cộng đồng';

  @override
  String get navigateCommunityDesc => 'Hỏi đáp với người nước ngoài khác';

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
  String get subscriptionRecommended => 'KHUYẾN NGHỊ';

  @override
  String get subscriptionCancelling => 'Đang hủy...';

  @override
  String subscriptionCancellingAt(String date) {
    return 'Gói của bạn sẽ kết thúc vào $date';
  }

  @override
  String get subscriptionFeatureFreeChat => '5 cuộc trò chuyện AI mỗi ngày';

  @override
  String get subscriptionFeatureFreeScans => '3 lần quét tài liệu mỗi tháng';

  @override
  String get subscriptionFeatureFreeTracker => 'Theo dõi tối đa 3 thủ tục';

  @override
  String get subscriptionFeatureFreeCommunityRead => 'Đọc bài viết cộng đồng';

  @override
  String get subscriptionFeatureCommunityPost =>
      'Đăng bài và trả lời trong cộng đồng';

  @override
  String get subscriptionFeatureUnlimitedChat => 'Trò chuyện AI không giới hạn';

  @override
  String get profileTitle => 'Hồ sơ';

  @override
  String get profileEditTitle => 'Chỉnh sửa hồ sơ';

  @override
  String get profileEdit => 'Chỉnh sửa hồ sơ';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileNationality => 'Quốc tịch';

  @override
  String get profileResidenceStatus => 'Tư cách cư trú';

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
  String get profileSaveError => 'Lưu hồ sơ thất bại';

  @override
  String get profileLoadError => 'Tải hồ sơ thất bại';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsLanguageSection => 'Ngôn ngữ';

  @override
  String get settingsAccountSection => 'Tài khoản';

  @override
  String get settingsAboutSection => 'Giới thiệu';

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
  String get settingsDeleteError => 'Xóa tài khoản thất bại';

  @override
  String get settingsCancel => 'Hủy';

  @override
  String get settingsDelete => 'Xóa';

  @override
  String get settingsConfirm => 'Xác nhận';
}
