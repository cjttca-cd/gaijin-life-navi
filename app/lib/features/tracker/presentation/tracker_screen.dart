import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/router_provider.dart';
import '../domain/user_procedure.dart';
import 'providers/tracker_providers.dart';

/// Admin Tracker screen — checklist of tracked procedures.
class TrackerScreen extends ConsumerWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final procedures = ref.watch(myProceduresProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.trackerTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.trackerAdd),
        tooltip: l10n.trackerAddProcedure,
        child: const Icon(Icons.add),
      ),
      body: procedures.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.genericError),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => ref.invalidate(myProceduresProvider),
                    child: Text(l10n.chatRetry),
                  ),
                ],
              ),
            ),
        data: (procs) {
          if (procs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.checklist_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.trackerEmpty,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.trackerEmptyHint,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Group by status
          final notStarted =
              procs
                  .where((p) => p.status == ProcedureStatus.notStarted)
                  .toList();
          final inProgress =
              procs
                  .where((p) => p.status == ProcedureStatus.inProgress)
                  .toList();
          final completed =
              procs
                  .where((p) => p.status == ProcedureStatus.completed)
                  .toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Free tier limit banner
              _TierLimitBanner(totalCount: procs.length),
              const SizedBox(height: 8),

              if (inProgress.isNotEmpty) ...[
                _SectionHeader(
                  title: l10n.trackerStatusInProgress,
                  count: inProgress.length,
                  color: theme.colorScheme.primary,
                ),
                ...inProgress.map((p) => _ProcedureCard(procedure: p)),
                const SizedBox(height: 16),
              ],
              if (notStarted.isNotEmpty) ...[
                _SectionHeader(
                  title: l10n.trackerStatusNotStarted,
                  count: notStarted.length,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                ...notStarted.map((p) => _ProcedureCard(procedure: p)),
                const SizedBox(height: 16),
              ],
              if (completed.isNotEmpty) ...[
                _SectionHeader(
                  title: l10n.trackerStatusCompleted,
                  count: completed.length,
                  color: theme.colorScheme.tertiary,
                ),
                ...completed.map((p) => _ProcedureCard(procedure: p)),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _TierLimitBanner extends StatelessWidget {
  const _TierLimitBanner({required this.totalCount});

  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    // Show banner only for informational purposes.
    // Actual limit enforcement is done server-side.
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.trackerFreeLimitInfo,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.count,
    required this.color,
  });

  final String title;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(title, style: theme.textTheme.titleSmall),
          const SizedBox(width: 8),
          Text(
            '($count)',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcedureCard extends StatelessWidget {
  const _ProcedureCard({required this.procedure});

  final UserProcedure procedure;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    IconData statusIcon;
    Color statusColor;
    switch (procedure.status) {
      case ProcedureStatus.notStarted:
        statusIcon = Icons.radio_button_unchecked;
        statusColor = theme.colorScheme.onSurfaceVariant;
      case ProcedureStatus.inProgress:
        statusIcon = Icons.timelapse;
        statusColor = theme.colorScheme.primary;
      case ProcedureStatus.completed:
        statusIcon = Icons.check_circle;
        statusColor = theme.colorScheme.tertiary;
    }

    final isOverdue =
        procedure.dueDate != null &&
        procedure.status != ProcedureStatus.completed &&
        procedure.dueDate!.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(statusIcon, color: statusColor),
        title: Text(procedure.title),
        subtitle:
            procedure.dueDate != null
                ? Text(
                  '${l10n.trackerDueDate}: ${_formatDate(procedure.dueDate!)}',
                  style: TextStyle(
                    color: isOverdue ? theme.colorScheme.error : null,
                    fontWeight: isOverdue ? FontWeight.bold : null,
                  ),
                )
                : null,
        trailing:
            isOverdue
                ? Icon(Icons.warning_amber, color: theme.colorScheme.error)
                : const Icon(Icons.chevron_right),
        onTap:
            () => context.push(
              AppRoutes.trackerDetail.replaceFirst(':id', procedure.id),
            ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
