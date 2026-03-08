// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Gaijin Life Navi';

  @override
  String get langTitle => 'Escolha seu idioma';

  @override
  String get langContinue => 'Continuar';

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
  String get loginWelcome => 'Entre na sua conta';

  @override
  String get loginSubtitle => 'Faça login para continuar';

  @override
  String get loginEmailLabel => 'E-mail';

  @override
  String get loginEmailHint => 'your@email.com';

  @override
  String get loginPasswordLabel => 'Senha';

  @override
  String get loginPasswordHint => 'Digite sua senha';

  @override
  String get loginForgotPassword => 'Esqueceu a senha?';

  @override
  String get loginButton => 'Entrar';

  @override
  String get loginNoAccount => 'Não tem uma conta?';

  @override
  String get loginSignUp => 'Cadastre-se';

  @override
  String get loginErrorInvalidEmail =>
      'Por favor, insira um endereço de e-mail válido.';

  @override
  String get loginErrorInvalidCredentials =>
      'E-mail ou senha incorretos. Tente novamente.';

  @override
  String get loginErrorNetwork =>
      'Não foi possível conectar. Verifique sua conexão com a internet.';

  @override
  String get loginErrorTooManyAttempts =>
      'Muitas tentativas. Tente novamente mais tarde.';

  @override
  String get registerTitle => 'Crie sua conta';

  @override
  String get registerSubtitle => 'Comece sua jornada no Japão';

  @override
  String get registerEmailLabel => 'E-mail';

  @override
  String get registerEmailHint => 'your@email.com';

  @override
  String get registerPasswordLabel => 'Senha';

  @override
  String get registerPasswordHint => 'Crie uma senha';

  @override
  String get registerPasswordHelper => '8 ou mais caracteres';

  @override
  String get registerConfirmLabel => 'Confirmar senha';

  @override
  String get registerConfirmHint => 'Digite sua senha novamente';

  @override
  String get registerTermsAgree => 'Eu concordo com os ';

  @override
  String get registerTermsLink => 'Termos de Serviço';

  @override
  String get registerPrivacyAnd => 'e';

  @override
  String get registerPrivacyLink => 'Política de Privacidade';

  @override
  String get registerButton => 'Criar conta';

  @override
  String get registerHasAccount => 'Já tem uma conta?';

  @override
  String get registerSignIn => 'Entrar';

  @override
  String get registerErrorEmailInvalid =>
      'Por favor, insira um endereço de e-mail válido.';

  @override
  String get registerErrorEmailInUse =>
      'Este e-mail já está registrado. Tente fazer login.';

  @override
  String get registerErrorPasswordShort =>
      'A senha deve ter pelo menos 8 caracteres.';

  @override
  String get registerErrorPasswordMismatch => 'As senhas não coincidem.';

  @override
  String get registerErrorTermsRequired =>
      'Por favor, concorde com os Termos de Serviço.';

  @override
  String get resetTitle => 'Redefinir sua senha';

  @override
  String get resetSubtitle =>
      'Digite seu e-mail e enviaremos um link de redefinição.';

  @override
  String get resetEmailLabel => 'E-mail';

  @override
  String get resetEmailHint => 'your@email.com';

  @override
  String get resetButton => 'Enviar link de redefinição';

  @override
  String get resetBackToLogin => 'Voltar para login';

  @override
  String get resetSuccessTitle => 'Verifique seu e-mail';

  @override
  String resetSuccessSubtitle(String email) {
    return 'Enviamos um link de redefinição para $email';
  }

  @override
  String get resetResend => 'Não recebeu? Reenviar';

  @override
  String get resetErrorEmailInvalid =>
      'Por favor, insira um endereço de e-mail válido.';

  @override
  String get onboardingSkip => 'Pular';

  @override
  String get onboardingNext => 'Próximo';

  @override
  String get onboardingGetStarted => 'Começar';

  @override
  String onboardingStepOf(int current, int total) {
    return 'Passo $current de $total';
  }

  @override
  String get onboardingS1Title => 'Qual é a sua nacionalidade?';

  @override
  String get onboardingS1Subtitle =>
      'Isso nos ajuda a fornecer informações relevantes.';

  @override
  String get onboardingS2Title => 'Qual é o seu status de residência?';

  @override
  String get onboardingS2Subtitle =>
      'Podemos personalizar informações sobre visto para você.';

  @override
  String get onboardingS3Title => 'Onde você mora no Japão?';

  @override
  String get onboardingS3Subtitle => 'Para guias específicos da região.';

  @override
  String get onboardingS4Title => 'Quando você chegou ao Japão?';

  @override
  String get onboardingS4Subtitle =>
      'Vamos sugerir tarefas urgentes que você precisa concluir.';

  @override
  String get onboardingS4Placeholder => 'Selecione a data';

  @override
  String get onboardingS4NotYet => 'Ainda não cheguei';

  @override
  String get onboardingChangeDate => 'Alterar data';

  @override
  String get onboardingErrorSave =>
      'Não foi possível salvar suas informações. Tente novamente.';

  @override
  String get statusEngineer => 'Engenheiro / Especialista em Humanidades';

  @override
  String get statusStudent => 'Estudante';

  @override
  String get statusDependent => 'Dependente';

  @override
  String get statusPermanent => 'Residente permanente';

  @override
  String get statusSpouse => 'Cônjuge de nacional japonês';

  @override
  String get statusWorkingHoliday => 'Working Holiday';

  @override
  String get statusSpecifiedSkilled => 'Trabalhador qualificado específico';

  @override
  String get statusOther => 'Outro';

  @override
  String get tabHome => 'Início';

  @override
  String get tabChat => 'AI Guia';

  @override
  String get tabGuide => 'Guia';

  @override
  String get tabSOS => 'SOS';

  @override
  String get tabProfile => 'Perfil';

  @override
  String homeGreetingMorning(String name) {
    return 'Bom dia, $name 👋';
  }

  @override
  String homeGreetingAfternoon(String name) {
    return 'Boa tarde, $name 👋';
  }

  @override
  String homeGreetingEvening(String name) {
    return 'Boa noite, $name 👋';
  }

  @override
  String homeGreetingDefault(String name) {
    return 'Olá, $name 👋';
  }

  @override
  String get homeGreetingNoName => 'Bem-vindo! 👋';

  @override
  String homeUsageFree(int remaining, int limit) {
    return 'Grátis • $remaining/$limit chats restantes hoje';
  }

  @override
  String get homeSectionQuickActions => 'Ações rápidas';

  @override
  String get homeSectionExplore => 'Explorar';

  @override
  String get homeTrackerSummary => 'Minhas Tarefas';

  @override
  String get homePopularGuides => 'Guias Populares';

  @override
  String get homeTrackerNoItems =>
      'Nenhuma tarefa ainda. Toque para adicionar.';

  @override
  String get homeQaChatTitle => 'Chat IA';

  @override
  String get homeQaChatSubtitle =>
      'Pergunte qualquer coisa sobre a vida no Japão';

  @override
  String get homeQaBankingTitle => 'Banco';

  @override
  String get homeQaBankingSubtitle =>
      'Abertura de conta, transferências e mais';

  @override
  String get homeQaVisaTitle => 'Visto';

  @override
  String get homeQaVisaSubtitle => 'Guias e procedimentos de imigração';

  @override
  String get homeQaMedicalTitle => 'Saúde';

  @override
  String get homeQaMedicalSubtitle =>
      'Guias de saúde e informações de emergência';

  @override
  String get homeExploreGuides => 'Ver todos os guias';

  @override
  String get homeExploreEmergency => 'Contatos de emergência';

  @override
  String get homeUpgradeTitle => 'Aproveite mais do seu assistente IA';

  @override
  String get homeUpgradeCta => 'Upgrade agora';

  @override
  String get chatTitle => 'AI Guia';

  @override
  String get chatInputPlaceholder => 'Digite sua mensagem...';

  @override
  String get chatEmptyTitle => 'Pergunte-me qualquer coisa!';

  @override
  String get chatEmptySubtitle =>
      'Posso ajudar com perguntas sobre banco, visto, saúde e mais sobre a vida no Japão.';

  @override
  String get chatSuggestBank => 'Como abro uma conta bancária?';

  @override
  String get chatSuggestVisa => 'Como renovar meu visto?';

  @override
  String get chatSuggestMedical => 'Como consultar um médico?';

  @override
  String get chatSuggestGeneral =>
      'O que preciso fazer depois de chegar ao Japão?';

  @override
  String get chatSourcesHeader => 'Fontes';

  @override
  String get chatDisclaimer =>
      'Esta é apenas informação geral. Não constitui aconselhamento jurídico. Verifique com as autoridades competentes.';

  @override
  String chatLimitRemaining(int remaining, int limit) {
    return '$remaining/$limit chats grátis restantes hoje.';
  }

  @override
  String get chatLimitUpgrade => 'Upgrade';

  @override
  String get chatLimitExhausted => 'Você usou todos os seus chats grátis.';

  @override
  String get chatErrorSend =>
      'Não foi possível enviar sua mensagem. Tente novamente.';

  @override
  String get chatErrorRetry => 'Tentar novamente';

  @override
  String get chatDateToday => 'Hoje';

  @override
  String get chatDateYesterday => 'Ontem';

  @override
  String get chatNewSession => 'Novo Chat';

  @override
  String get chatUntitledSession => 'Nova Conversa';

  @override
  String get chatDeleteTitle => 'Excluir Chat';

  @override
  String get chatDeleteConfirm =>
      'Tem certeza de que deseja excluir este chat?';

  @override
  String get chatDeleteCancel => 'Cancelar';

  @override
  String get chatDeleteAction => 'Excluir';

  @override
  String get chatRetry => 'Tentar novamente';

  @override
  String get countryCN => 'China';

  @override
  String get countryVN => 'Vietnã';

  @override
  String get countryKR => 'Coreia do Sul';

  @override
  String get countryPH => 'Filipinas';

  @override
  String get countryBR => 'Brasil';

  @override
  String get countryNP => 'Nepal';

  @override
  String get countryID => 'Indonésia';

  @override
  String get countryUS => 'Estados Unidos';

  @override
  String get countryTH => 'Tailândia';

  @override
  String get countryIN => 'Índia';

  @override
  String get countryMM => 'Mianmar';

  @override
  String get countryTW => 'Taiwan';

  @override
  String get countryPE => 'Peru';

  @override
  String get countryGB => 'Reino Unido';

  @override
  String get countryPK => 'Paquistão';

  @override
  String get countryBD => 'Bangladesh';

  @override
  String get countryLK => 'Sri Lanka';

  @override
  String get countryFR => 'França';

  @override
  String get countryDE => 'Alemanha';

  @override
  String get countryOther => 'Outro';

  @override
  String get regionTokyo => 'Tóquio';

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
  String get regionOther => 'Outro';

  @override
  String get genericError => 'Algo deu errado. Tente novamente.';

  @override
  String get networkError => 'Erro de rede. Verifique sua conexão.';

  @override
  String get logout => 'Sair';

  @override
  String get bankingTitle => 'Navegador Bancário';

  @override
  String get bankingFriendlyScore => 'Pontuação de Amigabilidade';

  @override
  String get bankingEmpty => 'Nenhum banco encontrado';

  @override
  String get bankingRecommendButton => 'Recomendar';

  @override
  String get bankingRecommendTitle => 'Recomendações de Bancos';

  @override
  String get bankingSelectPriorities => 'Selecione suas prioridades';

  @override
  String get bankingPriorityMultilingual => 'Suporte Multilíngue';

  @override
  String get bankingPriorityLowFee => 'Taxas Baixas';

  @override
  String get bankingPriorityAtm => 'Rede de ATMs';

  @override
  String get bankingPriorityOnline => 'Internet Banking';

  @override
  String get bankingGetRecommendations => 'Obter Recomendações';

  @override
  String get bankingRecommendHint =>
      'Selecione prioridades e toque em Obter Recomendações';

  @override
  String get bankingNoRecommendations => 'Nenhuma recomendação encontrada';

  @override
  String get bankingViewGuide => 'Ver Guia';

  @override
  String get bankingGuideTitle => 'Guia de Abertura de Conta';

  @override
  String get bankingRequiredDocs => 'Documentos Necessários';

  @override
  String get bankingConversationTemplates => 'Frases Úteis no Banco';

  @override
  String get bankingTroubleshooting => 'Solução de Problemas';

  @override
  String get bankingSource => 'Fonte';

  @override
  String get visaTitle => 'Navegador de Visto';

  @override
  String get visaEmpty => 'Nenhum procedimento encontrado';

  @override
  String get visaFilterAll => 'Todos';

  @override
  String get visaDetailTitle => 'Detalhes do Procedimento';

  @override
  String get visaSteps => 'Etapas';

  @override
  String get visaRequiredDocuments => 'Documentos Necessários';

  @override
  String get visaFees => 'Taxas';

  @override
  String get visaProcessingTime => 'Tempo de Processamento';

  @override
  String get visaDisclaimer =>
      'IMPORTANTE: Informações gerais sobre procedimentos de visto. Não constitui aconselhamento de imigração.';

  @override
  String get trackerTitle => 'Tarefas';

  @override
  String get trackerAddItem => 'Nova Tarefa';

  @override
  String get trackerNoItems => 'Nenhuma tarefa ainda';

  @override
  String get trackerNoItemsHint =>
      'Toque em + para adicionar sua primeira tarefa';

  @override
  String get trackerAddTitle => 'Título';

  @override
  String get trackerAddMemo => 'Notas (opcional)';

  @override
  String get trackerAddDueDate => 'Data limite (opcional)';

  @override
  String get trackerDueToday => 'Vence hoje';

  @override
  String get trackerOverdue => 'Atrasada';

  @override
  String get trackerViewAll => 'Ver todas →';

  @override
  String get trackerDeleteTitle => 'Excluir Tarefa';

  @override
  String get trackerDeleteConfirm =>
      'Tem certeza de que deseja excluir esta tarefa?';

  @override
  String get trackerLimitReached =>
      'Plano grátis permite até 3. Atualize para ilimitado.';

  @override
  String get trackerAlreadyTracking => 'Esta tarefa já está na sua lista';

  @override
  String get scannerTitle => 'Scanner de Documentos';

  @override
  String get scannerDescription =>
      'Digitalize documentos japoneses para tradução e explicação instantâneas';

  @override
  String get scannerFromCamera => 'Digitalizar da Câmera';

  @override
  String get scannerFromGallery => 'Escolher da Galeria';

  @override
  String get scannerHistory => 'Histórico';

  @override
  String get scannerHistoryTitle => 'Histórico de Digitalizações';

  @override
  String get scannerHistoryEmpty => 'Nenhuma digitalização ainda';

  @override
  String get scannerUnknownType => 'Documento Desconhecido';

  @override
  String get scannerResultTitle => 'Resultado da Digitalização';

  @override
  String get scannerOriginalText => 'Texto Original (Japonês)';

  @override
  String get scannerTranslation => 'Tradução';

  @override
  String get scannerExplanation => 'O Que Significa';

  @override
  String get scannerProcessing => 'Processando seu documento...';

  @override
  String get scannerRefresh => 'Atualizar';

  @override
  String get scannerFailed => 'Digitalização falhou. Tente novamente.';

  @override
  String get scannerFreeLimitInfo =>
      'Grátis: 3 digitalizações/mês. Faça upgrade para mais.';

  @override
  String get scannerLimitReached =>
      'Limite mensal de digitalizações atingido. Faça upgrade para mais.';

  @override
  String get medicalTitle => 'Guia Médico';

  @override
  String get medicalTabEmergency => 'Emergência';

  @override
  String get medicalTabPhrases => 'Frases';

  @override
  String get medicalEmergencyNumber => 'Número de Emergência';

  @override
  String get medicalHowToCall => 'Como Ligar';

  @override
  String get medicalWhatToPrepare => 'O Que Preparar';

  @override
  String get medicalUsefulPhrases => 'Frases Úteis';

  @override
  String get medicalCategoryAll => 'Todos';

  @override
  String get medicalCategoryEmergency => 'Emergência';

  @override
  String get medicalCategorySymptom => 'Sintomas';

  @override
  String get medicalCategoryInsurance => 'Seguro';

  @override
  String get medicalCategoryGeneral => 'Geral';

  @override
  String get medicalNoPhrases => 'Nenhuma frase encontrada';

  @override
  String get medicalDisclaimer =>
      'Este guia fornece informações gerais de saúde e não substitui orientação médica profissional. Em caso de emergência, ligue 119 imediatamente.';

  @override
  String get navigateBanking => 'Banco';

  @override
  String get navigateBankingDesc => 'Encontre bancos amigáveis ao estrangeiro';

  @override
  String get navigateVisa => 'Visto';

  @override
  String get navigateVisaDesc => 'Procedimentos & documentos de visto';

  @override
  String get navigateScanner => 'Scanner';

  @override
  String get navigateScannerDesc => 'Traduza documentos japoneses';

  @override
  String get navigateMedical => 'Saúde';

  @override
  String get navigateMedicalDesc => 'Guia de emergência & frases';

  @override
  String get navigateCommunity => 'Comunidade';

  @override
  String get navigateCommunityDesc =>
      'Perguntas e respostas com outros estrangeiros';

  @override
  String get upgradeToPremium => 'Upgrade para Premium';

  @override
  String get communityTitle => 'Q&A Comunitário';

  @override
  String get communityEmpty => 'Nenhuma publicação ainda';

  @override
  String get communityNewPost => 'Nova Publicação';

  @override
  String get communityDetailTitle => 'Detalhe da Publicação';

  @override
  String get communityAnswered => 'Respondido';

  @override
  String get communityBestAnswer => 'Melhor Resposta';

  @override
  String get communityFilterAll => 'Todos';

  @override
  String get communitySortNewest => 'Mais Recentes';

  @override
  String get communitySortPopular => 'Populares';

  @override
  String get communityCategoryVisa => 'Visto';

  @override
  String get communityCategoryHousing => 'Moradia';

  @override
  String get communityCategoryBanking => 'Banco';

  @override
  String get communityCategoryWork => 'Trabalho';

  @override
  String get communityCategoryDailyLife => 'Dia a Dia';

  @override
  String get communityCategoryMedical => 'Saúde';

  @override
  String get communityCategoryEducation => 'Educação';

  @override
  String get communityCategoryTax => 'Impostos';

  @override
  String get communityCategoryOther => 'Outro';

  @override
  String communityReplies(int count) {
    return '$count Respostas';
  }

  @override
  String get communityNoReplies => 'Sem respostas ainda. Seja o primeiro!';

  @override
  String get communityReplyHint => 'Escreva uma resposta...';

  @override
  String get communityReplyPremiumOnly =>
      'Publicar e responder requer assinatura Premium.';

  @override
  String communityVoteCount(int count) {
    return '$count votos';
  }

  @override
  String get communityModerationPending => 'Em análise';

  @override
  String get communityModerationFlagged => 'Marcado para análise';

  @override
  String get communityModerationNotice =>
      'Sua publicação será revisada pelo nosso sistema de moderação por IA antes de ficar visível.';

  @override
  String get communityChannelLabel => 'Canal de Idioma';

  @override
  String get communityCategoryLabel => 'Categoria';

  @override
  String get communityTitleLabel => 'Título';

  @override
  String get communityTitleHint => 'Qual é a sua pergunta?';

  @override
  String get communityTitleMinLength =>
      'O título deve ter pelo menos 5 caracteres';

  @override
  String get communityContentLabel => 'Detalhes';

  @override
  String get communityContentHint =>
      'Descreva sua pergunta ou situação em detalhes...';

  @override
  String get communityContentMinLength =>
      'O conteúdo deve ter pelo menos 10 caracteres';

  @override
  String get communitySubmit => 'Publicar';

  @override
  String communityTimeAgoDays(int days) {
    return 'há ${days}d';
  }

  @override
  String communityTimeAgoHours(int hours) {
    return 'há ${hours}h';
  }

  @override
  String communityTimeAgoMinutes(int minutes) {
    return 'há ${minutes}m';
  }

  @override
  String get subscriptionTitle => 'Assinatura';

  @override
  String get subscriptionPlansTitle => 'Escolha seu Plano';

  @override
  String get subscriptionPlansSubtitle =>
      'Desbloqueie todo o potencial do Gaijin Life Navi';

  @override
  String get subscriptionCurrentPlan => 'Plano Atual';

  @override
  String get subscriptionCurrentPlanBadge => 'Plano Atual';

  @override
  String get subscriptionTierFree => 'Grátis';

  @override
  String get subscriptionTierPremium => 'Premium';

  @override
  String get subscriptionTierPremiumPlus => 'Premium+';

  @override
  String get subscriptionFreePrice => '¥0';

  @override
  String subscriptionPricePerMonth(int price) {
    return '¥$price/mês';
  }

  @override
  String get subscriptionCheckout => 'Assinar Agora';

  @override
  String get subscriptionRecommended => 'RECOMENDADO';

  @override
  String get subscriptionCancelling => 'Cancelando...';

  @override
  String subscriptionCancellingAt(String date) {
    return 'Seu plano terminará em $date';
  }

  @override
  String get subscriptionFeatureFreeChat => '10 chats AI grátis (vitalício)';

  @override
  String get subscriptionFeatureFreeScans => '3 digitalizações por mês';

  @override
  String get subscriptionFeatureFreeTracker => 'Rastrear até 3 procedimentos';

  @override
  String get subscriptionFeatureFreeCommunityRead =>
      'Ler publicações da comunidade';

  @override
  String get subscriptionFeatureCommunityPost =>
      'Publicar & responder na comunidade';

  @override
  String get subscriptionFeatureUnlimitedChat => 'Chats IA ilimitados';

  @override
  String get profileTitle => 'Conta';

  @override
  String get profileEditTitle => 'Editar Perfil';

  @override
  String get profileEdit => 'Editar Perfil';

  @override
  String get profileEmail => 'E-mail';

  @override
  String get profileNationality => 'Nacionalidade';

  @override
  String get profileResidenceStatus => 'Status de Residência';

  @override
  String get profileRegion => 'Região';

  @override
  String get profileLanguage => 'Idioma';

  @override
  String get profileArrivalDate => 'Data de Chegada';

  @override
  String get profileDisplayName => 'Nome de Exibição';

  @override
  String get profileNoName => 'Sem Nome';

  @override
  String get profileNameTooLong => 'O nome deve ter no máximo 100 caracteres';

  @override
  String get profileSaved => 'Perfil salvo';

  @override
  String get profileSaveButton => 'Salvar';

  @override
  String get profileSaveError => 'Falha ao salvar';

  @override
  String get profileLoadError => 'Falha ao carregar';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsLanguageSection => 'Idioma';

  @override
  String get settingsAccountSection => 'Conta';

  @override
  String get settingsAboutSection => 'Sobre';

  @override
  String get settingsLogout => 'Sair';

  @override
  String get settingsDeleteAccount => 'Excluir Conta';

  @override
  String get settingsDeleteAccountSubtitle => 'Esta ação não pode ser desfeita';

  @override
  String get settingsVersion => 'Versão';

  @override
  String get settingsLogoutConfirmTitle => 'Sair';

  @override
  String get settingsLogoutConfirmMessage => 'Tem certeza de que deseja sair?';

  @override
  String get settingsDeleteConfirmTitle => 'Excluir Conta';

  @override
  String get settingsDeleteConfirmMessage =>
      'Tem certeza de que deseja excluir sua conta? Esta ação não pode ser desfeita. Todos os seus dados serão removidos permanentemente.';

  @override
  String get settingsDeleteError => 'Falha ao excluir';

  @override
  String get settingsCancel => 'Cancelar';

  @override
  String get settingsDelete => 'Excluir';

  @override
  String get settingsConfirm => 'Confirmar';

  @override
  String get navTitle => 'Guia';

  @override
  String get navSubtitle =>
      'Explore tópicos para ajudar você a viver no Japão.';

  @override
  String navGuideCount(int count) {
    return '$count guias';
  }

  @override
  String get navGuideCountOne => '1 guia';

  @override
  String get navComingSoon => 'Em breve';

  @override
  String get navComingSoonSnackbar => 'Em breve! Estamos trabalhando nisso.';

  @override
  String get navErrorLoad => 'Não foi possível carregar os guias.';

  @override
  String get navErrorRetry => 'Toque para tentar novamente';

  @override
  String get domainFinance => 'Serviços Financeiros';

  @override
  String get domainVisa => 'Visto e Imigração';

  @override
  String get domainMedical => 'Saúde e Medicina';

  @override
  String get domainLife => 'Vida Diária';

  @override
  String get domainHousing => 'Moradia e Utilidades';

  @override
  String get domainTax => 'Impostos & Seguro Social';

  @override
  String get domainEducation => 'Educação e Cuidado Infantil';

  @override
  String get domainLegal => 'Jurídico & Direitos';

  @override
  String get guideSearchPlaceholder => 'Buscar guias...';

  @override
  String get guideComingSoonTitle => 'Em breve';

  @override
  String guideComingSoonSubtitle(String domain) {
    return 'Estamos trabalhando nos guias de $domain. Volte em breve!';
  }

  @override
  String guideComingSoonAskAi(String domain) {
    return 'Pergunte à IA sobre $domain';
  }

  @override
  String guideSearchEmpty(String query) {
    return 'Nenhum guia encontrado para \"$query\".';
  }

  @override
  String get guideSearchTry => 'Tente um termo de busca diferente.';

  @override
  String get guideErrorLoad =>
      'Não foi possível carregar os guias desta categoria.';

  @override
  String get guideAskAi => 'Conversar com o Guia IA (obter detalhes)';

  @override
  String get guideDisclaimer =>
      'Esta é uma informação geral e não constitui aconselhamento jurídico. Verifique com as autoridades competentes.';

  @override
  String get guideShare => 'Compartilhar';

  @override
  String get guideErrorNotFound => 'Este guia não está mais disponível.';

  @override
  String get guideErrorLoadDetail =>
      'Não foi possível carregar este guia. Tente novamente.';

  @override
  String get guideErrorRetryBack => 'Voltar';

  @override
  String get emergencyTitle => 'Emergência';

  @override
  String get emergencyWarning =>
      'Se você está em perigo imediato, ligue 110 (Polícia) ou 119 (Bombeiros/Ambulância) imediatamente.';

  @override
  String get emergencySectionContacts => 'Contatos de emergência';

  @override
  String get emergencySectionAmbulance => 'Como chamar uma ambulância';

  @override
  String get emergencySectionMoreHelp => 'Precisa de mais ajuda?';

  @override
  String get emergencyPoliceName => 'Polícia';

  @override
  String get emergencyPoliceNumber => '110';

  @override
  String get emergencyFireName => 'Bombeiros / Ambulância';

  @override
  String get emergencyFireNumber => '119';

  @override
  String get emergencyMedicalName => 'Consulta médica';

  @override
  String get emergencyMedicalNumber => '#7119';

  @override
  String get emergencyMedicalNote => 'Aconselhamento médico não emergencial';

  @override
  String get emergencyTellName => 'TELL Japan (Saúde Mental)';

  @override
  String get emergencyTellNumber => '03-5774-0992';

  @override
  String get emergencyTellNote => 'Aconselhamento em inglês';

  @override
  String get emergencyHelplineName => 'Japan Helpline';

  @override
  String get emergencyHelplineNumber => '0570-064-211';

  @override
  String get emergencyHelplineNote => '24 horas, multilíngue';

  @override
  String get emergencyStep1 => 'Ligue 119';

  @override
  String get emergencyStep2 =>
      'Diga \"Kyuukyuu desu\" (救急です — É uma emergência)';

  @override
  String get emergencyStep3 =>
      'Explique sua localização (endereço, pontos de referência)';

  @override
  String get emergencyStep4 =>
      'Descreva a situação (o que aconteceu, sintomas)';

  @override
  String get emergencyStep5 => 'Espere a ambulância na entrada do seu prédio';

  @override
  String get emergencyPhraseEmergencyHelp => 'É uma emergência';

  @override
  String get emergencyPhraseHelpHelp => 'Por favor, ajude';

  @override
  String get emergencyPhraseAmbulanceHelp => 'Por favor, envie uma ambulância';

  @override
  String get emergencyPhraseAddressHelp => 'O endereço é ○○';

  @override
  String get emergencyAskAi => 'Falar com IA sobre situações de emergência';

  @override
  String get emergencyDisclaimer =>
      'Este guia fornece informações gerais de saúde e não substitui orientação médica profissional. Em caso de emergência, ligue 119 imediatamente.';

  @override
  String get emergencyCallButton => 'Ligar';

  @override
  String get emergencyOffline =>
      'Não foi possível carregar informações adicionais. Ligue 110 ou 119 se precisar de ajuda.';

  @override
  String get subTitle => 'Assinatura';

  @override
  String get subSectionCurrent => 'Plano atual';

  @override
  String get subSectionChoose => 'Escolha um plano';

  @override
  String get subSectionCharge => 'Precisa de mais chats?';

  @override
  String get subSectionFaq => 'Perguntas frequentes';

  @override
  String get subCurrentFree => 'Plano grátis';

  @override
  String get subCurrentStandard => 'Plano padrão';

  @override
  String get subCurrentPremium => 'Plano premium';

  @override
  String get subUpgradeNow => 'Upgrade agora';

  @override
  String get subPlanFree => 'Grátis';

  @override
  String get subPlanStandard => 'Padrão';

  @override
  String get subPlanPremium => 'Premium';

  @override
  String get subPriceFree => '¥0';

  @override
  String get subPriceStandard => '¥720';

  @override
  String get subPricePremium => '¥1,360';

  @override
  String get subPriceInterval => '/mês';

  @override
  String get subRecommended => 'RECOMENDADO';

  @override
  String get subFeatureChatFree => '10 chats AI Guide vitalícios';

  @override
  String get subFeatureChatStandard => '300 conversas AI Guide/mês';

  @override
  String get subFeatureChatPremium => 'Conversas AI Guide ilimitadas';

  @override
  String get subFeatureTrackerFree => 'Até 3 itens no rastreador';

  @override
  String get subFeatureTrackerPaid => 'Itens ilimitados no rastreador';

  @override
  String get subFeatureAdsYes => 'Contém anúncios';

  @override
  String get subFeatureAdsNo => 'Sem anúncios';

  @override
  String get subFeatureGuideFree => 'Ver alguns guias';

  @override
  String get subFeatureGuidePaid => 'Ver todos os guias';

  @override
  String get subFeatureImageNo => 'Análise de imagem IA (no chat)';

  @override
  String get subFeatureImageYes => 'Análise de imagem IA (no chat)';

  @override
  String get subButtonCurrent => 'Plano atual';

  @override
  String subButtonChoose(String plan) {
    return 'Escolher $plan';
  }

  @override
  String get subCharge100 => 'Pacote 100 chats';

  @override
  String get subCharge50 => 'Pacote 50 chats';

  @override
  String get subCharge100Price => '¥360 (¥3.6/chat)';

  @override
  String get subCharge50Price => '¥180 (¥3.6/chat)';

  @override
  String get subChargeDescription =>
      'Chats extras que nunca expiram. Usados após o limite do plano.';

  @override
  String get subFaqBillingQ => 'Como funciona a cobrança?';

  @override
  String get subFaqBillingA =>
      'As assinaturas são cobradas mensalmente pela App Store ou Google Play. Você pode gerenciar nas configurações do dispositivo.';

  @override
  String get subFaqCancelQ => 'Posso cancelar a qualquer momento?';

  @override
  String get subFaqCancelA =>
      'Sim! Você pode cancelar a qualquer momento. Seu plano permanece ativo até o final do período.';

  @override
  String get subFaqDowngradeQ => 'O que acontece quando eu rebaixo?';

  @override
  String get subFaqDowngradeA =>
      'Ao rebaixar, você mantém os benefícios do plano atual até o final do período. Depois, muda para o novo nível.';

  @override
  String get subFooter => 'Assinatura gerenciada pela App Store / Google Play';

  @override
  String subPurchaseSuccess(String plan) {
    return 'Bem-vindo ao $plan! Seu upgrade está ativo.';
  }

  @override
  String get subPurchaseError =>
      'Não foi possível concluir a compra. Tente novamente.';

  @override
  String get subErrorLoad => 'Não foi possível carregar os planos.';

  @override
  String get subErrorRetry => 'Toque para tentar novamente';

  @override
  String get profileSectionInfo => 'Suas informações';

  @override
  String get profileSectionStats => 'Estatísticas de uso';

  @override
  String get profileChatsToday => 'Chats hoje';

  @override
  String get profileMemberSince => 'Membro desde';

  @override
  String get profileManageSubscription => 'Gerenciar assinatura';

  @override
  String get profileNotSet => 'Não definido';

  @override
  String get editTitle => 'Editar perfil';

  @override
  String get editSave => 'Salvar';

  @override
  String get editNameLabel => 'Nome de exibição';

  @override
  String get editNameHint => 'Digite seu nome';

  @override
  String get editNationalityLabel => 'Nacionalidade';

  @override
  String get editNationalityHint => 'Selecione sua nacionalidade';

  @override
  String get editStatusLabel => 'Status de residência';

  @override
  String get editStatusHint => 'Selecione seu status';

  @override
  String get editRegionLabel => 'Região';

  @override
  String get editRegionHint => 'Selecione sua região';

  @override
  String get editLanguageLabel => 'Idioma preferido';

  @override
  String get editChangePhoto => 'Alterar foto';

  @override
  String get editSuccess => 'Perfil atualizado com sucesso.';

  @override
  String get editError =>
      'Não foi possível atualizar o perfil. Tente novamente.';

  @override
  String get editUnsavedTitle => 'Alterações não salvas';

  @override
  String get editUnsavedMessage => 'Você tem alterações não salvas. Descartar?';

  @override
  String get editUnsavedDiscard => 'Descartar';

  @override
  String get editUnsavedKeep => 'Continuar editando';

  @override
  String get settingsSectionGeneral => 'Geral';

  @override
  String get settingsSectionAccount => 'Conta';

  @override
  String get settingsSectionDanger => 'Zona de perigo';

  @override
  String get settingsSectionAbout => 'Sobre';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsNotifications => 'Notificações';

  @override
  String get settingsSubscription => 'Assinatura';

  @override
  String get settingsTerms => 'Termos de Serviço';

  @override
  String get settingsPrivacy => 'Política de Privacidade';

  @override
  String get settingsContact => 'Fale conosco';

  @override
  String get settingsFooter => 'Feito com ❤️ para todos que vivem no Japão';

  @override
  String get settingsLogoutTitle => 'Sair';

  @override
  String get settingsLogoutMessage => 'Tem certeza que deseja sair?';

  @override
  String get settingsLogoutConfirm => 'Sair';

  @override
  String get settingsLogoutCancel => 'Cancelar';

  @override
  String get settingsDeleteTitle => 'Excluir conta';

  @override
  String get settingsDeleteMessage =>
      'Esta ação não pode ser desfeita. Todos os seus dados serão excluídos permanentemente. Tem certeza?';

  @override
  String get settingsDeleteConfirmAction => 'Excluir minha conta';

  @override
  String get settingsDeleteCancel => 'Cancelar';

  @override
  String get settingsDeleteSuccess => 'Sua conta foi excluída.';

  @override
  String get settingsLanguageTitle => 'Escolher idioma';

  @override
  String get settingsErrorLogout => 'Não foi possível sair. Tente novamente.';

  @override
  String get settingsErrorDelete =>
      'Não foi possível excluir a conta. Tente novamente.';

  @override
  String get chatGuestTitle => 'Pergunte ao AI sobre a vida no Japão';

  @override
  String get chatGuestFeature1 => 'Como abrir uma conta bancária';

  @override
  String get chatGuestFeature2 => 'Procedimentos de renovação de visto';

  @override
  String get chatGuestFeature3 => 'Como ir ao hospital';

  @override
  String get chatGuestFeature4 => 'E qualquer outra coisa';

  @override
  String get chatGuestFreeOffer => 'Experimente 5 chats grátis — sem cadastro';

  @override
  String get chatGuestSignUp => 'Comece grátis';

  @override
  String get chatGuestLogin => 'Já tem conta? Entrar';

  @override
  String get guestRegisterCta => 'Cadastre-se grátis para usar o AI Chat';

  @override
  String get guideReadMore => 'Cadastre-se para ler o guia completo';

  @override
  String get guideAskAI => 'Pergunte detalhes ao AI';

  @override
  String get guideGuestCtaButton => 'Criar conta gratuita';

  @override
  String get homeGuestCtaText =>
      'Crie sua conta gratuita para acessar chat IA e guias personalizados';

  @override
  String get homeGuestCtaButton => 'Começar';

  @override
  String get chatUpgradeBanner =>
      'Faça upgrade para Premium para chat ilimitado';

  @override
  String get chatUpgradeButton => 'Ver planos';

  @override
  String get guidePremiumCta => 'Este conteúdo requer assinatura Premium';

  @override
  String get guidePremiumCtaButton => 'Ver planos';

  @override
  String get guideTierLimitError =>
      'Faça upgrade para acessar o conteúdo completo';

  @override
  String get trackerSave => 'Salvar';

  @override
  String get trackerSaved => 'Salvo';

  @override
  String get trackerItemSaved => 'Adicionado à lista de tarefas';

  @override
  String get homeQaTrackerTitle => 'Tarefas';

  @override
  String get homeQaTrackerSubtitle => 'Gerenciar suas tarefas';

  @override
  String get chatAttachPhoto => 'Tirar Foto';

  @override
  String get chatAttachGallery => 'Escolher da Galeria';

  @override
  String get chatAttachCancel => 'Cancelar';

  @override
  String get chatImageTooLarge => 'Imagem muito grande (máx. 5MB)';

  @override
  String get profilePersonalizationHint =>
      'O guia de IA fornecerá conselhos mais precisos e personalizados com base no seu perfil completo';

  @override
  String get profileVisaExpiry => 'Validade do Visto';

  @override
  String get profileResidenceRegion => 'Região de Residência';

  @override
  String get profilePreferredLanguage => 'Idioma Preferido';

  @override
  String get profileSelectNationality => 'Selecionar Nacionalidade';

  @override
  String get profileSelectResidenceStatus => 'Selecionar Status de Residência';

  @override
  String get profileSelectPrefecture => 'Selecionar Província';

  @override
  String get profileSelectCity => 'Selecionar Cidade';

  @override
  String get profileSelectLanguage => 'Selecionar Idioma';

  @override
  String get profileCommonStatuses => 'Comuns';

  @override
  String get profileOtherStatuses => 'Outros';

  @override
  String get profileSearchNationality => 'Pesquisar nacionalidade';

  @override
  String get visaRenewalPrepTitle => 'Preparar pedido de renovação do visto';

  @override
  String get visaRenewalDeadlineTitle => 'Prazo de renovação do visto';

  @override
  String get profileSave => 'Salvar';

  @override
  String get profileUsageStats => 'Estatísticas de Uso';

  @override
  String get profileLogout => 'Sair';

  @override
  String get profileDeleteAccount => 'Excluir Conta';

  @override
  String get subUsageTitle => 'Seu Uso';

  @override
  String subUsageCount(int used, int limit) {
    return 'Usou $used / $limit chats';
  }

  @override
  String get subUsageUnlimited => 'Chats ilimitados';

  @override
  String get tabAccount => 'Conta';

  @override
  String get accountSectionProfile => 'Perfil';

  @override
  String get accountSectionManagement => 'Gerenciar Conta';

  @override
  String get accountSectionDanger => 'Zona de Perigo';

  @override
  String get notificationSettingsTitle => 'Notificações';

  @override
  String get notificationTodoReminder => 'Lembretes de Tarefas';

  @override
  String get notificationReminderTime => 'Horário do Lembrete';

  @override
  String get notificationEnabled => 'Ativado';

  @override
  String get notificationDisabled => 'Desativado';

  @override
  String get guideLocked => 'Cadastre-se para ler o guia completo';

  @override
  String get guideUpgradePrompt =>
      'Crie uma conta gratuita para acessar todos os 45 guias';

  @override
  String get guideUpgradeButton => 'Criar conta gratuita';

  @override
  String chatGuestUsageHint(int remaining) {
    return 'Você tem $remaining chats grátis para explorar';
  }

  @override
  String get chatGuestExhausted =>
      'Cadastre-se para continuar — mais 10 chats grátis';

  @override
  String get chatFreeExhausted => 'Atualize para Standard por 300 chats/mês';

  @override
  String usageLifetimeRemaining(int remaining, int limit) {
    return '$remaining de $limit chats restantes';
  }

  @override
  String get chatGuestWelcome =>
      'Pergunte qualquer coisa sobre a vida no Japão';

  @override
  String get registerNationalityLabel => 'Nacionalidade';

  @override
  String get registerNationalityHint => 'Selecione sua nacionalidade';

  @override
  String get registerResidenceStatusLabel => 'Status de Residência';

  @override
  String get registerResidenceStatusHint =>
      'Selecione seu status de residência';

  @override
  String get registerResidenceRegionLabel => 'Região de Residência';

  @override
  String get registerResidenceRegionHint => 'Selecione sua região';

  @override
  String get registerSearchHint => 'Pesquisar...';

  @override
  String get chatDepthLevelDeep => 'Resposta detalhada';

  @override
  String chatUsageDeepRemaining(int remaining, int limit) {
    return 'Detalhada: $remaining/$limit';
  }

  @override
  String chatCreditsRemaining(int remaining) {
    return '$remaining chats restantes';
  }

  @override
  String get trialSetupTitle =>
      'Antes de começar, conte-nos um pouco sobre você';

  @override
  String get trialSetupNationality => 'Nacionalidade';

  @override
  String get trialSetupResidenceStatus => 'Status de Residência';

  @override
  String get trialSetupRegion => 'Região';

  @override
  String get trialSetupSubmit => 'Começar';

  @override
  String get navAiSearchTitle => 'Busca inteligente com AI Guide';

  @override
  String get navAiSearchSubtitle =>
      'Receba informações personalizadas para sua situação';

  @override
  String get navAiSearchButton => 'Experimente agora';

  @override
  String guideCount(int count) {
    return '$count guias';
  }

  @override
  String get guideFreeLabel => 'GRÁTIS';

  @override
  String guideReadingTime(int min) {
    return '$min min de leitura';
  }

  @override
  String get guideRelatedTitle => 'Outros guias neste domínio';

  @override
  String get trackerEditTitle => 'Adicionar ao Rastreador';

  @override
  String get trackerEditFieldTitle => 'Título';

  @override
  String get trackerEditFieldMemo => 'Nota (opcional)';

  @override
  String get trackerEditFieldDate => 'Data de Vencimento (opcional)';

  @override
  String get trackerEditSave => 'Salvar no Rastreador';

  @override
  String get trackerEditCancel => 'Cancelar';
}
