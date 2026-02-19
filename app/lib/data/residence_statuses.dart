/// Residence status (在留資格) data for Japan.
///
/// Data source: 出入国在留管理庁 (Immigration Services Agency of Japan)
/// https://www.moj.go.jp/isa/
///
/// All 29 official residence status categories are included.
/// [common] = true for the most frequently held statuses among foreign
/// residents, shown at the top of selection UIs.
library;

class ResidenceStatusItem {
  final String id;
  final String nameJa;
  final String nameEn;
  final bool common;

  const ResidenceStatusItem({
    required this.id,
    required this.nameJa,
    required this.nameEn,
    this.common = false,
  });
}

const List<ResidenceStatusItem> residenceStatuses = [
  // ── common = true（上位表示）──────────────────────────────
  ResidenceStatusItem(
    id: 'engineer_specialist',
    nameJa: '技術・人文知識・国際業務',
    nameEn: 'Engineer/Specialist in Humanities/International Services',
    common: true,
  ),
  ResidenceStatusItem(
    id: 'student',
    nameJa: '留学',
    nameEn: 'Student',
    common: true,
  ),
  ResidenceStatusItem(
    id: 'dependent',
    nameJa: '家族滞在',
    nameEn: 'Dependent',
    common: true,
  ),
  ResidenceStatusItem(
    id: 'permanent_resident',
    nameJa: '永住者',
    nameEn: 'Permanent Resident',
    common: true,
  ),
  ResidenceStatusItem(
    id: 'spouse_of_japanese',
    nameJa: '日本人の配偶者等',
    nameEn: 'Spouse or Child of Japanese National',
    common: true,
  ),
  ResidenceStatusItem(
    id: 'specified_skilled_worker',
    nameJa: '特定技能',
    nameEn: 'Specified Skilled Worker',
    common: true,
  ),
  ResidenceStatusItem(
    id: 'business_manager',
    nameJa: '経営・管理',
    nameEn: 'Business Manager',
    common: true,
  ),
  ResidenceStatusItem(
    id: 'highly_skilled_professional',
    nameJa: '高度専門職',
    nameEn: 'Highly Skilled Professional',
    common: true,
  ),
  ResidenceStatusItem(
    id: 'long_term_resident',
    nameJa: '定住者',
    nameEn: 'Long-Term Resident',
    common: true,
  ),
  ResidenceStatusItem(
    id: 'designated_activities',
    nameJa: '特定活動',
    nameEn: 'Designated Activities',
    common: true,
  ),

  // ── common = false（折りたたみ表示）─────────────────────────
  // 外交・公用
  ResidenceStatusItem(
    id: 'diplomat',
    nameJa: '外交',
    nameEn: 'Diplomat',
  ),
  ResidenceStatusItem(
    id: 'official',
    nameJa: '公用',
    nameEn: 'Official',
  ),

  // 教授〜芸術（就労資格）
  ResidenceStatusItem(
    id: 'professor',
    nameJa: '教授',
    nameEn: 'Professor',
  ),
  ResidenceStatusItem(
    id: 'artist',
    nameJa: '芸術',
    nameEn: 'Artist',
  ),
  ResidenceStatusItem(
    id: 'religious_activities',
    nameJa: '宗教',
    nameEn: 'Religious Activities',
  ),
  ResidenceStatusItem(
    id: 'journalist',
    nameJa: '報道',
    nameEn: 'Journalist',
  ),

  // 投資・経営系以外の就労資格
  ResidenceStatusItem(
    id: 'legal_accounting',
    nameJa: '法律・会計業務',
    nameEn: 'Legal/Accounting Services',
  ),
  ResidenceStatusItem(
    id: 'medical_services',
    nameJa: '医療',
    nameEn: 'Medical Services',
  ),
  ResidenceStatusItem(
    id: 'researcher',
    nameJa: '研究',
    nameEn: 'Researcher',
  ),
  ResidenceStatusItem(
    id: 'instructor',
    nameJa: '教育',
    nameEn: 'Instructor',
  ),
  ResidenceStatusItem(
    id: 'intra_company_transferee',
    nameJa: '企業内転勤',
    nameEn: 'Intra-company Transferee',
  ),
  ResidenceStatusItem(
    id: 'nursing_care',
    nameJa: '介護',
    nameEn: 'Nursing Care',
  ),
  ResidenceStatusItem(
    id: 'entertainer',
    nameJa: '興行',
    nameEn: 'Entertainer',
  ),
  ResidenceStatusItem(
    id: 'skilled_labor',
    nameJa: '技能',
    nameEn: 'Skilled Labor',
  ),
  ResidenceStatusItem(
    id: 'technical_intern_training',
    nameJa: '技能実習',
    nameEn: 'Technical Intern Training',
  ),

  // 非就労資格
  ResidenceStatusItem(
    id: 'cultural_activities',
    nameJa: '文化活動',
    nameEn: 'Cultural Activities',
  ),
  ResidenceStatusItem(
    id: 'temporary_visitor',
    nameJa: '短期滞在',
    nameEn: 'Temporary Visitor',
  ),
  ResidenceStatusItem(
    id: 'trainee',
    nameJa: '研修',
    nameEn: 'Trainee',
  ),

  // 身分・地位に基づく在留資格（permanent_resident, spouse_of_japanese,
  // long_term_resident は common セクションに含む）
  ResidenceStatusItem(
    id: 'spouse_of_permanent_resident',
    nameJa: '永住者の配偶者等',
    nameEn: 'Spouse or Child of Permanent Resident',
  ),
];
