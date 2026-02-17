// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Gaijin Life Navi';

  @override
  String get langTitle => '选择你的语言';

  @override
  String get langContinue => '继续';

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
  String get loginWelcome => '欢迎回来';

  @override
  String get loginSubtitle => '登录以继续';

  @override
  String get loginEmailLabel => '邮箱';

  @override
  String get loginEmailHint => 'your@email.com';

  @override
  String get loginPasswordLabel => '密码';

  @override
  String get loginPasswordHint => '请输入密码';

  @override
  String get loginForgotPassword => '忘记密码？';

  @override
  String get loginButton => '登录';

  @override
  String get loginNoAccount => '还没有账号？';

  @override
  String get loginSignUp => '注册';

  @override
  String get loginErrorInvalidEmail => '请输入有效的邮箱地址。';

  @override
  String get loginErrorInvalidCredentials => '邮箱或密码不正确，请重试。';

  @override
  String get loginErrorNetwork => '无法连接，请检查网络。';

  @override
  String get loginErrorTooManyAttempts => '尝试次数过多，请稍后再试。';

  @override
  String get registerTitle => '创建你的账号';

  @override
  String get registerSubtitle => '开始你的日本生活之旅';

  @override
  String get registerEmailLabel => '邮箱';

  @override
  String get registerEmailHint => 'your@email.com';

  @override
  String get registerPasswordLabel => '密码';

  @override
  String get registerPasswordHint => '创建密码';

  @override
  String get registerPasswordHelper => '8个字符以上';

  @override
  String get registerConfirmLabel => '确认密码';

  @override
  String get registerConfirmHint => '再次输入密码';

  @override
  String get registerTermsAgree => '我同意';

  @override
  String get registerTermsLink => '服务条款';

  @override
  String get registerPrivacyAnd => '和';

  @override
  String get registerPrivacyLink => '隐私政策';

  @override
  String get registerButton => '创建账号';

  @override
  String get registerHasAccount => '已有账号？';

  @override
  String get registerSignIn => '登录';

  @override
  String get registerErrorEmailInvalid => '请输入有效的邮箱地址。';

  @override
  String get registerErrorEmailInUse => '该邮箱已注册，请直接登录。';

  @override
  String get registerErrorPasswordShort => '密码至少需要8个字符。';

  @override
  String get registerErrorPasswordMismatch => '两次密码不一致。';

  @override
  String get registerErrorTermsRequired => '请同意服务条款。';

  @override
  String get resetTitle => '重置密码';

  @override
  String get resetSubtitle => '输入你的邮箱，我们将发送重置链接。';

  @override
  String get resetEmailLabel => '邮箱';

  @override
  String get resetEmailHint => 'your@email.com';

  @override
  String get resetButton => '发送重置链接';

  @override
  String get resetBackToLogin => '返回登录';

  @override
  String get resetSuccessTitle => '检查你的邮箱';

  @override
  String resetSuccessSubtitle(String email) {
    return '我们已向 $email 发送了重置链接';
  }

  @override
  String get resetResend => '没收到？重新发送';

  @override
  String get resetErrorEmailInvalid => '请输入有效的邮箱地址。';

  @override
  String get onboardingSkip => '跳过';

  @override
  String get onboardingNext => '下一步';

  @override
  String get onboardingGetStarted => '开始使用';

  @override
  String onboardingStepOf(int current, int total) {
    return '第$current步，共$total步';
  }

  @override
  String get onboardingS1Title => '你的国籍是什么？';

  @override
  String get onboardingS1Subtitle => '这有助于我们提供相关信息。';

  @override
  String get onboardingS2Title => '你的在留资格是什么？';

  @override
  String get onboardingS2Subtitle => '我们可以为你定制签证相关信息。';

  @override
  String get onboardingS3Title => '你住在日本哪里？';

  @override
  String get onboardingS3Subtitle => '用于提供本地化指南。';

  @override
  String get onboardingS4Title => '你什么时候来日本的？';

  @override
  String get onboardingS4Subtitle => '我们会提醒你需要完成的时间敏感任务。';

  @override
  String get onboardingS4Placeholder => '选择日期';

  @override
  String get onboardingS4NotYet => '我还没来日本';

  @override
  String get onboardingChangeDate => '更改日期';

  @override
  String get onboardingErrorSave => '无法保存信息，请重试。';

  @override
  String get statusEngineer => '技术·人文知识·国际业务';

  @override
  String get statusStudent => '留学';

  @override
  String get statusDependent => '家族滞在';

  @override
  String get statusPermanent => '永住者';

  @override
  String get statusSpouse => '日本人配偶者';

  @override
  String get statusWorkingHoliday => '打工度假';

  @override
  String get statusSpecifiedSkilled => '特定技能';

  @override
  String get statusOther => '其他';

  @override
  String get tabHome => '首页';

  @override
  String get tabChat => '对话';

  @override
  String get tabGuide => '指南';

  @override
  String get tabSOS => '紧急';

  @override
  String get tabProfile => '我的';

  @override
  String homeGreetingMorning(String name) {
    return '早上好，$name 👋';
  }

  @override
  String homeGreetingAfternoon(String name) {
    return '下午好，$name 👋';
  }

  @override
  String homeGreetingEvening(String name) {
    return '晚上好，$name 👋';
  }

  @override
  String homeGreetingDefault(String name) {
    return '你好，$name 👋';
  }

  @override
  String get homeGreetingNoName => '欢迎！👋';

  @override
  String homeUsageFree(int remaining, int limit) {
    return '免费版 • 今日剩余 $remaining/$limit 次对话';
  }

  @override
  String get homeSectionQuickActions => '快捷操作';

  @override
  String get homeSectionExplore => '浏览指南';

  @override
  String get homeQaChatTitle => 'AI 对话';

  @override
  String get homeQaChatSubtitle => '关于日本生活的任何问题';

  @override
  String get homeQaBankingTitle => '银行';

  @override
  String get homeQaBankingSubtitle => '开户、转账等';

  @override
  String get homeQaVisaTitle => '签证';

  @override
  String get homeQaVisaSubtitle => '入境指南和手续';

  @override
  String get homeQaMedicalTitle => '医疗';

  @override
  String get homeQaMedicalSubtitle => '健康指南和急救信息';

  @override
  String get homeExploreGuides => '浏览所有指南';

  @override
  String get homeExploreEmergency => '紧急联系方式';

  @override
  String get homeUpgradeTitle => '从 AI 助手获得更多帮助';

  @override
  String get homeUpgradeCta => '立即升级';

  @override
  String get chatTitle => 'AI 对话';

  @override
  String get chatInputPlaceholder => '输入你的消息...';

  @override
  String get chatEmptyTitle => '有什么想问的？';

  @override
  String get chatEmptySubtitle => '我可以帮你解答银行、签证、医疗等日本生活问题。';

  @override
  String get chatSuggestBank => '如何开设银行账户？';

  @override
  String get chatSuggestVisa => '如何续签签证？';

  @override
  String get chatSuggestMedical => '如何就医？';

  @override
  String get chatSuggestGeneral => '来日本后需要做什么？';

  @override
  String get chatSourcesHeader => '参考来源';

  @override
  String get chatDisclaimer => '以上为一般性信息，不构成法律建议。请向相关机构确认。';

  @override
  String chatLimitRemaining(int remaining, int limit) {
    return '今日剩余 $remaining/$limit 次免费对话。';
  }

  @override
  String get chatLimitUpgrade => '升级';

  @override
  String get chatLimitExhausted => '你今天的免费对话已用完。升级以继续对话！';

  @override
  String get chatErrorSend => '无法发送消息，请重试。';

  @override
  String get chatErrorRetry => '重试';

  @override
  String get chatDateToday => '今天';

  @override
  String get chatDateYesterday => '昨天';

  @override
  String get chatNewSession => '新对话';

  @override
  String get chatUntitledSession => '新对话';

  @override
  String get chatDeleteTitle => '删除对话';

  @override
  String get chatDeleteConfirm => '确定要删除这个对话吗？';

  @override
  String get chatDeleteCancel => '取消';

  @override
  String get chatDeleteAction => '删除';

  @override
  String get chatRetry => '重试';

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
  String get genericError => '出了点问题，请重试。';

  @override
  String get networkError => '网络错误，请检查连接。';

  @override
  String get logout => '退出登录';

  @override
  String get bankingTitle => '银行导航';

  @override
  String get bankingFriendlyScore => '外国人友好度';

  @override
  String get bankingEmpty => '未找到银行';

  @override
  String get bankingRecommendButton => '推荐';

  @override
  String get bankingRecommendTitle => '银行推荐';

  @override
  String get bankingSelectPriorities => '选择你的优先项';

  @override
  String get bankingPriorityMultilingual => '多语言支持';

  @override
  String get bankingPriorityLowFee => '低费用';

  @override
  String get bankingPriorityAtm => 'ATM网络';

  @override
  String get bankingPriorityOnline => '网上银行';

  @override
  String get bankingGetRecommendations => '获取推荐';

  @override
  String get bankingRecommendHint => '选择优先项并点击获取推荐';

  @override
  String get bankingNoRecommendations => '未找到推荐';

  @override
  String get bankingViewGuide => '查看指南';

  @override
  String get bankingGuideTitle => '开户指南';

  @override
  String get bankingRequiredDocs => '所需文件';

  @override
  String get bankingConversationTemplates => '银行常用短语';

  @override
  String get bankingTroubleshooting => '常见问题';

  @override
  String get bankingSource => '来源';

  @override
  String get visaTitle => '签证导航';

  @override
  String get visaEmpty => '未找到手续';

  @override
  String get visaFilterAll => '全部';

  @override
  String get visaDetailTitle => '手续详情';

  @override
  String get visaSteps => '步骤';

  @override
  String get visaRequiredDocuments => '所需文件';

  @override
  String get visaFees => '费用';

  @override
  String get visaProcessingTime => '处理时间';

  @override
  String get visaDisclaimer => '重要：以上是签证手续的一般信息，不构成移民建议。';

  @override
  String get trackerTitle => '行政跟踪';

  @override
  String get trackerEmpty => '暂无跟踪手续';

  @override
  String get trackerEmptyHint => '点击 + 添加手续';

  @override
  String get trackerAddProcedure => '添加手续';

  @override
  String get trackerStatusNotStarted => '未开始';

  @override
  String get trackerStatusInProgress => '进行中';

  @override
  String get trackerStatusCompleted => '已完成';

  @override
  String get trackerDueDate => '截止日期';

  @override
  String get trackerFreeLimitInfo => '免费版：最多3个手续。升级解锁更多。';

  @override
  String get trackerDetailTitle => '手续详情';

  @override
  String get trackerCurrentStatus => '当前状态';

  @override
  String get trackerNotes => '备注';

  @override
  String get trackerChangeStatus => '更改状态';

  @override
  String get trackerMarkInProgress => '标记为进行中';

  @override
  String get trackerMarkCompleted => '标记为已完成';

  @override
  String get trackerMarkIncomplete => '标记为未完成';

  @override
  String get trackerStatusUpdated => '状态已更新';

  @override
  String get trackerDeleteTitle => '删除手续';

  @override
  String get trackerDeleteConfirm => '确定要从跟踪器中删除此手续吗？';

  @override
  String get trackerProcedureAdded => '手续已添加到跟踪器';

  @override
  String get trackerLimitReached => '免费版限制已达（3个手续）。升级解锁更多。';

  @override
  String get trackerAlreadyTracking => '你已在跟踪此手续';

  @override
  String get trackerEssentialProcedures => '必要手续（到达后）';

  @override
  String get trackerOtherProcedures => '其他手续';

  @override
  String get trackerNoTemplates => '暂无手续模板';

  @override
  String get scannerTitle => '文件扫描';

  @override
  String get scannerDescription => '扫描日语文件获取即时翻译和解释';

  @override
  String get scannerFromCamera => '拍照扫描';

  @override
  String get scannerFromGallery => '从相册选择';

  @override
  String get scannerHistory => '历史';

  @override
  String get scannerHistoryTitle => '扫描历史';

  @override
  String get scannerHistoryEmpty => '暂无扫描';

  @override
  String get scannerUnknownType => '未知文件';

  @override
  String get scannerResultTitle => '扫描结果';

  @override
  String get scannerOriginalText => '原文（日语）';

  @override
  String get scannerTranslation => '翻译';

  @override
  String get scannerExplanation => '含义说明';

  @override
  String get scannerProcessing => '正在处理...';

  @override
  String get scannerRefresh => '刷新';

  @override
  String get scannerFailed => '扫描失败，请重试。';

  @override
  String get scannerFreeLimitInfo => '免费版：每月3次扫描。升级获取更多。';

  @override
  String get scannerLimitReached => '月度扫描次数已用完。升级获取更多。';

  @override
  String get medicalTitle => '医疗指南';

  @override
  String get medicalTabEmergency => '急救';

  @override
  String get medicalTabPhrases => '常用语';

  @override
  String get medicalEmergencyNumber => '急救电话';

  @override
  String get medicalHowToCall => '如何拨打';

  @override
  String get medicalWhatToPrepare => '准备事项';

  @override
  String get medicalUsefulPhrases => '常用短语';

  @override
  String get medicalCategoryAll => '全部';

  @override
  String get medicalCategoryEmergency => '急救';

  @override
  String get medicalCategorySymptom => '症状';

  @override
  String get medicalCategoryInsurance => '保险';

  @override
  String get medicalCategoryGeneral => '常规';

  @override
  String get medicalNoPhrases => '未找到短语';

  @override
  String get medicalDisclaimer => '本指南提供一般健康信息，不能替代专业医疗建议。紧急情况请立即拨打119。';

  @override
  String get navigateBanking => '银行';

  @override
  String get navigateBankingDesc => '查找对外国人友好的银行';

  @override
  String get navigateVisa => '签证';

  @override
  String get navigateVisaDesc => '签证手续和文件';

  @override
  String get navigateScanner => '扫描';

  @override
  String get navigateScannerDesc => '翻译日语文件';

  @override
  String get navigateMedical => '医疗';

  @override
  String get navigateMedicalDesc => '急救指南和常用语';

  @override
  String get navigateCommunity => '社区';

  @override
  String get navigateCommunityDesc => '与其他外国人交流';

  @override
  String get upgradeToPremium => '升级到高级版';

  @override
  String get communityTitle => '社区问答';

  @override
  String get communityEmpty => '暂无帖子';

  @override
  String get communityNewPost => '发帖';

  @override
  String get communityDetailTitle => '帖子详情';

  @override
  String get communityAnswered => '已回答';

  @override
  String get communityBestAnswer => '最佳回答';

  @override
  String get communityFilterAll => '全部';

  @override
  String get communitySortNewest => '最新';

  @override
  String get communitySortPopular => '热门';

  @override
  String get communityCategoryVisa => '签证';

  @override
  String get communityCategoryHousing => '住房';

  @override
  String get communityCategoryBanking => '银行';

  @override
  String get communityCategoryWork => '工作';

  @override
  String get communityCategoryDailyLife => '日常生活';

  @override
  String get communityCategoryMedical => '医疗';

  @override
  String get communityCategoryEducation => '教育';

  @override
  String get communityCategoryTax => '税务';

  @override
  String get communityCategoryOther => '其他';

  @override
  String communityReplies(int count) {
    return '$count 回复';
  }

  @override
  String get communityNoReplies => '暂无回复。成为第一个回答者！';

  @override
  String get communityReplyHint => '写回复...';

  @override
  String get communityReplyPremiumOnly => '发帖和回复需要高级版订阅。';

  @override
  String communityVoteCount(int count) {
    return '$count 票';
  }

  @override
  String get communityModerationPending => '审核中';

  @override
  String get communityModerationFlagged => '已标记审核';

  @override
  String get communityModerationNotice => '你的帖子将由 AI 审核系统审核后对其他人可见。';

  @override
  String get communityChannelLabel => '语言频道';

  @override
  String get communityCategoryLabel => '分类';

  @override
  String get communityTitleLabel => '标题';

  @override
  String get communityTitleHint => '你的问题是什么？';

  @override
  String get communityTitleMinLength => '标题至少5个字符';

  @override
  String get communityContentLabel => '详情';

  @override
  String get communityContentHint => '详细描述你的问题或情况...';

  @override
  String get communityContentMinLength => '内容至少10个字符';

  @override
  String get communitySubmit => '发帖';

  @override
  String communityTimeAgoDays(int days) {
    return '$days天前';
  }

  @override
  String communityTimeAgoHours(int hours) {
    return '$hours小时前';
  }

  @override
  String communityTimeAgoMinutes(int minutes) {
    return '$minutes分钟前';
  }

  @override
  String get subscriptionTitle => '订阅';

  @override
  String get subscriptionPlansTitle => '选择你的计划';

  @override
  String get subscriptionPlansSubtitle => '解锁 Gaijin Life Navi 的全部潜力';

  @override
  String get subscriptionCurrentPlan => '当前计划';

  @override
  String get subscriptionCurrentPlanBadge => '当前计划';

  @override
  String get subscriptionTierFree => '免费';

  @override
  String get subscriptionTierPremium => '高级';

  @override
  String get subscriptionTierPremiumPlus => '高级+';

  @override
  String get subscriptionFreePrice => '¥0';

  @override
  String subscriptionPricePerMonth(int price) {
    return '¥$price/月';
  }

  @override
  String get subscriptionCheckout => '立即订阅';

  @override
  String get subscriptionRecommended => '推荐';

  @override
  String get subscriptionCancelling => '取消中...';

  @override
  String subscriptionCancellingAt(String date) {
    return '你的计划将于 $date 结束';
  }

  @override
  String get subscriptionFeatureFreeChat => '每天5次AI对话';

  @override
  String get subscriptionFeatureFreeScans => '每月3次文件扫描';

  @override
  String get subscriptionFeatureFreeTracker => '跟踪最多3个手续';

  @override
  String get subscriptionFeatureFreeCommunityRead => '阅读社区帖子';

  @override
  String get subscriptionFeatureCommunityPost => '在社区发帖和回复';

  @override
  String get subscriptionFeatureUnlimitedChat => '无限AI对话';

  @override
  String get profileTitle => '个人资料';

  @override
  String get profileEditTitle => '编辑资料';

  @override
  String get profileEdit => '编辑资料';

  @override
  String get profileEmail => '邮箱';

  @override
  String get profileNationality => '国籍';

  @override
  String get profileResidenceStatus => '在留资格';

  @override
  String get profileRegion => '地区';

  @override
  String get profileLanguage => '语言';

  @override
  String get profileArrivalDate => '到达日期';

  @override
  String get profileDisplayName => '显示名称';

  @override
  String get profileNoName => '未设置';

  @override
  String get profileNameTooLong => '名称不能超过100个字符';

  @override
  String get profileSaved => '资料已保存';

  @override
  String get profileSaveButton => '保存';

  @override
  String get profileSaveError => '保存失败';

  @override
  String get profileLoadError => '加载失败';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsLanguageSection => '语言';

  @override
  String get settingsAccountSection => '账号';

  @override
  String get settingsAboutSection => '关于';

  @override
  String get settingsLogout => '退出登录';

  @override
  String get settingsDeleteAccount => '删除账号';

  @override
  String get settingsDeleteAccountSubtitle => '此操作无法撤消';

  @override
  String get settingsVersion => '版本';

  @override
  String get settingsLogoutConfirmTitle => '退出登录';

  @override
  String get settingsLogoutConfirmMessage => '确定要退出登录吗？';

  @override
  String get settingsDeleteConfirmTitle => '删除账号';

  @override
  String get settingsDeleteConfirmMessage => '确定要删除账号吗？此操作无法撤消。所有数据将被永久删除。';

  @override
  String get settingsDeleteError => '删除失败';

  @override
  String get settingsCancel => '取消';

  @override
  String get settingsDelete => '删除';

  @override
  String get settingsConfirm => '确认';
}
