import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../../core/providers/router_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../tracker/presentation/providers/tracker_providers.dart';
import '../../domain/chat_response.dart';

/// Displays AI-suggested tracker items inside the AI chat bubble.
///
/// Each item shows type icon, title, optional date, and a Save button.
/// Per DESIGN_SYSTEM.md §6.2.5 Tracker Item Card spec.
class TrackerItemCards extends ConsumerWidget {
  const TrackerItemCards({super.key, required this.items});

  final List<ChatTrackerItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.spaceSm),
          child: Divider(height: 1),
        ),
        // Section header.
        Row(
          children: [
            Icon(Icons.checklist, size: 16, color: cs.primary),
            const SizedBox(width: AppSpacing.spaceXs),
            Text(
              l10n.trackerTitle,
              style: tt.labelMedium?.copyWith(color: cs.primary),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.spaceSm),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.spaceXs),
            child: _TrackerItemCard(item: item),
          ),
        ),
      ],
    );
  }
}

class _TrackerItemCard extends ConsumerWidget {
  const _TrackerItemCard({required this.item});

  final ChatTrackerItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isSaved = ref.watch(isTrackerItemSavedProvider(item.title));
    final limitReached = ref.watch(trackerLimitReachedProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceMd),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          // Type icon.
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.adminContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _iconForType(item.type),
              size: 16,
              color: AppColors.adminIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.spaceMd),
          // Title + date.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: tt.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.date != null && item.date!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.date!,
                    style: tt.labelSmall?.copyWith(color: AppColors.warning),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.spaceSm),
          // Save / Saved button.
          if (isSaved)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spaceSm,
                vertical: AppSpacing.spaceXs,
              ),
              decoration: BoxDecoration(
                color: AppColors.successContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check, size: 14, color: AppColors.success),
                  const SizedBox(width: 2),
                  Text(
                    l10n.trackerSaved,
                    style: tt.labelSmall?.copyWith(
                      color: AppColors.onSuccessContainer,
                    ),
                  ),
                ],
              ),
            )
          else
            _SaveButton(item: item, limitReached: limitReached),
        ],
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type.toLowerCase()) {
      case 'deadline':
        return Icons.event;
      case 'task':
        return Icons.assignment_outlined;
      case 'appointment':
        return Icons.calendar_today;
      case 'document':
        return Icons.description_outlined;
      default:
        return Icons.checklist;
    }
  }
}

class _SaveButton extends ConsumerWidget {
  const _SaveButton({required this.item, required this.limitReached});

  final ChatTrackerItem item;
  final bool limitReached;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tt = Theme.of(context).textTheme;

    return SizedBox(
      height: 32,
      child: FilledButton.tonal(
        onPressed: () => _onSave(context, ref),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spaceMd),
          textStyle: tt.labelMedium,
        ),
        child: Text(l10n.trackerSave),
      ),
    );
  }

  Future<void> _onSave(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final limitReached = ref.read(trackerLimitReachedProvider);

    if (limitReached) {
      // Show upgrade CTA.
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.trackerLimitReached),
            action: SnackBarAction(
              label: l10n.chatLimitUpgrade,
              onPressed: () => context.push(AppRoutes.subscription),
            ),
          ),
        );
      }
      return;
    }

    final notifier = ref.read(trackerItemsProvider.notifier);
    final success = await notifier.saveFromChat(
      title: item.title,
      dateString: item.date,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? l10n.trackerItemSaved : l10n.trackerAlreadyTracking,
          ),
        ),
      );
    }
  }
}
