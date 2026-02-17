import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Domain-specific color sets from DESIGN_SYSTEM.md §1.7.
///
/// Each Navigator domain has an accent, container, and icon color.
class DomainColorSet {
  const DomainColorSet({
    required this.accent,
    required this.container,
    required this.icon,
  });

  final Color accent;
  final Color container;
  final Color icon;
}

/// Maps domain IDs to their color sets and icons.
class DomainColors {
  const DomainColors._();

  static const banking = DomainColorSet(
    accent: AppColors.bankingAccent,
    container: AppColors.bankingContainer,
    icon: AppColors.bankingIcon,
  );

  static const visa = DomainColorSet(
    accent: AppColors.visaAccent,
    container: AppColors.visaContainer,
    icon: AppColors.visaIcon,
  );

  static const medical = DomainColorSet(
    accent: AppColors.medicalAccent,
    container: AppColors.medicalContainer,
    icon: AppColors.medicalIcon,
  );

  static const concierge = DomainColorSet(
    accent: AppColors.adminAccent,
    container: AppColors.adminContainer,
    icon: AppColors.adminIcon,
  );

  static const housing = DomainColorSet(
    accent: AppColors.housingAccent,
    container: AppColors.housingContainer,
    icon: AppColors.housingIcon,
  );

  static const employment = DomainColorSet(
    accent: AppColors.workAccent,
    container: AppColors.workContainer,
    icon: AppColors.workIcon,
  );

  static const education = DomainColorSet(
    accent: AppColors.transportAccent,
    container: AppColors.transportContainer,
    icon: AppColors.transportIcon,
  );

  static const legal = DomainColorSet(
    accent: AppColors.foodAccent,
    container: AppColors.foodContainer,
    icon: AppColors.foodIcon,
  );

  /// Get color set by domain ID.
  static DomainColorSet forDomain(String domainId) {
    switch (domainId) {
      case 'banking':
        return banking;
      case 'visa':
        return visa;
      case 'medical':
        return medical;
      case 'concierge':
        return concierge;
      case 'housing':
        return housing;
      case 'employment':
        return employment;
      case 'education':
        return education;
      case 'legal':
        return legal;
      default:
        return concierge;
    }
  }

  /// Get Material icon for domain.
  static IconData iconForDomain(String domainId) {
    switch (domainId) {
      case 'banking':
        return Icons.account_balance;
      case 'visa':
        return Icons.badge;
      case 'medical':
        return Icons.local_hospital;
      case 'concierge':
        return Icons.assignment;
      case 'housing':
        return Icons.home_work;
      case 'employment':
        return Icons.work_outline;
      case 'education':
        return Icons.school;
      case 'legal':
        return Icons.gavel;
      default:
        return Icons.assignment;
    }
  }
}
