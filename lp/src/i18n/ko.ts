export default {
  lang: 'ko',
  dir: 'ltr' as const,
  meta: {
    title: 'Gaijin Life Navi — AI 기반 일본 생활 가이드',
    description:
      'AI 어시스턴트로 일본의 은행, 비자, 의료, 일상생활을 모국어로 해결하세요. iOS 및 Android 지원.',
    ogImageAlt: 'Gaijin Life Navi — 외국인 거주자를 위한 AI 일본 생활 가이드',
  },
  nav: {
    features: '기능',
    download: '다운로드',
    langLabel: '언어',
  },
  hero: {
    tagline: 'AI 기반 일본 생활 가이드',
    headline: '일본 생활,\n심플하게.',
    subtitle:
      '은행, 비자, 의료 — 외국인 거주자에게 필요한 모든 것을 AI와 모국어로 지원합니다.',
    ctaAppStore: 'App Store에서 다운로드',
    ctaPlayStore: 'Google Play에서 다운로드',
  },
  features: {
    sectionTitle: '필요한 모든 것',
    sectionSubtitle: '일본 생활을 자신 있게 해결할 6가지 강력한 도구.',
    items: [
      {
        icon: 'chat',
        title: 'AI 채팅 어시스턴트',
        description:
          '모국어로 일본 생활에 대한 답변을 즉시 받으세요. 쓰레기 분리부터 세금 신고까지 — 무엇이든 물어보세요.',
      },
      {
        icon: 'banking',
        title: '은행 가이드',
        description:
          '은행 계좌 개설, 송금 설정, 일본 은행 시스템 이해를 위한 단계별 가이드.',
      },
      {
        icon: 'visa',
        title: '비자 내비게이터',
        description:
          '비자 마감일 추적, 요건 파악, 갱신 절차를 스트레스 없이 안내받으세요.',
      },
      {
        icon: 'tracker',
        title: '라이프 트래커',
        description:
          '중요한 날짜를 추적하세요 — 비자 갱신, 세금 마감, 건강 검진, 시청 절차 등.',
      },
      {
        icon: 'scanner',
        title: '문서 스캐너',
        description:
          '일본어 문서를 즉시 스캔하고 번역하세요. 우편물, 계약서, 공식 통지를 이해하세요.',
      },
      {
        icon: 'medical',
        title: '의료 가이드',
        description:
          '영어 가능 의사 찾기, 건강보험 제도 이해, 병원 방문 준비를 도와드립니다.',
      },
    ],
  },
  cta: {
    headline: '일본 생활을 간편하게 할 준비가 되셨나요?',
    subtitle: '지금 Gaijin Life Navi를 다운로드하고 자신 있게 시작하세요.',
    appStore: 'App Store',
    playStore: 'Google Play',
  },
  footer: {
    disclaimer:
      '이 앱은 일반적인 안내만 제공합니다. 법률, 의료 또는 재정 문제는 자격을 갖춘 전문가에게 상담하시기 바랍니다.',
    copyright: `© ${new Date().getFullYear()} Gaijin Life Navi. All rights reserved.`,
    privacy: '개인정보 처리방침',
    terms: '이용약관',
  },
};
