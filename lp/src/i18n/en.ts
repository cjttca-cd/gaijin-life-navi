export default {
  lang: 'en',
  dir: 'ltr' as const,
  meta: {
    title: 'Gaijin Life Navi — Your AI-Powered Guide to Life in Japan',
    description:
      'Navigate banking, visas, healthcare, and daily life in Japan with AI-powered assistance in your language. Available for iOS and Android.',
    ogImageAlt: 'Gaijin Life Navi — AI guide for foreign residents in Japan',
  },
  nav: {
    features: 'Features',
    download: 'Download',
    langLabel: 'Language',
  },
  hero: {
    tagline: 'Your AI-powered guide to life in Japan',
    headline: 'Life in Japan,\nSimplified.',
    subtitle:
      'Banking, visas, healthcare — everything you need as a foreign resident, powered by AI and available in your language.',
    ctaAppStore: 'Download on the App Store',
    ctaPlayStore: 'Get it on Google Play',
  },
  features: {
    sectionTitle: 'Everything You Need',
    sectionSubtitle:
      'Six powerful tools to help you navigate life in Japan with confidence.',
    items: [
      {
        icon: 'chat',
        title: 'AI Chat Assistant',
        description:
          'Get instant answers about life in Japan in your native language. From garbage sorting to tax filing — ask anything.',
      },
      {
        icon: 'banking',
        title: 'Banking Guide',
        description:
          'Step-by-step guides for opening bank accounts, setting up transfers, and understanding Japanese banking systems.',
      },
      {
        icon: 'visa',
        title: 'Visa Navigator',
        description:
          'Track visa deadlines, understand requirements, and get guided through the renewal process stress-free.',
      },
      {
        icon: 'tracker',
        title: 'Life Tracker',
        description:
          'Keep track of important dates — visa renewals, tax deadlines, health checkups, and municipal procedures.',
      },
      {
        icon: 'scanner',
        title: 'Document Scanner',
        description:
          'Scan and translate Japanese documents instantly. Understand your mail, contracts, and official notices.',
      },
      {
        icon: 'medical',
        title: 'Medical Guide',
        description:
          'Find English-speaking doctors, understand the health insurance system, and prepare for hospital visits.',
      },
    ],
  },
  cta: {
    headline: 'Ready to Simplify Your Life in Japan?',
    subtitle: 'Download Gaijin Life Navi today and start navigating with confidence.',
    appStore: 'App Store',
    playStore: 'Google Play',
  },
  footer: {
    disclaimer:
      'This app provides general guidance only. For legal, medical, or financial matters, please consult qualified professionals.',
    copyright: `© ${new Date().getFullYear()} Gaijin Life Navi. All rights reserved.`,
    privacy: 'Privacy Policy',
    terms: 'Terms of Service',
  },
};
