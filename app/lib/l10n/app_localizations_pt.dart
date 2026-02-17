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
  String get loginWelcome => 'Bem-vindo de volta';

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
  String get tabChat => 'Chat';

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
  String get homeSectionExplore => 'Explorar guias';

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
  String get chatTitle => 'Chat IA';

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
  String get chatLimitExhausted =>
      'Você usou todos os chats grátis de hoje. Faça upgrade para continuar!';

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
  String get trackerTitle => 'Rastreador Administrativo';

  @override
  String get trackerEmpty => 'Nenhum procedimento rastreado';

  @override
  String get trackerEmptyHint => 'Toque em + para adicionar procedimentos';

  @override
  String get trackerAddProcedure => 'Adicionar Procedimento';

  @override
  String get trackerStatusNotStarted => 'Não Iniciado';

  @override
  String get trackerStatusInProgress => 'Em Andamento';

  @override
  String get trackerStatusCompleted => 'Concluído';

  @override
  String get trackerDueDate => 'Data Limite';

  @override
  String get trackerFreeLimitInfo =>
      'Grátis: até 3 procedimentos. Faça upgrade para ilimitado.';

  @override
  String get trackerDetailTitle => 'Detalhes do Procedimento';

  @override
  String get trackerCurrentStatus => 'Status Atual';

  @override
  String get trackerNotes => 'Notas';

  @override
  String get trackerChangeStatus => 'Alterar Status';

  @override
  String get trackerMarkInProgress => 'Marcar como Em Andamento';

  @override
  String get trackerMarkCompleted => 'Marcar como Concluído';

  @override
  String get trackerMarkIncomplete => 'Marcar como Incompleto';

  @override
  String get trackerStatusUpdated => 'Status atualizado';

  @override
  String get trackerDeleteTitle => 'Excluir Procedimento';

  @override
  String get trackerDeleteConfirm =>
      'Tem certeza de que deseja remover este procedimento?';

  @override
  String get trackerProcedureAdded => 'Procedimento adicionado ao rastreador';

  @override
  String get trackerLimitReached =>
      'Limite gratuito atingido (3 procedimentos). Faça upgrade para ilimitado.';

  @override
  String get trackerAlreadyTracking =>
      'Você já está rastreando este procedimento';

  @override
  String get trackerEssentialProcedures => 'Essenciais (Após Chegada)';

  @override
  String get trackerOtherProcedures => 'Outros Procedimentos';

  @override
  String get trackerNoTemplates => 'Nenhum modelo de procedimento disponível';

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
  String get subscriptionFeatureFreeChat => '5 chats IA por dia';

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
  String get profileTitle => 'Perfil';

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
}
