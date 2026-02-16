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

  @override
  String get bankingTitle => '银行导航';

  @override
  String get bankingFriendlyScore => '外国人友好评分';

  @override
  String get bankingEmpty => '未找到银行';

  @override
  String get bankingRecommendButton => '推荐';

  @override
  String get bankingRecommendTitle => '银行推荐';

  @override
  String get bankingSelectPriorities => '选择您的优先条件';

  @override
  String get bankingPriorityMultilingual => '多语言支持';

  @override
  String get bankingPriorityLowFee => '低手续费';

  @override
  String get bankingPriorityAtm => 'ATM 网络';

  @override
  String get bankingPriorityOnline => '网上银行';

  @override
  String get bankingGetRecommendations => '获取推荐';

  @override
  String get bankingRecommendHint => '选择您的优先条件并点击获取推荐';

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
  String get bankingTroubleshooting => '故障排除提示';

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
  String get visaDisclaimer =>
      '重要提示：这是关于签证手续的一般信息，不构成移民建议。移民法律和程序可能会变更。请务必咨询出入国管理局或合格的行政书士以了解您的具体情况。';

  @override
  String get trackerTitle => '行政追踪';

  @override
  String get trackerEmpty => '未追踪任何手续';

  @override
  String get trackerEmptyHint => '点击 + 添加要追踪的手续';

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
  String get trackerFreeLimitInfo => '免费版：最多3个手续。升级可无限使用。';

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
  String get trackerDeleteConfirm => '确定要从追踪中移除此手续吗？';

  @override
  String get trackerProcedureAdded => '手续已添加到追踪';

  @override
  String get trackerLimitReached => '免费版限制已达到（3个手续）。升级到高级版可无限使用。';

  @override
  String get trackerAlreadyTracking => '您已在追踪此手续';

  @override
  String get trackerEssentialProcedures => '必要手续（到达后）';

  @override
  String get trackerOtherProcedures => '其他手续';

  @override
  String get trackerNoTemplates => '没有可用的手续模板';

  @override
  String get scannerTitle => '文档扫描';

  @override
  String get scannerDescription => '扫描日语文档，获取即时翻译和解释';

  @override
  String get scannerFromCamera => '从相机扫描';

  @override
  String get scannerFromGallery => '从相册选择';

  @override
  String get scannerHistory => '历史';

  @override
  String get scannerHistoryTitle => '扫描历史';

  @override
  String get scannerHistoryEmpty => '暂无扫描记录';

  @override
  String get scannerUnknownType => '未知文档';

  @override
  String get scannerResultTitle => '扫描结果';

  @override
  String get scannerOriginalText => '原文（日语）';

  @override
  String get scannerTranslation => '翻译';

  @override
  String get scannerExplanation => '这意味着什么';

  @override
  String get scannerProcessing => '正在处理您的文档...';

  @override
  String get scannerRefresh => '刷新';

  @override
  String get scannerFailed => '扫描失败，请重试。';

  @override
  String get scannerFreeLimitInfo => '免费版：每月3次扫描。升级可获取更多。';

  @override
  String get scannerLimitReached => '已达每月扫描上限。升级到高级版可获取更多扫描次数。';

  @override
  String get medicalTitle => '医疗指南';

  @override
  String get medicalTabEmergency => '紧急';

  @override
  String get medicalTabPhrases => '短语';

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
  String get medicalCategoryEmergency => '紧急';

  @override
  String get medicalCategorySymptom => '症状';

  @override
  String get medicalCategoryInsurance => '保险';

  @override
  String get medicalCategoryGeneral => '一般';

  @override
  String get medicalNoPhrases => '未找到短语';

  @override
  String get medicalDisclaimer => '本指南提供一般健康信息，不能替代专业医疗建议。紧急情况下请立即拨打119。';

  @override
  String get navigateBanking => '银行';

  @override
  String get navigateBankingDesc => '查找外国人友好的银行';

  @override
  String get navigateVisa => '签证';

  @override
  String get navigateVisaDesc => '签证手续和文件';

  @override
  String get navigateScanner => '扫描';

  @override
  String get navigateScannerDesc => '翻译日语文档';

  @override
  String get navigateMedical => '医疗';

  @override
  String get navigateMedicalDesc => '紧急指南和短语';

  @override
  String get upgradeToPremium => '升级到高级版';

  @override
  String get communityTitle => '社区问答';

  @override
  String get communityEmpty => '暂无帖子';

  @override
  String get communityNewPost => '发新帖';

  @override
  String get communityDetailTitle => '帖子详情';

  @override
  String get communityAnswered => '已回答';

  @override
  String get communityBestAnswer => '最佳答案';

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
    return '$count 条回复';
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
  String get communityModerationFlagged => '已标记待审';

  @override
  String get communityModerationNotice => '您的帖子将由AI审核系统审核后才会对其他人可见。';

  @override
  String get communityChannelLabel => '语言频道';

  @override
  String get communityCategoryLabel => '分类';

  @override
  String get communityTitleLabel => '标题';

  @override
  String get communityTitleHint => '您的问题是什么？';

  @override
  String get communityTitleMinLength => '标题至少5个字符';

  @override
  String get communityContentLabel => '详情';

  @override
  String get communityContentHint => '详细描述您的问题或情况...';

  @override
  String get communityContentMinLength => '内容至少10个字符';

  @override
  String get communitySubmit => '发布';

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
  String get navigateCommunity => '社区';

  @override
  String get navigateCommunityDesc => '与其他外国人问答';

  @override
  String get subscriptionTitle => '订阅';

  @override
  String get subscriptionPlansTitle => '选择您的方案';

  @override
  String get subscriptionPlansSubtitle => '解锁 Gaijin Life Navi 的全部功能';

  @override
  String get subscriptionCurrentPlan => '当前方案';

  @override
  String get subscriptionCurrentPlanBadge => '当前方案';

  @override
  String get subscriptionTierFree => '免费';

  @override
  String get subscriptionTierPremium => '高级版';

  @override
  String get subscriptionTierPremiumPlus => '高级版+';

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
    return '您的方案将于 $date 结束';
  }

  @override
  String get subscriptionFeatureFreeChat => '每天5次AI对话';

  @override
  String get subscriptionFeatureFreeScans => '每月3次文档扫描';

  @override
  String get subscriptionFeatureFreeTracker => '追踪最多3个手续';

  @override
  String get subscriptionFeatureFreeCommunityRead => '阅读社区帖子';

  @override
  String get subscriptionFeatureCommunityPost => '在社区发帖和回复';

  @override
  String get subscriptionFeatureUnlimitedChat => '无限AI对话';
}
