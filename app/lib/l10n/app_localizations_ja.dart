// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '日本生活ナビゲーター';

  @override
  String get langTitle => '言語を選択';

  @override
  String get langContinue => '続行';

  @override
  String get langEn => '英語';

  @override
  String get langZh => '中国語';

  @override
  String get langVi => 'ベトナム語';

  @override
  String get langKo => '韓国語';

  @override
  String get langPt => 'ポルトガル語';

  @override
  String get loginWelcome => 'アカウントにログイン';

  @override
  String get loginSubtitle => 'ログインして続行';

  @override
  String get loginEmailLabel => 'メールアドレス';

  @override
  String get loginEmailHint => 'your@email.com';

  @override
  String get loginPasswordLabel => 'パスワード';

  @override
  String get loginPasswordHint => 'パスワードを入力';

  @override
  String get loginForgotPassword => 'パスワードをお忘れですか？';

  @override
  String get loginButton => 'ログイン';

  @override
  String get loginNoAccount => 'アカウントをお持ちでないですか？';

  @override
  String get loginSignUp => '新規登録';

  @override
  String get loginErrorInvalidEmail => '有効なメールアドレスを入力してください。';

  @override
  String get loginErrorInvalidCredentials =>
      'メールアドレスまたはパスワードが正しくありません。再度お試しください。';

  @override
  String get loginErrorNetwork => '接続できません。インターネット接続を確認してください。';

  @override
  String get loginErrorTooManyAttempts => '試行回数が多すぎます。後でもう一度お試しください。';

  @override
  String get registerTitle => 'アカウントを作成';

  @override
  String get registerSubtitle => '日本での生活を始めましょう';

  @override
  String get registerEmailLabel => 'メールアドレス';

  @override
  String get registerEmailHint => 'your@email.com';

  @override
  String get registerPasswordLabel => 'パスワード';

  @override
  String get registerPasswordHint => 'パスワードを作成';

  @override
  String get registerPasswordHelper => '8文字以上';

  @override
  String get registerConfirmLabel => 'パスワードを確認';

  @override
  String get registerConfirmHint => 'パスワードを再入力';

  @override
  String get registerTermsAgree => 'に同意する';

  @override
  String get registerTermsLink => '利用規約';

  @override
  String get registerPrivacyAnd => 'と';

  @override
  String get registerPrivacyLink => 'プライバシーポリシー';

  @override
  String get registerButton => 'アカウントを作成';

  @override
  String get registerHasAccount => 'すでにアカウントをお持ちですか？';

  @override
  String get registerSignIn => 'ログイン';

  @override
  String get registerErrorEmailInvalid => '有効なメールアドレスを入力してください。';

  @override
  String get registerErrorEmailInUse => 'このメールアドレスはすでに登録されています。ログインをお試しください。';

  @override
  String get registerErrorPasswordShort => 'パスワードは8文字以上である必要があります。';

  @override
  String get registerErrorPasswordMismatch => 'パスワードが一致しません。';

  @override
  String get registerErrorTermsRequired => '利用規約に同意してください。';

  @override
  String get resetTitle => 'パスワードをリセット';

  @override
  String get resetSubtitle => 'メールアドレスを入力してください。リセットリンクをお送りします。';

  @override
  String get resetEmailLabel => 'メールアドレス';

  @override
  String get resetEmailHint => 'your@email.com';

  @override
  String get resetButton => 'リセットリンクを送信';

  @override
  String get resetBackToLogin => 'ログイン画面に戻る';

  @override
  String get resetSuccessTitle => 'メールを確認してください';

  @override
  String resetSuccessSubtitle(String email) {
    return '$emailにリセットリンクを送信しました';
  }

  @override
  String get resetResend => '届きませんか？再送信';

  @override
  String get resetErrorEmailInvalid => '有効なメールアドレスを入力してください。';

  @override
  String get onboardingSkip => 'スキップ';

  @override
  String get onboardingNext => '次へ';

  @override
  String get onboardingGetStarted => '始める';

  @override
  String onboardingStepOf(int current, int total) {
    return '$totalステップ中 $current';
  }

  @override
  String get onboardingS1Title => '国籍は何ですか？';

  @override
  String get onboardingS1Subtitle => '関連情報を提供するために使用します。';

  @override
  String get onboardingS2Title => '在留資格は何ですか？';

  @override
  String get onboardingS2Subtitle => 'ビザ関連情報をパーソナライズします。';

  @override
  String get onboardingS3Title => '日本のどこにお住まいですか？';

  @override
  String get onboardingS3Subtitle => '地域別のガイドを提供します。';

  @override
  String get onboardingS4Title => '日本への入国日を教えてください。';

  @override
  String get onboardingS4Subtitle => '時期に応じた手続きをお知らせします。';

  @override
  String get onboardingS4Placeholder => '日付を選択';

  @override
  String get onboardingS4NotYet => 'まだ入国していません';

  @override
  String get onboardingChangeDate => '日付を変更';

  @override
  String get onboardingErrorSave => '情報の保存に失敗しました。もう一度お試しください。';

  @override
  String get statusEngineer => '技術・人文知識・国際業務';

  @override
  String get statusStudent => '留学';

  @override
  String get statusDependent => '家族滞在';

  @override
  String get statusPermanent => '永住者';

  @override
  String get statusSpouse => '日本人の配偶者等';

  @override
  String get statusWorkingHoliday => '特定活動（ワーキング・ホリデー）';

  @override
  String get statusSpecifiedSkilled => '特定技能';

  @override
  String get statusOther => 'その他';

  @override
  String get tabHome => 'ホーム';

  @override
  String get tabChat => 'AIガイド';

  @override
  String get tabGuide => 'ガイド';

  @override
  String get tabSOS => '緊急連絡';

  @override
  String get tabProfile => 'プロフィール';

  @override
  String homeGreetingMorning(String name) {
    return 'おはようございます、$nameさん 👋';
  }

  @override
  String homeGreetingAfternoon(String name) {
    return 'こんにちは、$nameさん 👋';
  }

  @override
  String homeGreetingEvening(String name) {
    return 'こんばんは、$nameさん 👋';
  }

  @override
  String homeGreetingDefault(String name) {
    return 'こんにちは、$nameさん 👋';
  }

  @override
  String get homeGreetingNoName => 'ようこそ！👋';

  @override
  String homeUsageFree(int remaining, int limit) {
    return '無料 • 残り$remaining/$limit回';
  }

  @override
  String get homeSectionQuickActions => 'クイックアクション';

  @override
  String get homeSectionExplore => '探す';

  @override
  String get homeTrackerSummary => 'マイタスク';

  @override
  String get homePopularGuides => '人気のガイド';

  @override
  String get homeTrackerNoItems => 'まだタスクはありません。タップして追加しましょう。';

  @override
  String get homeQaChatTitle => 'AIガイドと話す';

  @override
  String get homeQaChatSubtitle => '日本での生活について何でも質問';

  @override
  String get homeQaBankingTitle => '銀行';

  @override
  String get homeQaBankingSubtitle => '口座開設、送金など';

  @override
  String get homeQaVisaTitle => 'ビザ';

  @override
  String get homeQaVisaSubtitle => '在留資格ガイド、手続き';

  @override
  String get homeQaMedicalTitle => '医療';

  @override
  String get homeQaMedicalSubtitle => '医療ガイド、緊急情報';

  @override
  String get homeExploreGuides => '全てのガイドを見る';

  @override
  String get homeExploreEmergency => '緊急連絡先';

  @override
  String get homeUpgradeTitle => 'AIアシスタントをもっと活用';

  @override
  String get homeUpgradeCta => '今すぐアップグレード';

  @override
  String get chatTitle => 'AIガイド';

  @override
  String get chatInputPlaceholder => 'メッセージを入力...';

  @override
  String get chatEmptyTitle => '何でも聞いてください！';

  @override
  String get chatEmptySubtitle => '銀行、ビザ、医療など、日本での生活に関する質問にお答えします。';

  @override
  String get chatSuggestBank => '銀行口座の開設方法は？';

  @override
  String get chatSuggestVisa => 'ビザの更新方法は？';

  @override
  String get chatSuggestMedical => '病院に行くには？';

  @override
  String get chatSuggestGeneral => '入国後に必要なことは？';

  @override
  String get chatSourcesHeader => '情報源';

  @override
  String get chatDisclaimer => 'これは一般的な情報であり、法的助言ではありません。必ず関係機関にご確認ください。';

  @override
  String chatLimitRemaining(int remaining, int limit) {
    return '無料チャット残り$remaining/$limit回';
  }

  @override
  String get chatLimitUpgrade => 'アップグレード';

  @override
  String get chatLimitExhausted => '無料チャットを使い切りました。';

  @override
  String get chatErrorSend => 'メッセージを送信できませんでした。もう一度お試しください。';

  @override
  String get chatErrorRetry => '再試行';

  @override
  String get chatDateToday => '今日';

  @override
  String get chatDateYesterday => '昨日';

  @override
  String get chatNewSession => '新規チャット';

  @override
  String get chatUntitledSession => '新規会話';

  @override
  String get chatDeleteTitle => 'チャットを削除';

  @override
  String get chatDeleteConfirm => 'このチャットを削除しますか？';

  @override
  String get chatDeleteCancel => 'キャンセル';

  @override
  String get chatDeleteAction => '削除';

  @override
  String get chatRetry => '再試行';

  @override
  String get countryCN => '中国';

  @override
  String get countryVN => 'ベトナム';

  @override
  String get countryKR => '韓国';

  @override
  String get countryPH => 'フィリピン';

  @override
  String get countryBR => 'ブラジル';

  @override
  String get countryNP => 'ネパール';

  @override
  String get countryID => 'インドネシア';

  @override
  String get countryUS => 'アメリカ';

  @override
  String get countryTH => 'タイ';

  @override
  String get countryIN => 'インド';

  @override
  String get countryMM => 'ミャンマー';

  @override
  String get countryTW => '台湾';

  @override
  String get countryPE => 'ペルー';

  @override
  String get countryGB => 'イギリス';

  @override
  String get countryPK => 'パキスタン';

  @override
  String get countryBD => 'バングラデシュ';

  @override
  String get countryLK => 'スリランカ';

  @override
  String get countryFR => 'フランス';

  @override
  String get countryDE => 'ドイツ';

  @override
  String get countryOther => 'その他';

  @override
  String get regionTokyo => '東京';

  @override
  String get regionOsaka => '大阪';

  @override
  String get regionNagoya => '名古屋';

  @override
  String get regionYokohama => '横浜';

  @override
  String get regionFukuoka => '福岡';

  @override
  String get regionSapporo => '札幌';

  @override
  String get regionKobe => '神戸';

  @override
  String get regionKyoto => '京都';

  @override
  String get regionSendai => '仙台';

  @override
  String get regionHiroshima => '広島';

  @override
  String get regionOther => 'その他';

  @override
  String get genericError => 'エラーが発生しました。もう一度お試しください。';

  @override
  String get networkError => 'ネットワークエラー。接続を確認してください。';

  @override
  String get logout => 'ログアウト';

  @override
  String get bankingTitle => '銀行ナビ';

  @override
  String get bankingFriendlyScore => '外国人向けスコア';

  @override
  String get bankingEmpty => '銀行が見つかりません';

  @override
  String get bankingRecommendButton => 'おすすめ';

  @override
  String get bankingRecommendTitle => 'おすすめ銀行';

  @override
  String get bankingSelectPriorities => '優先事項を選択';

  @override
  String get bankingPriorityMultilingual => '多言語サポート';

  @override
  String get bankingPriorityLowFee => '手数料が安い';

  @override
  String get bankingPriorityAtm => 'ATM網';

  @override
  String get bankingPriorityOnline => 'オンラインバンキング';

  @override
  String get bankingGetRecommendations => 'おすすめを見る';

  @override
  String get bankingRecommendHint => '優先事項を選択し、「おすすめを見る」をタップしてください';

  @override
  String get bankingNoRecommendations => 'おすすめが見つかりません';

  @override
  String get bankingViewGuide => 'ガイドを見る';

  @override
  String get bankingGuideTitle => '口座開設ガイド';

  @override
  String get bankingRequiredDocs => '必要書類';

  @override
  String get bankingConversationTemplates => '銀行での便利なフレーズ';

  @override
  String get bankingTroubleshooting => '困った時のヒント';

  @override
  String get bankingSource => '出典';

  @override
  String get visaTitle => '在留資格ナビ';

  @override
  String get visaEmpty => '手続きが見つかりませんでした';

  @override
  String get visaFilterAll => '全て';

  @override
  String get visaDetailTitle => '手続きの詳細';

  @override
  String get visaSteps => '手順';

  @override
  String get visaRequiredDocuments => '必要書類';

  @override
  String get visaFees => '費用';

  @override
  String get visaProcessingTime => '審査期間';

  @override
  String get visaDisclaimer => '重要：これは在留資格手続きに関する一般的な情報であり、法的助言ではありません。';

  @override
  String get trackerTitle => 'ToDo';

  @override
  String get trackerAddItem => '新しいToDo';

  @override
  String get trackerNoItems => 'まだToDoはありません';

  @override
  String get trackerNoItemsHint => '＋をタップして最初のToDoを追加しましょう';

  @override
  String get trackerAddTitle => 'タイトル';

  @override
  String get trackerAddMemo => 'メモ (任意)';

  @override
  String get trackerAddDueDate => '期限 (任意)';

  @override
  String get trackerDueToday => '本日期限';

  @override
  String get trackerOverdue => '期限切れ';

  @override
  String get trackerViewAll => '全て表示 →';

  @override
  String get trackerDeleteTitle => 'ToDoを削除';

  @override
  String get trackerDeleteConfirm => 'このToDoを削除しますか？';

  @override
  String get trackerLimitReached =>
      'フリープランではToDoを3つまで作成できます。無制限にするにはアップグレードしてください。';

  @override
  String get trackerAlreadyTracking => 'この項目はすでにToDoリストにあります';

  @override
  String get scannerTitle => '書類スキャナー';

  @override
  String get scannerDescription => '日本語の書類をスキャンして、即座に翻訳と説明を入手できます。';

  @override
  String get scannerFromCamera => 'カメラでスキャン';

  @override
  String get scannerFromGallery => 'ギャラリーから選択';

  @override
  String get scannerHistory => '履歴';

  @override
  String get scannerHistoryTitle => 'スキャン履歴';

  @override
  String get scannerHistoryEmpty => 'まだスキャン履歴はありません';

  @override
  String get scannerUnknownType => '不明な書類';

  @override
  String get scannerResultTitle => 'スキャン結果';

  @override
  String get scannerOriginalText => '原文 (日本語)';

  @override
  String get scannerTranslation => '翻訳';

  @override
  String get scannerExplanation => '意味';

  @override
  String get scannerProcessing => '書類を処理中...';

  @override
  String get scannerRefresh => '更新';

  @override
  String get scannerFailed => 'スキャンに失敗しました。もう一度お試しください。';

  @override
  String get scannerFreeLimitInfo => 'フリープラン：月3回までスキャン可能。追加スキャンにはアップグレードが必要です。';

  @override
  String get scannerLimitReached =>
      '月間スキャン上限に達しました。追加スキャンにはプレミアムにアップグレードしてください。';

  @override
  String get medicalTitle => '医療ガイド';

  @override
  String get medicalTabEmergency => '緊急時';

  @override
  String get medicalTabPhrases => '役立つフレーズ';

  @override
  String get medicalEmergencyNumber => '緊急連絡先';

  @override
  String get medicalHowToCall => 'かけ方';

  @override
  String get medicalWhatToPrepare => '準備するもの';

  @override
  String get medicalUsefulPhrases => '役立つフレーズ';

  @override
  String get medicalCategoryAll => '全て';

  @override
  String get medicalCategoryEmergency => '緊急時';

  @override
  String get medicalCategorySymptom => '症状';

  @override
  String get medicalCategoryInsurance => '保険';

  @override
  String get medicalCategoryGeneral => '一般';

  @override
  String get medicalNoPhrases => 'フレーズが見つかりませんでした';

  @override
  String get medicalDisclaimer =>
      'このガイドは一般的な健康情報を提供するものであり、専門的な医療アドバイスに代わるものではありません。緊急時には直ちに119番に電話してください。';

  @override
  String get navigateBanking => '銀行';

  @override
  String get navigateBankingDesc => '外国人向けの銀行を探す';

  @override
  String get navigateVisa => '在留資格';

  @override
  String get navigateVisaDesc => '在留資格の手続きと書類';

  @override
  String get navigateScanner => 'スキャナー';

  @override
  String get navigateScannerDesc => '日本語文書を翻訳';

  @override
  String get navigateMedical => '医療';

  @override
  String get navigateMedicalDesc => '緊急ガイド＆フレーズ';

  @override
  String get navigateCommunity => 'コミュニティ';

  @override
  String get navigateCommunityDesc => '他の外国人とのQ&A';

  @override
  String get upgradeToPremium => 'プレミアムにアップグレード';

  @override
  String get communityTitle => 'コミュニティQ&A';

  @override
  String get communityEmpty => 'まだ投稿はありません';

  @override
  String get communityNewPost => '新規投稿';

  @override
  String get communityDetailTitle => '投稿詳細';

  @override
  String get communityAnswered => '回答済み';

  @override
  String get communityBestAnswer => 'ベストアンサー';

  @override
  String get communityFilterAll => '全て';

  @override
  String get communitySortNewest => '新着順';

  @override
  String get communitySortPopular => '人気順';

  @override
  String get communityCategoryVisa => 'ビザ';

  @override
  String get communityCategoryHousing => '住居';

  @override
  String get communityCategoryBanking => '銀行';

  @override
  String get communityCategoryWork => '仕事';

  @override
  String get communityCategoryDailyLife => '日常生活';

  @override
  String get communityCategoryMedical => '医療';

  @override
  String get communityCategoryEducation => '教育';

  @override
  String get communityCategoryTax => '税金';

  @override
  String get communityCategoryOther => 'その他';

  @override
  String communityReplies(int count) {
    return '$count件の返信';
  }

  @override
  String get communityNoReplies => 'まだ返信がありません。最初に回答しましょう！';

  @override
  String get communityReplyHint => '返信を書き込む...';

  @override
  String get communityReplyPremiumOnly => '投稿と返信にはプレミアム登録が必要です。';

  @override
  String communityVoteCount(int count) {
    return '$count票';
  }

  @override
  String get communityModerationPending => '審査中';

  @override
  String get communityModerationFlagged => '審査のために報告されました';

  @override
  String get communityModerationNotice =>
      '投稿はAIモデレーションシステムによって審査された後、他のユーザーに表示されます。';

  @override
  String get communityChannelLabel => '言語チャンネル';

  @override
  String get communityCategoryLabel => 'カテゴリー';

  @override
  String get communityTitleLabel => 'タイトル';

  @override
  String get communityTitleHint => '質問内容は何ですか？';

  @override
  String get communityTitleMinLength => 'タイトルは5文字以上入力してください';

  @override
  String get communityContentLabel => '詳細';

  @override
  String get communityContentHint => '質問や状況を詳しく記述してください...';

  @override
  String get communityContentMinLength => '内容は10文字以上入力してください';

  @override
  String get communitySubmit => '投稿する';

  @override
  String communityTimeAgoDays(int days) {
    return '$days日前';
  }

  @override
  String communityTimeAgoHours(int hours) {
    return '$hours時間前';
  }

  @override
  String communityTimeAgoMinutes(int minutes) {
    return '$minutes分前';
  }

  @override
  String get subscriptionTitle => 'サブスクリプション';

  @override
  String get subscriptionPlansTitle => 'プランを選択';

  @override
  String get subscriptionPlansSubtitle => '日本生活ナビゲーターの全機能を解放しましょう';

  @override
  String get subscriptionCurrentPlan => '現在のプラン';

  @override
  String get subscriptionCurrentPlanBadge => '現在のプラン';

  @override
  String get subscriptionTierFree => '無料';

  @override
  String get subscriptionTierPremium => 'プレミアム';

  @override
  String get subscriptionTierPremiumPlus => 'プレミアムプラス';

  @override
  String get subscriptionFreePrice => '¥0';

  @override
  String subscriptionPricePerMonth(int price) {
    return '¥$price/月';
  }

  @override
  String get subscriptionCheckout => '今すぐ登録';

  @override
  String get subscriptionRecommended => 'おすすめ';

  @override
  String get subscriptionCancelling => '解約手続き中...';

  @override
  String subscriptionCancellingAt(String date) {
    return 'プランは$dateに終了します';
  }

  @override
  String get subscriptionFeatureFreeChat => 'AIチャット10回無料（永続）';

  @override
  String get subscriptionFeatureFreeScans => '月3回までの書類スキャン';

  @override
  String get subscriptionFeatureFreeTracker => '手続きを3件まで追跡';

  @override
  String get subscriptionFeatureFreeCommunityRead => 'コミュニティ投稿を閲覧';

  @override
  String get subscriptionFeatureCommunityPost => 'コミュニティで投稿・返信';

  @override
  String get subscriptionFeatureUnlimitedChat => 'AIチャット無制限';

  @override
  String get profileTitle => 'アカウント';

  @override
  String get profileEditTitle => 'プロフィール編集';

  @override
  String get profileEdit => 'プロフィール編集';

  @override
  String get profileEmail => 'メールアドレス';

  @override
  String get profileNationality => '国籍';

  @override
  String get profileResidenceStatus => '在留資格';

  @override
  String get profileRegion => '地域';

  @override
  String get profileLanguage => '言語';

  @override
  String get profileArrivalDate => '来日日';

  @override
  String get profileDisplayName => '表示名';

  @override
  String get profileNoName => '名無し';

  @override
  String get profileNameTooLong => '名前は100文字以内で入力してください';

  @override
  String get profileSaved => 'プロフィールを保存しました';

  @override
  String get profileSaveButton => '保存する';

  @override
  String get profileSaveError => 'プロフィールの保存に失敗しました';

  @override
  String get profileLoadError => 'プロフィールの読み込みに失敗しました';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsLanguageSection => '言語';

  @override
  String get settingsAccountSection => 'アカウント';

  @override
  String get settingsAboutSection => 'アプリについて';

  @override
  String get settingsLogout => 'ログアウト';

  @override
  String get settingsDeleteAccount => 'アカウント削除';

  @override
  String get settingsDeleteAccountSubtitle => 'この操作は取り消せません';

  @override
  String get settingsVersion => 'バージョン';

  @override
  String get settingsLogoutConfirmTitle => 'ログアウト';

  @override
  String get settingsLogoutConfirmMessage => 'ログアウトしますか？';

  @override
  String get settingsDeleteConfirmTitle => 'アカウント削除';

  @override
  String get settingsDeleteConfirmMessage =>
      'アカウントを削除しますか？この操作は取り消せません。すべてのデータが完全に削除されます。';

  @override
  String get settingsDeleteError => 'アカウントの削除に失敗しました';

  @override
  String get settingsCancel => 'キャンセル';

  @override
  String get settingsDelete => '削除する';

  @override
  String get settingsConfirm => '確定';

  @override
  String get navTitle => 'ガイド';

  @override
  String get navSubtitle => '日本での生活をナビゲートするためのトピックを探しましょう。';

  @override
  String navGuideCount(int count) {
    return '$count件のガイド';
  }

  @override
  String get navGuideCountOne => '1件のガイド';

  @override
  String get navComingSoon => '近日公開';

  @override
  String get navComingSoonSnackbar => '近日公開予定です。お楽しみに！';

  @override
  String get navErrorLoad => 'ガイドを読み込めませんでした。';

  @override
  String get navErrorRetry => 'タップして再試行';

  @override
  String get domainFinance => '金融・銀行';

  @override
  String get domainVisa => 'ビザ・入国管理';

  @override
  String get domainMedical => '医療・健康';

  @override
  String get domainLife => '日常生活';

  @override
  String get domainHousing => '住居・公共料金';

  @override
  String get domainTax => '税金・社会保険';

  @override
  String get domainEducation => '教育・育児';

  @override
  String get domainLegal => '法律・権利';

  @override
  String get guideSearchPlaceholder => 'ガイドを検索...';

  @override
  String get guideComingSoonTitle => '近日公開';

  @override
  String guideComingSoonSubtitle(String domain) {
    return '$domainのガイドを準備中です。もうしばらくお待ちください！';
  }

  @override
  String guideComingSoonAskAi(String domain) {
    return 'AIに$domainについて質問する';
  }

  @override
  String guideSearchEmpty(String query) {
    return '「$query」のガイドは見つかりませんでした。';
  }

  @override
  String get guideSearchTry => '別の検索ワードをお試しください。';

  @override
  String get guideErrorLoad => 'このカテゴリのガイドを読み込めませんでした。';

  @override
  String get guideAskAi => 'AIガイドとチャット（詳細を見る）';

  @override
  String get guideDisclaimer => '一般的な情報であり、法的助言ではありません。関連機関にご確認ください。';

  @override
  String get guideShare => '共有';

  @override
  String get guideErrorNotFound => 'このガイドは利用できません。';

  @override
  String get guideErrorLoadDetail => 'このガイドを読み込めません。もう一度お試しください。';

  @override
  String get guideErrorRetryBack => '戻る';

  @override
  String get emergencyTitle => '緊急時';

  @override
  String get emergencyWarning =>
      '緊急の危険がある場合は、すぐに110番（警察）または119番（消防・救急）に電話してください。';

  @override
  String get emergencySectionContacts => '緊急連絡先';

  @override
  String get emergencySectionAmbulance => '救急車の呼び方';

  @override
  String get emergencySectionMoreHelp => 'さらにヘルプが必要ですか？';

  @override
  String get emergencyPoliceName => '警察';

  @override
  String get emergencyPoliceNumber => '110';

  @override
  String get emergencyFireName => '消防・救急';

  @override
  String get emergencyFireNumber => '119';

  @override
  String get emergencyMedicalName => '医療相談';

  @override
  String get emergencyMedicalNumber => '#7119';

  @override
  String get emergencyMedicalNote => '緊急性のない医療相談';

  @override
  String get emergencyTellName => 'TELL Japan（心の健康）';

  @override
  String get emergencyTellNumber => '03-5774-0992';

  @override
  String get emergencyTellNote => '英語でのカウンセリング';

  @override
  String get emergencyHelplineName => 'ジャパン・ヘルプライン';

  @override
  String get emergencyHelplineNumber => '0570-064-211';

  @override
  String get emergencyHelplineNote => '24時間対応、多言語';

  @override
  String get emergencyStep1 => '119番に電話する';

  @override
  String get emergencyStep2 => '「救急です」と言う';

  @override
  String get emergencyStep3 => '場所を説明する（住所、目印など）';

  @override
  String get emergencyStep4 => '状況を説明する（何が起こったか、症状など）';

  @override
  String get emergencyStep5 => '建物の入り口で救急車を待つ';

  @override
  String get emergencyPhraseEmergencyHelp => '救急です';

  @override
  String get emergencyPhraseHelpHelp => '助けてください';

  @override
  String get emergencyPhraseAmbulanceHelp => '救急車をお願いします';

  @override
  String get emergencyPhraseAddressHelp => '住所は○○です';

  @override
  String get emergencyAskAi => 'AIに緊急時についてチャットで相談する';

  @override
  String get emergencyDisclaimer =>
      'このガイドは一般的な健康情報を提供するものであり、専門的な医療アドバイスに代わるものではありません。緊急時には、すぐに119番に電話してください。';

  @override
  String get emergencyCallButton => '電話をかける';

  @override
  String get emergencyOffline => '追加情報を読み込めません。助けが必要な場合は、110番または119番に電話してください。';

  @override
  String get subTitle => 'サブスクリプション';

  @override
  String get subSectionCurrent => '現在のプラン';

  @override
  String get subSectionChoose => 'プランを選択';

  @override
  String get subSectionCharge => 'もっとチャットが必要ですか？';

  @override
  String get subSectionFaq => 'FAQ';

  @override
  String get subCurrentFree => '無料プラン';

  @override
  String get subCurrentStandard => 'スタンダードプラン';

  @override
  String get subCurrentPremium => 'プレミアムプラン';

  @override
  String get subUpgradeNow => '今すぐアップグレード';

  @override
  String get subPlanFree => '無料';

  @override
  String get subPlanStandard => 'スタンダード';

  @override
  String get subPlanPremium => 'プレミアム';

  @override
  String get subPriceFree => '¥0';

  @override
  String get subPriceStandard => '¥720';

  @override
  String get subPricePremium => '¥1,360';

  @override
  String get subPriceInterval => '/月';

  @override
  String get subRecommended => 'おすすめ';

  @override
  String get subFeatureChatFree => 'AIガイドチャット 10回（生涯）';

  @override
  String get subFeatureChatStandard => 'AIガイドチャット 300回/月';

  @override
  String get subFeatureChatPremium => 'AIガイドチャット 無制限';

  @override
  String get subFeatureTrackerFree => 'トラッカーアイテム 3件まで';

  @override
  String get subFeatureTrackerPaid => 'トラッカーアイテム 無制限';

  @override
  String get subFeatureAdsYes => '広告あり';

  @override
  String get subFeatureAdsNo => '広告なし';

  @override
  String get subFeatureGuideFree => '一部ガイドを閲覧';

  @override
  String get subFeatureGuidePaid => '全ガイドを閲覧';

  @override
  String get subFeatureImageNo => 'AI画像分析 (チャット内)';

  @override
  String get subFeatureImageYes => 'AI画像分析 (チャット内)';

  @override
  String get subButtonCurrent => '現在のプラン';

  @override
  String subButtonChoose(String plan) {
    return '$planを選択';
  }

  @override
  String get subCharge100 => '100チャットパック';

  @override
  String get subCharge50 => '50チャットパック';

  @override
  String get subCharge100Price => '¥360 (1チャットあたり¥3.6)';

  @override
  String get subCharge50Price => '¥180 (1チャットあたり¥3.6)';

  @override
  String get subChargeDescription => '有効期限なしの追加チャット。プランの上限を超えた後に使用されます。';

  @override
  String get subFaqBillingQ => '請求について';

  @override
  String get subFaqBillingA =>
      'サブスクリプションはApp StoreまたはGoogle Playを通じて毎月請求されます。購読の管理はデバイスの設定から行えます。';

  @override
  String get subFaqCancelQ => 'いつでも解約できますか？';

  @override
  String get subFaqCancelA => 'はい、いつでも解約可能です。プランは請求期間の終了まで有効です。';

  @override
  String get subFaqDowngradeQ => 'ダウングレードした場合どうなりますか？';

  @override
  String get subFaqDowngradeA =>
      'ダウングレードした場合、現在のプラン特典は請求期間の終了まで保持されます。その後、新しいティアのプランに切り替わります。';

  @override
  String get subFooter => 'App Store / Google Playで購読を管理';

  @override
  String subPurchaseSuccess(String plan) {
    return '$planへようこそ！アップグレードが完了しました。';
  }

  @override
  String get subPurchaseError => '購入を完了できませんでした。もう一度お試しください。';

  @override
  String get subErrorLoad => '購読プランを読み込めませんでした。';

  @override
  String get subErrorRetry => 'タップして再試行';

  @override
  String get profileSectionInfo => 'お客様情報';

  @override
  String get profileSectionStats => '利用統計';

  @override
  String get profileChatsToday => '今日のチャット数';

  @override
  String get profileMemberSince => '登録日';

  @override
  String get profileManageSubscription => '購読の管理';

  @override
  String get profileNotSet => '未設定';

  @override
  String get editTitle => 'プロフィールを編集';

  @override
  String get editSave => '保存する';

  @override
  String get editNameLabel => '表示名';

  @override
  String get editNameHint => '名前を入力';

  @override
  String get editNationalityLabel => '国籍';

  @override
  String get editNationalityHint => '国籍を選択';

  @override
  String get editStatusLabel => '在留資格';

  @override
  String get editStatusHint => '在留資格を選択';

  @override
  String get editRegionLabel => '地域';

  @override
  String get editRegionHint => '地域を選択';

  @override
  String get editLanguageLabel => '希望言語';

  @override
  String get editChangePhoto => '写真変更';

  @override
  String get editSuccess => 'プロフィールを更新しました。';

  @override
  String get editError => 'プロフィールを更新できませんでした。もう一度お試しください。';

  @override
  String get editUnsavedTitle => '未保存の変更があります';

  @override
  String get editUnsavedMessage => '未保存の変更があります。破棄しますか？';

  @override
  String get editUnsavedDiscard => '破棄';

  @override
  String get editUnsavedKeep => '編集を続ける';

  @override
  String get settingsSectionGeneral => '一般';

  @override
  String get settingsSectionAccount => 'アカウント';

  @override
  String get settingsSectionDanger => '危険な設定';

  @override
  String get settingsSectionAbout => 'このアプリについて';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsNotifications => '通知';

  @override
  String get settingsSubscription => '購読';

  @override
  String get settingsTerms => '利用規約';

  @override
  String get settingsPrivacy => 'プライバシーポリシー';

  @override
  String get settingsContact => 'お問い合わせ';

  @override
  String get settingsFooter => '日本での生活をナビゲートする全ての人へ❤️を込めて';

  @override
  String get settingsLogoutTitle => 'ログアウト';

  @override
  String get settingsLogoutMessage => 'ログアウトしますか？';

  @override
  String get settingsLogoutConfirm => 'ログアウト';

  @override
  String get settingsLogoutCancel => 'キャンセル';

  @override
  String get settingsDeleteTitle => 'アカウントを削除';

  @override
  String get settingsDeleteMessage => 'この操作は元に戻せません。すべてのデータが完全に削除されます。続行しますか？';

  @override
  String get settingsDeleteConfirmAction => 'アカウントを削除する';

  @override
  String get settingsDeleteCancel => 'キャンセル';

  @override
  String get settingsDeleteSuccess => 'アカウントが削除されました。';

  @override
  String get settingsLanguageTitle => '言語を選択';

  @override
  String get settingsErrorLogout => 'ログアウトできませんでした。もう一度お試しください。';

  @override
  String get settingsErrorDelete => 'アカウントを削除できませんでした。もう一度お試しください。';

  @override
  String get chatGuestTitle => '日本の生活についてAIに質問する';

  @override
  String get chatGuestFeature1 => '銀行口座の開設方法';

  @override
  String get chatGuestFeature2 => 'ビザ更新の手続き';

  @override
  String get chatGuestFeature3 => '病院の受診方法';

  @override
  String get chatGuestFeature4 => 'その他なんでも';

  @override
  String get chatGuestFreeOffer => '無料チャットを5回お試しください（登録不要）';

  @override
  String get chatGuestSignUp => '無料で始める';

  @override
  String get chatGuestLogin => 'すでにアカウントをお持ちの方はこちらからログイン';

  @override
  String get guestRegisterCta => 'AIチャットを無料で利用するには新規登録';

  @override
  String get guideReadMore => '全文を読むには新規登録';

  @override
  String get guideAskAI => 'AIに詳細を質問する';

  @override
  String get guideGuestCtaButton => '無料アカウントを作成';

  @override
  String get homeGuestCtaText => '無料アカウントを作成して、AIチャットとパーソナライズされたガイドを解除しましょう';

  @override
  String get homeGuestCtaButton => '始める';

  @override
  String get chatUpgradeBanner => 'プレミアムにアップグレードしてチャット無制限';

  @override
  String get chatUpgradeButton => 'プランを見る';

  @override
  String get guidePremiumCta => 'このコンテンツはプレミアムプランでご利用いただけます';

  @override
  String get guidePremiumCtaButton => 'プランを見る';

  @override
  String get guideTierLimitError => '全文ガイドにアクセスするにはアップグレードしてください';

  @override
  String get trackerSave => '保存';

  @override
  String get trackerSaved => '保存しました';

  @override
  String get trackerItemSaved => 'やることリストに追加しました';

  @override
  String get homeQaTrackerTitle => 'やることリスト';

  @override
  String get homeQaTrackerSubtitle => 'やることリストを管理する';

  @override
  String get chatAttachPhoto => '写真を撮る';

  @override
  String get chatAttachGallery => 'ギャラリーから選択';

  @override
  String get chatAttachCancel => 'キャンセル';

  @override
  String get chatImageTooLarge => '画像が大きすぎます（最大5MB）';

  @override
  String get profilePersonalizationHint =>
      'プロファイルを完了すると、AIガイドがよりパーソナライズされたアドバイスを提供します';

  @override
  String get profileVisaExpiry => 'ビザ有効期限';

  @override
  String get profileResidenceRegion => '居住地';

  @override
  String get profilePreferredLanguage => '使用言語';

  @override
  String get profileSelectNationality => '国籍を選択';

  @override
  String get profileSelectResidenceStatus => '在留資格を選択';

  @override
  String get profileSelectPrefecture => '都道府県を選択';

  @override
  String get profileSelectCity => '市区町村を選択';

  @override
  String get profileSelectLanguage => '言語を選択';

  @override
  String get profileCommonStatuses => '一般';

  @override
  String get profileOtherStatuses => 'その他';

  @override
  String get profileSearchNationality => '国籍を検索';

  @override
  String get visaRenewalPrepTitle => 'ビザ更新申請の準備';

  @override
  String get visaRenewalDeadlineTitle => 'ビザ更新期限';

  @override
  String get profileSave => '保存';

  @override
  String get profileUsageStats => '利用状況';

  @override
  String get profileLogout => 'ログアウト';

  @override
  String get profileDeleteAccount => 'アカウントを削除';

  @override
  String get subUsageTitle => '利用状況';

  @override
  String subUsageCount(int used, int limit) {
    return '$used / $limit チャット使用済み';
  }

  @override
  String get subUsageUnlimited => 'チャット無制限';

  @override
  String get tabAccount => 'アカウント';

  @override
  String get accountSectionProfile => 'プロフィール';

  @override
  String get accountSectionManagement => 'アカウント';

  @override
  String get accountSectionDanger => '危険な設定';

  @override
  String get notificationSettingsTitle => '通知設定';

  @override
  String get notificationTodoReminder => 'Todoリマインダー';

  @override
  String get notificationReminderTime => '通知時刻';

  @override
  String get notificationEnabled => '有効';

  @override
  String get notificationDisabled => '無効';

  @override
  String get guideLocked => '全ガイドを読むには登録してください';

  @override
  String get guideUpgradePrompt => '全45ガイドを見るには無料アカウントを作成';

  @override
  String get guideUpgradeButton => '無料アカウントを作成する';

  @override
  String chatGuestUsageHint(int remaining) {
    return '残り$remaining回無料でチャットできます';
  }

  @override
  String get chatGuestExhausted => 'チャットを続けるには登録してください — さらに10回無料';

  @override
  String get chatFreeExhausted => 'スタンダードプランで月300回チャット';

  @override
  String usageLifetimeRemaining(int remaining, int limit) {
    return '残り$limit回中$remaining回';
  }

  @override
  String get chatGuestWelcome => '日本での生活について何でも質問してください';

  @override
  String get registerNationalityLabel => '国籍';

  @override
  String get registerNationalityHint => '国籍を選択してください';

  @override
  String get registerResidenceStatusLabel => '在留資格';

  @override
  String get registerResidenceStatusHint => '在留資格を選択してください';

  @override
  String get registerResidenceRegionLabel => '居住地';

  @override
  String get registerResidenceRegionHint => '居住地を選択してください';

  @override
  String get registerSearchHint => '検索...';

  @override
  String get chatDepthLevelDeep => '詳細な回答';

  @override
  String chatUsageDeepRemaining(int remaining, int limit) {
    return '詳細: $remaining/$limit';
  }

  @override
  String chatCreditsRemaining(int remaining) {
    return '残りチャット回数: $remaining回';
  }

  @override
  String get trialSetupTitle => 'AIガイドにあなたのことを教えてください';

  @override
  String get trialSetupNationality => '国籍';

  @override
  String get trialSetupResidenceStatus => '在留資格';

  @override
  String get trialSetupRegion => '居住地';

  @override
  String get trialSetupSubmit => '開始する';

  @override
  String get navAiSearchTitle => 'AIガイドでスマート検索';

  @override
  String get navAiSearchSubtitle => 'あなたの状況に合わせた個別情報をお届けします';

  @override
  String get navAiSearchButton => '今すぐ試す';

  @override
  String guideCount(int count) {
    return '$count件のガイド';
  }

  @override
  String get guideFreeLabel => '無料';

  @override
  String guideReadingTime(int min) {
    return '$min分で読めます';
  }

  @override
  String get guideRelatedTitle => 'この分野の他のガイド';

  @override
  String get trackerEditTitle => 'トラッカーに追加';

  @override
  String get trackerEditFieldTitle => 'タイトル';

  @override
  String get trackerEditFieldMemo => 'メモ（任意）';

  @override
  String get trackerEditFieldDate => '期限日（任意）';

  @override
  String get trackerEditSave => 'トラッカーに保存する';

  @override
  String get trackerEditCancel => 'キャンセル';

  @override
  String get testFlightHomeBannerText =>
      '日本生活ガイドをすべて無料で閲覧。プロフィールを設定してAIガイドの無料セッションを5回解放しましょう';

  @override
  String get testFlightHomeBannerCta => '設定して開始する';

  @override
  String get testFlightChatSetupPrompt => '無料AIガイドを始めるにはプロフィールを設定してください';

  @override
  String get testFlightChatSetupButton => '設定して始める';

  @override
  String get testFlightViewGuides => '全てのガイドを見る';

  @override
  String get trialSetupSubtitle => 'あなたの情報に基づき、AIガイドがパーソナルな回答を提供します';

  @override
  String get signInFailed => 'サインインに失敗しました。ネットワーク接続を確認してください。';
}
