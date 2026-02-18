import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../domain/tracker_item.dart';
import 'providers/tracker_providers.dart';

/// To-do list screen — displays all saved tracker items.
///
/// - FAB to add new to-do.
/// - Checkbox to toggle complete.
/// - Swipe to delete (Dismissible).
/// - Completed items shown with strikethrough + grey.
class TrackerScreen extends ConsumerWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final trackerAsync = ref.watch(trackerItemsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.trackerTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: trackerAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.genericError)),
        data: (items) {
          if (items.isEmpty) {
            return _EmptyState();
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
              vertical: AppSpacing.spaceSm,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _TrackerListItem(item: item);
            },
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _AddItemSheet(ref: ref),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────

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
              l10n.trackerNoItems,
              style: tt.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            Text(
              l10n.trackerNoItemsHint,
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── List Item ────────────────────────────────────────────────

class _TrackerListItem extends ConsumerWidget {
  const _TrackerListItem({required this.item});

  final TrackerItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // Due date display.
    final dueDateInfo = _dueDateInfo(context, item);

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
              ref
                  .read(trackerItemsProvider.notifier)
                  .toggleComplete(item.id);
            },
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.spaceLg),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Checkbox.
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: item.completed,
                        onChanged: (_) {
                          ref
                              .read(trackerItemsProvider.notifier)
                              .toggleComplete(item.id);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spaceMd),
                  // Title + due date + memo.
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: tt.titleSmall?.copyWith(
                            decoration: item.completed
                                ? TextDecoration.lineThrough
                                : null,
                            color: item.completed
                                ? cs.onSurfaceVariant
                                : cs.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (dueDateInfo != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.event,
                                size: 14,
                                color: dueDateInfo.color,
                              ),
                              const SizedBox(width: AppSpacing.spaceXs),
                              Text(
                                dueDateInfo.label,
                                style: tt.labelSmall?.copyWith(
                                  color: dueDateInfo.color,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (item.memo != null &&
                            item.memo!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.memo!,
                            style: tt.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
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
      builder: (context) => AlertDialog(
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

// ─── Due Date Helper ──────────────────────────────────────────

class _DueDateInfo {
  const _DueDateInfo({required this.label, required this.color});
  final String label;
  final Color color;
}

_DueDateInfo? _dueDateInfo(BuildContext context, TrackerItem item) {
  if (item.dueDate == null) return null;
  final l10n = AppLocalizations.of(context);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final due = DateTime(
    item.dueDate!.year,
    item.dueDate!.month,
    item.dueDate!.day,
  );

  if (item.completed) {
    return _DueDateInfo(
      label: DateFormat.yMMMd().format(item.dueDate!),
      color: AppColors.onSurfaceVariant,
    );
  }

  if (due.isBefore(today)) {
    return _DueDateInfo(
      label: '${l10n.trackerOverdue} • ${DateFormat.yMMMd().format(item.dueDate!)}',
      color: AppColors.error,
    );
  }

  if (due.isAtSameMomentAs(today)) {
    return _DueDateInfo(
      label: l10n.trackerDueToday,
      color: AppColors.warning,
    );
  }

  return _DueDateInfo(
    label: DateFormat.yMMMd().format(item.dueDate!),
    color: AppColors.onSurfaceVariant,
  );
}

// ─── Add Item Bottom Sheet ─────────────────────────────────────

class _AddItemSheet extends ConsumerStatefulWidget {
  const _AddItemSheet({required this.ref});

  final WidgetRef ref;

  @override
  ConsumerState<_AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends ConsumerState<_AddItemSheet> {
  final _titleController = TextEditingController();
  final _memoController = TextEditingController();
  DateTime? _dueDate;

  @override
  void dispose() {
    _titleController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        top: AppSpacing.spaceLg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.spaceLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header.
          Text(l10n.trackerAddItem, style: tt.titleLarge),
          const SizedBox(height: AppSpacing.spaceLg),

          // Title field.
          TextField(
            controller: _titleController,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.trackerAddTitle,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.spaceMd),

          // Memo field.
          TextField(
            controller: _memoController,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.trackerAddMemo,
              border: const OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: AppSpacing.spaceMd),

          // Due date picker.
          InkWell(
            onTap: _pickDueDate,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spaceMd,
                vertical: AppSpacing.spaceMd,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: cs.outline),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.event, color: cs.onSurfaceVariant),
                  const SizedBox(width: AppSpacing.spaceMd),
                  Expanded(
                    child: Text(
                      _dueDate != null
                          ? DateFormat.yMMMd().format(_dueDate!)
                          : l10n.trackerAddDueDate,
                      style: tt.bodyMedium?.copyWith(
                        color: _dueDate != null
                            ? cs.onSurface
                            : cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                  if (_dueDate != null)
                    GestureDetector(
                      onTap: () => setState(() => _dueDate = null),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.spaceLg),

          // Save button.
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: _save,
              child: Text(l10n.trackerSave),
            ),
          ),
          const SizedBox(height: AppSpacing.spaceSm),
        ],
      ),
    );
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final memo = _memoController.text.trim();
    final item = TrackerItem(
      id: TrackerItem.generateId(),
      title: title,
      memo: memo.isNotEmpty ? memo : null,
      dueDate: _dueDate,
      completed: false,
      createdAt: DateTime.now(),
    );

    widget.ref.read(trackerItemsProvider.notifier).add(item);
    Navigator.of(context).pop();
  }
}
