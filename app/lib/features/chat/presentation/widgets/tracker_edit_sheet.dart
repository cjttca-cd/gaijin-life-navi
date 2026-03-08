import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../tracker/domain/tracker_item.dart';
import '../../../tracker/presentation/providers/tracker_providers.dart';
import '../../domain/chat_response.dart';

/// BottomSheet for confirming/editing a tracker item before saving.
///
/// Pre-fills Title from the chat suggestion. Allows adding memo and due date.
class TrackerEditSheet extends ConsumerStatefulWidget {
  const TrackerEditSheet({super.key, required this.item});

  final ChatTrackerItem item;

  @override
  ConsumerState<TrackerEditSheet> createState() => _TrackerEditSheetState();
}

class _TrackerEditSheetState extends ConsumerState<TrackerEditSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _memoController;
  DateTime? _selectedDate;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item.title);
    _memoController = TextEditingController();

    // Try to parse the date from the chat suggestion.
    if (widget.item.date != null && widget.item.date!.isNotEmpty) {
      _selectedDate = DateTime.tryParse(widget.item.date!);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  bool get _canSave => _titleController.text.trim().isNotEmpty && !_saving;

  Future<void> _onSave() async {
    if (!_canSave) return;

    setState(() => _saving = true);

    final memoText = _memoController.text.trim();

    final newItem = TrackerItem(
      id: TrackerItem.generateId(),
      title: _titleController.text.trim(),
      memo: memoText.isEmpty ? null : memoText,
      dueDate: _selectedDate,
      tag: widget.item.type,
      completed: false,
      createdAt: DateTime.now(),
    );

    await ref.read(trackerItemsProvider.notifier).add(newItem);

    if (mounted) {
      final l10n = AppLocalizations.of(context);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.trackerItemSaved)),
      );
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 3)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _clearDate() {
    setState(() => _selectedDate = null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.spaceLg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.4,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.spaceLg),

              // Sheet title
              Row(
                children: [
                  Icon(
                    Icons.checklist,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: AppSpacing.spaceSm),
                  Text(
                    l10n.trackerEditTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spaceXl),

              // Title field
              Text(
                l10n.trackerEditFieldTitle,
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(height: AppSpacing.spaceXs),
              TextFormField(
                controller: _titleController,
                onChanged: (_) => setState(() {}),
                maxLines: 2,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: l10n.trackerEditFieldTitle,
                ),
              ),
              const SizedBox(height: AppSpacing.spaceLg),

              // Memo field
              Text(
                l10n.trackerEditFieldMemo,
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(height: AppSpacing.spaceXs),
              TextFormField(
                controller: _memoController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: l10n.trackerEditFieldMemo,
                ),
              ),
              const SizedBox(height: AppSpacing.spaceLg),

              // Due date field
              Text(
                l10n.trackerEditFieldDate,
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(height: AppSpacing.spaceXs),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(4),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.spaceSm),
                      Expanded(
                        child: Text(
                          _selectedDate != null
                              ? DateFormat.yMMMd().format(_selectedDate!)
                              : l10n.trackerEditFieldDate,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: _selectedDate != null
                                ? null
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      if (_selectedDate != null)
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: _clearDate,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.spaceXl),

              // Save button
              FilledButton(
                onPressed: _canSave ? _onSave : null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(l10n.trackerEditSave),
              ),
              const SizedBox(height: AppSpacing.spaceSm),

              // Cancel button
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.trackerEditCancel),
              ),
              const SizedBox(height: AppSpacing.spaceSm),
            ],
          ),
        ),
      ),
    );
  }
}
