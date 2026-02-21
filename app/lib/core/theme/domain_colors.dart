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

  static const finance = DomainColorSet(
    accent: AppColors.bankingAccent,
    container: AppColors.bankingContainer,
    icon: AppColors.bankingIcon,
  );

  static const tax = DomainColorSet(
    accent: AppColors.workAccent,
    container: AppColors.workContainer,
    icon: AppColors.workIcon,
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

  static const life = DomainColorSet(
    accent: AppColors.adminAccent,
    container: AppColors.adminContainer,
    icon: AppColors.adminIcon,
  );

  static const legal = DomainColorSet(
    accent: AppColors.foodAccent,
    container: AppColors.foodContainer,
    icon: AppColors.foodIcon,
  );

  /// Get color set by domain ID.
  static DomainColorSet forDomain(String domainId) {
    switch (domainId) {
      case 'finance':
        return finance;
      case 'tax':
        return tax;
      case 'visa':
        return visa;
      case 'medical':
        return medical;
      case 'life':
        return life;
      case 'legal':
        return legal;
      default:
        return life;
    }
  }

  /// Get Material icon for domain.
  static IconData iconForDomain(String domainId) {
    switch (domainId) {
      case 'finance':
        return Icons.account_balance;
      case 'tax':
        return Icons.receipt_long;
      case 'visa':
        return Icons.badge;
      case 'medical':
        return Icons.local_hospital;
      case 'life':
        return Icons.public;
      case 'legal':
        return Icons.gavel;
      default:
        return Icons.public;
    }
  }
}
