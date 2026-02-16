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
}
