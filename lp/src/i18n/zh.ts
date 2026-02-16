export default {
  lang: 'zh',
  dir: 'ltr' as const,
  meta: {
    title: 'Gaijin Life Navi — 您的 AI 日本生活助手',
    description:
      '通过 AI 智能助手，用您的语言轻松应对日本的银行、签证、医疗和日常生活。支持 iOS 和 Android。',
    ogImageAlt: 'Gaijin Life Navi — 外国居民的 AI 日本生活指南',
  },
  nav: {
    features: '功能',
    download: '下载',
    langLabel: '语言',
  },
  hero: {
    tagline: '您的 AI 日本生活助手',
    headline: '日本生活，\n化繁为简。',
    subtitle:
      '银行开户、签证办理、医疗保健——作为外国居民所需的一切，AI 助力，多语言支持。',
    ctaAppStore: '在 App Store 下载',
    ctaPlayStore: '在 Google Play 下载',
  },
  features: {
    sectionTitle: '一站式解决方案',
    sectionSubtitle: '六大强力工具，助您自信应对日本生活。',
    items: [
      {
        icon: 'chat',
        title: 'AI 聊天助手',
        description:
          '用您的母语即时获取日本生活答案。从垃圾分类到报税——有问必答。',
      },
      {
        icon: 'banking',
        title: '银行指南',
        description:
          '开设银行账户、设置转账、了解日本银行系统的分步指南。',
      },
      {
        icon: 'visa',
        title: '签证导航',
        description:
          '追踪签证截止日期，了解要求，轻松完成续签流程。',
      },
      {
        icon: 'tracker',
        title: '生活追踪器',
        description:
          '追踪重要日期——签证续签、报税截止、体检和市政手续。',
      },
      {
        icon: 'scanner',
        title: '文档扫描仪',
        description:
          '即时扫描和翻译日语文件。轻松理解邮件、合同和官方通知。',
      },
      {
        icon: 'medical',
        title: '医疗指南',
        description:
          '查找英语医生，了解健康保险制度，为就医做好准备。',
      },
    ],
  },
  cta: {
    headline: '准备好简化您的日本生活了吗？',
    subtitle: '立即下载 Gaijin Life Navi，自信开启日本生活。',
    appStore: 'App Store',
    playStore: 'Google Play',
  },
  footer: {
    disclaimer:
      '本应用仅提供一般性指导。如涉及法律、医疗或财务事项，请咨询专业人士。',
    copyright: `© ${new Date().getFullYear()} Gaijin Life Navi. 版权所有。`,
    privacy: '隐私政策',
    terms: '服务条款',
  },
};
