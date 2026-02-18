import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/router_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../chat/presentation/providers/chat_providers.dart';
import '../domain/tracker_item.dart';
import 'providers/tracker_providers.dart';

/// Tracker list screen — displays all saved tracker items.
///
/// - Status cycling via tap on status chip.
/// - Delete via swipe (Dismissible).
/// - Free tier limit banner when applicable.
class TrackerScreen extends ConsumerWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final trackerAsync = ref.watch(trackerItemsProvider);
    final limitReached = ref.watch(trackerLimitReachedProvider);
    final tier = ref.watch(userTierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.trackerTitle)),
      body: trackerAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.genericError)),
        data: (items) {
          if (items.isEmpty) {
            return _EmptyState();
          }
          return Column(
            children: [
              // Free tier limit banner.
              if (limitReached && tier == 'free')
                _LimitBanner(
                  text: l10n.trackerFreeLimitInfo,
                  onUpgrade: () => context.push(AppRoutes.subscription),
                ),

              // Items list.
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                    vertical: AppSpacing.spaceSm,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _TrackerListItem(item: item);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space3xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.checklist,
              size: 64,
              color: cs.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.spaceLg),
            Text(
              l10n.trackerEmpty,
              style: tt.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            Text(
              l10n.trackerEmptyHint,
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _LimitBanner extends StatelessWidget {
  const _LimitBanner({required this.text, required this.onUpgrade});

  final String text;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceLg,
        vertical: AppSpacing.spaceMd,
      ),
      decoration: const BoxDecoration(color: AppColors.warningContainer),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            size: 20,
            color: AppColors.onWarningContainer,
          ),
          const SizedBox(width: AppSpacing.spaceSm),
          Expanded(
            child: Text(
              text,
              style: tt.bodySmall?.copyWith(
                color: AppColors.onWarningContainer,
              ),
            ),
          ),
          TextButton(
            onPressed: onUpgrade,
            child: Text(AppLocalizations.of(context).chatLimitUpgrade),
          ),
        ],
      ),
    );
  }
}

class _TrackerListItem extends ConsumerWidget {
  const _TrackerListItem({required this.item});

  final TrackerItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.spaceSm),
      child: Dismissible(
        key: ValueKey(item.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) => _confirmDelete(context, l10n),
        onDismissed: (_) {
          ref.read(trackerItemsProvider.notifier).delete(item.id);
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: AppSpacing.spaceLg),
          decoration: BoxDecoration(
            color: AppColors.errorContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.delete_outline, color: AppColors.error),
        ),
        child: Material(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              ref.read(trackerItemsProvider.notifier).cycleStatus(item.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.trackerStatusUpdated),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.spaceLg),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Row(
                children: [
                  // Status checkbox.
                  _StatusIcon(status: item.status),
                  const SizedBox(width: AppSpacing.spaceMd),
                  // Title + date.
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: tt.titleSmall?.copyWith(
                            decoration:
                                item.status == TrackerStatus.completed
                                    ? TextDecoration.lineThrough
                                    : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.date != null && item.date!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                Icons.event,
                                size: 12,
                                color: AppColors.warning,
                              ),
                              const SizedBox(width: AppSpacing.spaceXs),
                              Text(
                                item.date!,
                                style: tt.labelSmall?.copyWith(
                                  color: AppColors.warning,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spaceSm),
                  // Status badge.
                  _StatusBadge(status: item.status, l10n: l10n),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, AppLocalizations l10n) {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(l10n.trackerDeleteTitle),
            content: Text(l10n.trackerDeleteConfirm),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.chatDeleteCancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                child: Text(l10n.chatDeleteAction),
              ),
            ],
          ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status});

  final TrackerStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case TrackerStatus.notStarted:
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.onSurfaceVariant, width: 2),
          ),
        );
      case TrackerStatus.inProgress:
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.warning, width: 2),
          ),
          child: const Icon(
            Icons.more_horiz,
            size: 14,
            color: AppColors.warning,
          ),
        );
      case TrackerStatus.completed:
        return Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.success,
          ),
          child: const Icon(Icons.check, size: 16, color: AppColors.onPrimary),
        );
    }
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status, required this.l10n});

  final TrackerStatus status;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case TrackerStatus.notStarted:
        bgColor = AppColors.surfaceVariant;
        textColor = AppColors.onSurfaceVariant;
        label = l10n.trackerStatusNotStarted;
      case TrackerStatus.inProgress:
        bgColor = AppColors.warningContainer;
        textColor = AppColors.onWarningContainer;
        label = l10n.trackerStatusInProgress;
      case TrackerStatus.completed:
        bgColor = AppColors.successContainer;
        textColor = AppColors.onSuccessContainer;
        label = l10n.trackerStatusCompleted;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceSm,
        vertical: AppSpacing.spaceXs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: tt.labelSmall?.copyWith(color: textColor)),
    );
  }
}
