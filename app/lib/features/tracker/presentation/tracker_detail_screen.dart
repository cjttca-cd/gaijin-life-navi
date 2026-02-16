import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../domain/user_procedure.dart';
import 'providers/tracker_providers.dart';

/// Detail screen for a tracked procedure with status change controls.
class TrackerDetailScreen extends ConsumerStatefulWidget {
  const TrackerDetailScreen({super.key, required this.procedureId});

  final String procedureId;

  @override
  ConsumerState<TrackerDetailScreen> createState() =>
      _TrackerDetailScreenState();
}

class _TrackerDetailScreenState extends ConsumerState<TrackerDetailScreen> {
  bool _isUpdating = false;

  Future<void> _updateStatus(ProcedureStatus newStatus) async {
    setState(() => _isUpdating = true);
    try {
      final repo = ref.read(trackerRepositoryProvider);
      await repo.updateProcedure(widget.procedureId, status: newStatus);
      ref.invalidate(myProceduresProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context).trackerStatusUpdated)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context).genericError)),
        );
      }
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  Future<void> _deleteProcedure() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.trackerDeleteTitle),
        content: Text(l10n.trackerDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.chatDeleteCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.chatDeleteAction),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final repo = ref.read(trackerRepositoryProvider);
      await repo.deleteProcedure(widget.procedureId);
      ref.invalidate(myProceduresProvider);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).genericError)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final proceduresAsync = ref.watch(myProceduresProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.trackerDetailTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteProcedure,
            tooltip: l10n.trackerDeleteTitle,
          ),
        ],
      ),
      body: proceduresAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(l10n.genericError)),
        data: (procedures) {
          final procedure = procedures.where(
            (p) => p.id == widget.procedureId,
          );
          if (procedure.isEmpty) {
            return Center(child: Text(l10n.genericError));
          }
          final proc = procedure.first;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(proc.title, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 16),

                // Current status
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.trackerCurrentStatus,
                            style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        _StatusChip(status: proc.status),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Due date
                if (proc.dueDate != null) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today,
                              color: theme.colorScheme.primary),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.trackerDueDate,
                                  style: theme.textTheme.labelMedium),
                              Text(
                                _formatDate(proc.dueDate!),
                                style: theme.textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Notes
                if (proc.notes != null && proc.notes!.isNotEmpty) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.trackerNotes,
                              style: theme.textTheme.labelMedium),
                          const SizedBox(height: 4),
                          Text(proc.notes!),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Status change buttons
                Text(l10n.trackerChangeStatus,
                    style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),

                if (_isUpdating)
                  const Center(child: CircularProgressIndicator())
                else ...[
                  if (proc.status != ProcedureStatus.inProgress)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: FilledButton.icon(
                        onPressed: () =>
                            _updateStatus(ProcedureStatus.inProgress),
                        icon: const Icon(Icons.play_arrow),
                        label: Text(l10n.trackerMarkInProgress),
                      ),
                    ),
                  if (proc.status != ProcedureStatus.completed)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: FilledButton.tonalIcon(
                        onPressed: () =>
                            _updateStatus(ProcedureStatus.completed),
                        icon: const Icon(Icons.check),
                        label: Text(l10n.trackerMarkCompleted),
                      ),
                    ),
                  if (proc.status == ProcedureStatus.completed)
                    OutlinedButton.icon(
                      onPressed: () =>
                          _updateStatus(ProcedureStatus.inProgress),
                      icon: const Icon(Icons.undo),
                      label: Text(l10n.trackerMarkIncomplete),
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final ProcedureStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    String label;
    Color color;
    IconData icon;

    switch (status) {
      case ProcedureStatus.notStarted:
        label = l10n.trackerStatusNotStarted;
        color = theme.colorScheme.onSurfaceVariant;
        icon = Icons.radio_button_unchecked;
      case ProcedureStatus.inProgress:
        label = l10n.trackerStatusInProgress;
        color = theme.colorScheme.primary;
        icon = Icons.timelapse;
      case ProcedureStatus.completed:
        label = l10n.trackerStatusCompleted;
        color = theme.colorScheme.tertiary;
        icon = Icons.check_circle;
    }

    return Chip(
      avatar: Icon(icon, size: 18, color: color),
      label: Text(label, style: TextStyle(color: color)),
      side: BorderSide(color: color),
      backgroundColor: color.withValues(alpha: 0.1),
    );
  }
}
