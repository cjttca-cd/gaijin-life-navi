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
  String get chatPlaceholder => 'AI 채팅 — 곧 출시';

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
}
