// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '外国人生活导航';

  @override
  String get languageSelectionTitle => '选择您的语言';

  @override
  String get languageSelectionSubtitle => '您可以稍后在设置中更改';

  @override
  String get continueButton => '继续';

  @override
  String get loginTitle => '欢迎回来';

  @override
  String get loginSubtitle => '登录您的账户';

  @override
  String get emailLabel => '邮箱';

  @override
  String get passwordLabel => '密码';

  @override
  String get loginButton => '登录';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get noAccount => '还没有账户？';

  @override
  String get signUp => '注册';

  @override
  String get registerTitle => '创建账户';

  @override
  String get registerSubtitle => '自信地开始您的日本生活';

  @override
  String get confirmPasswordLabel => '确认密码';

  @override
  String get registerButton => '创建账户';

  @override
  String get hasAccount => '已有账户？';

  @override
  String get signIn => '登录';

  @override
  String get resetPasswordTitle => '重置密码';

  @override
  String get resetPasswordSubtitle => '输入您的邮箱以接收重置链接';

  @override
  String get sendResetLink => '发送重置链接';

  @override
  String get backToLogin => '返回登录';

  @override
  String get resetPasswordSuccess => '密码重置邮件已发送，请检查收件箱。';

  @override
  String get emailRequired => '请输入邮箱';

  @override
  String get emailInvalid => '请输入有效的邮箱';

  @override
  String get passwordRequired => '请输入密码';

  @override
  String get passwordTooShort => '密码至少需要8个字符';

  @override
  String get passwordMismatch => '两次输入的密码不一致';

  @override
  String get tabHome => '首页';

  @override
  String get tabChat => '聊天';

  @override
  String get tabTracker => '追踪';

  @override
  String get tabNavigate => '导航';

  @override
  String get tabProfile => '个人';

  @override
  String get homeWelcome => '欢迎来到外国人生活导航';

  @override
  String get homeSubtitle => '您的日本生活指南';

  @override
  String get homeQuickActions => '快捷操作';

  @override
  String get homeActionAskAI => 'AI 问答';

  @override
  String get homeActionTracker => '追踪器';

  @override
  String get homeActionBanking => '银行';

  @override
  String get homeActionChatHistory => '聊天记录';

  @override
  String get homeRecentChats => '最近的聊天';

  @override
  String get homeNoRecentChats => '暂无聊天记录';

  @override
  String get homeMessagesLabel => '条消息';

  @override
  String get chatPlaceholder => 'AI 聊天 — 即将推出';

  @override
  String get chatTitle => 'AI 聊天';

  @override
  String get chatNewSession => '新对话';

  @override
  String get chatEmptyTitle => '开始对话';

  @override
  String get chatEmptySubtitle => '向 AI 询问有关在日本生活的任何问题';

  @override
  String get chatUntitledSession => '新对话';

  @override
  String get chatConversationTitle => '对话';

  @override
  String get chatInputHint => '询问有关日本生活的问题...';

  @override
  String get chatTyping => '思考中...';

  @override
  String get chatSources => '来源';

  @override
  String get chatRetry => '重试';

  @override
  String get chatDeleteTitle => '删除聊天';

  @override
  String get chatDeleteConfirm => '确定要删除这个聊天吗？';

  @override
  String get chatDeleteCancel => '取消';

  @override
  String get chatDeleteAction => '删除';

  @override
  String get chatLimitReached => '已达每日上限';

  @override
  String chatRemainingCount(int remaining, int limit) {
    return '剩余 $remaining/$limit';
  }

  @override
  String get chatLimitReachedTitle => '已达每日上限';

  @override
  String get chatLimitReachedMessage => '您今天的免费聊天次数已用完。升级到高级版可无限使用。';

  @override
  String get chatUpgradeToPremium => '升级到高级版';

  @override
  String get chatWelcomePrompt => '今天我能帮您什么？';

  @override
  String get chatWelcomeHint => '询问有关签证手续、银行、住房或在日本生活的任何问题。';

  @override
  String get onboardingTitle => '设置您的个人资料';

  @override
  String get onboardingSkip => '跳过';

  @override
  String get onboardingNext => '下一步';

  @override
  String get onboardingComplete => '完成';

  @override
  String onboardingStepOf(int current, int total) {
    return '第 $current 步，共 $total 步';
  }

  @override
  String get onboardingNationalityTitle => '您的国籍是什么？';

  @override
  String get onboardingNationalitySubtitle => '这有助于我们为您提供相关信息。';

  @override
  String get onboardingResidenceStatusTitle => '您的在留资格是什么？';

  @override
  String get onboardingResidenceStatusSubtitle => '选择您在日本的当前签证类型。';

  @override
  String get onboardingRegionTitle => '您住在哪里？';

  @override
  String get onboardingRegionSubtitle => '选择您目前居住或计划搬迁的地区。';

  @override
  String get onboardingArrivalDateTitle => '您什么时候到日本的？';

  @override
  String get onboardingArrivalDateSubtitle => '这有助于我们建议相关手续和截止日期。';

  @override
  String get onboardingSelectDate => '选择日期';

  @override
  String get onboardingChangeDate => '更改日期';

  @override
  String get countryCN => '中国';

  @override
  String get countryVN => '越南';

  @override
  String get countryKR => '韩国';

  @override
  String get countryPH => '菲律宾';

  @override
  String get countryBR => '巴西';

  @override
  String get countryNP => '尼泊尔';

  @override
  String get countryID => '印度尼西亚';

  @override
  String get countryUS => '美国';

  @override
  String get countryTH => '泰国';

  @override
  String get countryIN => '印度';

  @override
  String get countryMM => '缅甸';

  @override
  String get countryTW => '台湾';

  @override
  String get countryPE => '秘鲁';

  @override
  String get countryGB => '英国';

  @override
  String get countryPK => '巴基斯坦';

  @override
  String get countryBD => '孟加拉国';

  @override
  String get countryLK => '斯里兰卡';

  @override
  String get countryFR => '法国';

  @override
  String get countryDE => '德国';

  @override
  String get countryOther => '其他';

  @override
  String get visaEngineer => '技术·人文知识·国际业务';

  @override
  String get visaStudent => '留学';

  @override
  String get visaDependent => '家族滞在';

  @override
  String get visaPermanent => '永住者';

  @override
  String get visaSpouse => '日本人配偶者';

  @override
  String get visaWorkingHoliday => '工作假期';

  @override
  String get visaSpecifiedSkilled => '特定技能';

  @override
  String get visaTechnicalIntern => '技能实习';

  @override
  String get visaHighlySkilled => '高度专业人才';

  @override
  String get visaOther => '其他';

  @override
  String get regionTokyo => '东京';

  @override
  String get regionOsaka => '大阪';

  @override
  String get regionNagoya => '名古屋';

  @override
  String get regionYokohama => '横滨';

  @override
  String get regionFukuoka => '福冈';

  @override
  String get regionSapporo => '札幌';

  @override
  String get regionKobe => '神户';

  @override
  String get regionKyoto => '京都';

  @override
  String get regionSendai => '仙台';

  @override
  String get regionHiroshima => '广岛';

  @override
  String get regionOther => '其他';

  @override
  String get trackerPlaceholder => '行政追踪 — 即将推出';

  @override
  String get navigatePlaceholder => '导航 — 即将推出';

  @override
  String get profilePlaceholder => '个人资料 — 即将推出';

  @override
  String get genericError => '出现错误，请重试。';

  @override
  String get networkError => '网络错误，请检查您的连接。';

  @override
  String get logout => '退出登录';
}
