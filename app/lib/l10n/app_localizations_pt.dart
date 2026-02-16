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
  String get languageSelectionTitle => 'Escolha Seu Idioma';

  @override
  String get languageSelectionSubtitle =>
      'Você pode alterar depois nas configurações';

  @override
  String get continueButton => 'Continuar';

  @override
  String get loginTitle => 'Bem-vindo de Volta';

  @override
  String get loginSubtitle => 'Entre na sua conta';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Senha';

  @override
  String get loginButton => 'Entrar';

  @override
  String get forgotPassword => 'Esqueceu a senha?';

  @override
  String get noAccount => 'Não tem uma conta?';

  @override
  String get signUp => 'Cadastrar';

  @override
  String get registerTitle => 'Criar Conta';

  @override
  String get registerSubtitle => 'Comece sua vida no Japão com confiança';

  @override
  String get confirmPasswordLabel => 'Confirmar Senha';

  @override
  String get registerButton => 'Criar Conta';

  @override
  String get hasAccount => 'Já tem uma conta?';

  @override
  String get signIn => 'Entrar';

  @override
  String get resetPasswordTitle => 'Redefinir Senha';

  @override
  String get resetPasswordSubtitle =>
      'Digite seu e-mail para receber o link de redefinição';

  @override
  String get sendResetLink => 'Enviar Link de Redefinição';

  @override
  String get backToLogin => 'Voltar ao Login';

  @override
  String get resetPasswordSuccess =>
      'E-mail de redefinição enviado. Verifique sua caixa de entrada.';

  @override
  String get emailRequired => 'O e-mail é obrigatório';

  @override
  String get emailInvalid => 'Por favor, insira um e-mail válido';

  @override
  String get passwordRequired => 'A senha é obrigatória';

  @override
  String get passwordTooShort => 'A senha deve ter pelo menos 8 caracteres';

  @override
  String get passwordMismatch => 'As senhas não coincidem';

  @override
  String get tabHome => 'Início';

  @override
  String get tabChat => 'Chat';

  @override
  String get tabTracker => 'Rastreador';

  @override
  String get tabNavigate => 'Navegar';

  @override
  String get tabProfile => 'Perfil';

  @override
  String get homeWelcome => 'Bem-vindo ao Gaijin Life Navi';

  @override
  String get homeSubtitle => 'Seu guia para a vida no Japão';

  @override
  String get homeQuickActions => 'Ações Rápidas';

  @override
  String get homeActionAskAI => 'Perguntar ao AI';

  @override
  String get homeActionTracker => 'Rastreador';

  @override
  String get homeActionBanking => 'Banco';

  @override
  String get homeActionChatHistory => 'Histórico de Chat';

  @override
  String get homeRecentChats => 'Chats Recentes';

  @override
  String get homeNoRecentChats => 'Nenhum chat recente';

  @override
  String get homeMessagesLabel => 'mensagens';

  @override
  String get chatPlaceholder => 'Chat AI — Em breve';

  @override
  String get chatTitle => 'Chat AI';

  @override
  String get chatNewSession => 'Novo Chat';

  @override
  String get chatEmptyTitle => 'Iniciar uma Conversa';

  @override
  String get chatEmptySubtitle =>
      'Pergunte ao AI qualquer coisa sobre a vida no Japão';

  @override
  String get chatUntitledSession => 'Nova Conversa';

  @override
  String get chatConversationTitle => 'Conversa';

  @override
  String get chatInputHint => 'Pergunte sobre a vida no Japão...';

  @override
  String get chatTyping => 'Pensando...';

  @override
  String get chatSources => 'Fontes';

  @override
  String get chatRetry => 'Tentar novamente';

  @override
  String get chatDeleteTitle => 'Excluir Chat';

  @override
  String get chatDeleteConfirm => 'Tem certeza que deseja excluir este chat?';

  @override
  String get chatDeleteCancel => 'Cancelar';

  @override
  String get chatDeleteAction => 'Excluir';

  @override
  String get chatLimitReached => 'Limite diário atingido';

  @override
  String chatRemainingCount(int remaining, int limit) {
    return '$remaining/$limit restantes';
  }

  @override
  String get chatLimitReachedTitle => 'Limite Diário Atingido';

  @override
  String get chatLimitReachedMessage =>
      'Você usou todos os seus chats gratuitos hoje. Atualize para o Premium para acesso ilimitado.';

  @override
  String get chatUpgradeToPremium => 'Atualizar para Premium';

  @override
  String get chatWelcomePrompt => 'Como posso ajudá-lo hoje?';

  @override
  String get chatWelcomeHint =>
      'Pergunte sobre procedimentos de visto, bancos, moradia ou qualquer coisa sobre a vida no Japão.';

  @override
  String get onboardingTitle => 'Configure Seu Perfil';

  @override
  String get onboardingSkip => 'Pular';

  @override
  String get onboardingNext => 'Próximo';

  @override
  String get onboardingComplete => 'Concluir';

  @override
  String onboardingStepOf(int current, int total) {
    return 'Passo $current de $total';
  }

  @override
  String get onboardingNationalityTitle => 'Qual é a sua nacionalidade?';

  @override
  String get onboardingNationalitySubtitle =>
      'Isso nos ajuda a fornecer informações relevantes para sua situação.';

  @override
  String get onboardingResidenceStatusTitle =>
      'Qual é seu status de residência?';

  @override
  String get onboardingResidenceStatusSubtitle =>
      'Selecione seu tipo de visto atual no Japão.';

  @override
  String get onboardingRegionTitle => 'Onde você mora?';

  @override
  String get onboardingRegionSubtitle =>
      'Selecione a área onde você mora ou planeja se mudar.';

  @override
  String get onboardingArrivalDateTitle => 'Quando você chegou ao Japão?';

  @override
  String get onboardingArrivalDateSubtitle =>
      'Isso nos ajuda a sugerir procedimentos e prazos relevantes.';

  @override
  String get onboardingSelectDate => 'Selecionar Data';

  @override
  String get onboardingChangeDate => 'Alterar Data';

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
  String get visaEngineer => 'Engenheiro / Especialista';

  @override
  String get visaStudent => 'Estudante';

  @override
  String get visaDependent => 'Dependente';

  @override
  String get visaPermanent => 'Residente Permanente';

  @override
  String get visaSpouse => 'Cônjuge de Japonês';

  @override
  String get visaWorkingHoliday => 'Working Holiday';

  @override
  String get visaSpecifiedSkilled => 'Trabalhador Qualificado Específico';

  @override
  String get visaTechnicalIntern => 'Estagiário Técnico';

  @override
  String get visaHighlySkilled => 'Profissional Altamente Qualificado';

  @override
  String get visaOther => 'Outro';

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
  String get regionKyoto => 'Quioto';

  @override
  String get regionSendai => 'Sendai';

  @override
  String get regionHiroshima => 'Hiroshima';

  @override
  String get regionOther => 'Outro';

  @override
  String get trackerPlaceholder => 'Rastreador Administrativo — Em breve';

  @override
  String get navigatePlaceholder => 'Navegar — Em breve';

  @override
  String get profilePlaceholder => 'Perfil — Em breve';

  @override
  String get genericError => 'Algo deu errado. Tente novamente.';

  @override
  String get networkError => 'Erro de rede. Verifique sua conexão.';

  @override
  String get logout => 'Sair';

  @override
  String get bankingTitle => 'Guia Bancário';

  @override
  String get bankingFriendlyScore =>
      'Pontuação de acessibilidade para estrangeiros';

  @override
  String get bankingEmpty => 'Nenhum banco encontrado';

  @override
  String get bankingRecommendButton => 'Recomendar';

  @override
  String get bankingRecommendTitle => 'Recomendações de Bancos';

  @override
  String get bankingSelectPriorities => 'Selecione suas prioridades';

  @override
  String get bankingPriorityMultilingual => 'Suporte multilíngue';

  @override
  String get bankingPriorityLowFee => 'Taxas baixas';

  @override
  String get bankingPriorityAtm => 'Rede de ATMs';

  @override
  String get bankingPriorityOnline => 'Internet Banking';

  @override
  String get bankingGetRecommendations => 'Obter recomendações';

  @override
  String get bankingRecommendHint =>
      'Selecione suas prioridades e toque em Obter recomendações';

  @override
  String get bankingNoRecommendations => 'Nenhuma recomendação encontrada';

  @override
  String get bankingViewGuide => 'Ver guia';

  @override
  String get bankingGuideTitle => 'Guia de Abertura de Conta';

  @override
  String get bankingRequiredDocs => 'Documentos Necessários';

  @override
  String get bankingConversationTemplates => 'Frases úteis no banco';

  @override
  String get bankingTroubleshooting => 'Dicas de solução de problemas';

  @override
  String get bankingSource => 'Fonte';

  @override
  String get visaTitle => 'Guia de Visto';

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
      'IMPORTANTE: Esta é uma informação geral sobre procedimentos de visto e não constitui aconselhamento de imigração. As leis e procedimentos de imigração podem mudar. Sempre consulte a Agência de Serviços de Imigração ou um advogado de imigração qualificado (行政書士) para sua situação específica.';

  @override
  String get trackerTitle => 'Rastreador Administrativo';

  @override
  String get trackerEmpty => 'Nenhum procedimento rastreado';

  @override
  String get trackerEmptyHint =>
      'Toque + para adicionar procedimentos para rastrear';

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
      'Plano gratuito: até 3 procedimentos. Atualize para ilimitado.';

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
      'Tem certeza que deseja remover este procedimento do rastreador?';

  @override
  String get trackerProcedureAdded => 'Procedimento adicionado ao rastreador';

  @override
  String get trackerLimitReached =>
      'Limite do plano gratuito atingido (3 procedimentos). Atualize para Premium para ilimitado.';

  @override
  String get trackerAlreadyTracking =>
      'Você já está rastreando este procedimento';

  @override
  String get trackerEssentialProcedures => 'Essenciais (Após chegada)';

  @override
  String get trackerOtherProcedures => 'Outros Procedimentos';

  @override
  String get trackerNoTemplates => 'Nenhum modelo de procedimento disponível';

  @override
  String get scannerTitle => 'Scanner de Documentos';

  @override
  String get scannerDescription =>
      'Escaneie documentos em japonês para obter traduções e explicações instantâneas';

  @override
  String get scannerFromCamera => 'Escanear com Câmera';

  @override
  String get scannerFromGallery => 'Escolher da Galeria';

  @override
  String get scannerHistory => 'Histórico';

  @override
  String get scannerHistoryTitle => 'Histórico de Escaneamento';

  @override
  String get scannerHistoryEmpty => 'Nenhum escaneamento ainda';

  @override
  String get scannerUnknownType => 'Documento Desconhecido';

  @override
  String get scannerResultTitle => 'Resultado do Escaneamento';

  @override
  String get scannerOriginalText => 'Texto Original (Japonês)';

  @override
  String get scannerTranslation => 'Tradução';

  @override
  String get scannerExplanation => 'O que isso significa';

  @override
  String get scannerProcessing => 'Processando seu documento...';

  @override
  String get scannerRefresh => 'Atualizar';

  @override
  String get scannerFailed => 'Escaneamento falhou. Tente novamente.';

  @override
  String get scannerFreeLimitInfo =>
      'Plano gratuito: 3 escaneamentos/mês. Atualize para mais.';

  @override
  String get scannerLimitReached =>
      'Limite mensal de escaneamento atingido. Atualize para Premium para mais escaneamentos.';

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
  String get medicalWhatToPrepare => 'O que Preparar';

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
      'Este guia fornece informações gerais de saúde e não substitui aconselhamento médico profissional. Em caso de emergência, ligue 119 imediatamente.';

  @override
  String get navigateBanking => 'Banco';

  @override
  String get navigateBankingDesc =>
      'Encontre bancos acessíveis para estrangeiros';

  @override
  String get navigateVisa => 'Visto';

  @override
  String get navigateVisaDesc => 'Procedimentos de visto e documentos';

  @override
  String get navigateScanner => 'Scanner';

  @override
  String get navigateScannerDesc => 'Traduza documentos em japonês';

  @override
  String get navigateMedical => 'Médico';

  @override
  String get navigateMedicalDesc => 'Guia de emergência e frases';

  @override
  String get upgradeToPremium => 'Atualizar para Premium';

  @override
  String get communityTitle => 'Comunidade Q&A';

  @override
  String get communityEmpty => 'Nenhuma postagem ainda';

  @override
  String get communityNewPost => 'Nova Postagem';

  @override
  String get communityDetailTitle => 'Detalhe da Postagem';

  @override
  String get communityAnswered => 'Respondido';

  @override
  String get communityBestAnswer => 'Melhor Resposta';

  @override
  String get communityFilterAll => 'Todos';

  @override
  String get communitySortNewest => 'Mais recentes';

  @override
  String get communitySortPopular => 'Popular';

  @override
  String get communityCategoryVisa => 'Visto';

  @override
  String get communityCategoryHousing => 'Moradia';

  @override
  String get communityCategoryBanking => 'Banco';

  @override
  String get communityCategoryWork => 'Trabalho';

  @override
  String get communityCategoryDailyLife => 'Vida Diária';

  @override
  String get communityCategoryMedical => 'Médico';

  @override
  String get communityCategoryEducation => 'Educação';

  @override
  String get communityCategoryTax => 'Impostos';

  @override
  String get communityCategoryOther => 'Outros';

  @override
  String communityReplies(int count) {
    return '$count Respostas';
  }

  @override
  String get communityNoReplies =>
      'Sem respostas ainda. Seja o primeiro a responder!';

  @override
  String get communityReplyHint => 'Escreva uma resposta...';

  @override
  String get communityReplyPremiumOnly =>
      'Postar e responder requer uma assinatura Premium.';

  @override
  String communityVoteCount(int count) {
    return '$count votos';
  }

  @override
  String get communityModerationPending => 'Em análise';

  @override
  String get communityModerationFlagged => 'Sinalizado para revisão';

  @override
  String get communityModerationNotice =>
      'Sua postagem será revisada pelo nosso sistema de moderação AI antes de ficar visível para outros.';

  @override
  String get communityChannelLabel => 'Canal de idioma';

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
    return '${days}d atrás';
  }

  @override
  String communityTimeAgoHours(int hours) {
    return '${hours}h atrás';
  }

  @override
  String communityTimeAgoMinutes(int minutes) {
    return '${minutes}m atrás';
  }

  @override
  String get navigateCommunity => 'Comunidade';

  @override
  String get navigateCommunityDesc =>
      'Perguntas e respostas com outros estrangeiros';

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
  String get subscriptionTierFree => 'Gratuito';

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
    return 'Seu plano termina em $date';
  }

  @override
  String get subscriptionFeatureFreeChat => '5 conversas com IA por dia';

  @override
  String get subscriptionFeatureFreeScans =>
      '3 escaneamentos de documentos por mês';

  @override
  String get subscriptionFeatureFreeTracker => 'Rastrear até 3 procedimentos';

  @override
  String get subscriptionFeatureFreeCommunityRead =>
      'Ler postagens da comunidade';

  @override
  String get subscriptionFeatureCommunityPost =>
      'Postar e responder na comunidade';

  @override
  String get subscriptionFeatureUnlimitedChat => 'Conversas com IA ilimitadas';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileEditTitle => 'Editar Perfil';

  @override
  String get profileEdit => 'Editar Perfil';

  @override
  String get profileEmail => 'Email';

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
  String get profileSaveError => 'Falha ao salvar perfil';

  @override
  String get profileLoadError => 'Falha ao carregar perfil';

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
  String get settingsLogoutConfirmMessage => 'Tem certeza que deseja sair?';

  @override
  String get settingsDeleteConfirmTitle => 'Excluir Conta';

  @override
  String get settingsDeleteConfirmMessage =>
      'Tem certeza que deseja excluir sua conta? Esta ação não pode ser desfeita. Todos os seus dados serão permanentemente removidos.';

  @override
  String get settingsDeleteError => 'Falha ao excluir conta';

  @override
  String get settingsCancel => 'Cancelar';

  @override
  String get settingsDelete => 'Excluir';

  @override
  String get settingsConfirm => 'Confirmar';
}
