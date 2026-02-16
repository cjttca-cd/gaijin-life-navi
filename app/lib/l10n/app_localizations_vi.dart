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
}
