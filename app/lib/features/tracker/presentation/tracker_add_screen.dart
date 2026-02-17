import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import 'providers/tracker_providers.dart';

/// Screen to add a new procedure from available templates.
class TrackerAddScreen extends ConsumerStatefulWidget {
  const TrackerAddScreen({super.key});

  @override
  ConsumerState<TrackerAddScreen> createState() => _TrackerAddScreenState();
}

class _TrackerAddScreenState extends ConsumerState<TrackerAddScreen> {
  bool _isAdding = false;

  Future<void> _addProcedure(String templateId, String refType) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _isAdding = true);
    try {
      final repo = ref.read(trackerRepositoryProvider);
      await repo.addProcedure(
        procedureRefType: refType,
        procedureRefId: templateId,
      );
      ref.invalidate(myProceduresProvider);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.trackerProcedureAdded)));
        context.pop();
      }
    } on DioException catch (e) {
      if (mounted) {
        String message = l10n.genericError;
        if (e.response?.statusCode == 403) {
          message = l10n.trackerLimitReached;
        } else if (e.response?.statusCode == 409) {
          message = l10n.trackerAlreadyTracking;
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.genericError)));
      }
    } finally {
      if (mounted) setState(() => _isAdding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final templates = ref.watch(procedureTemplatesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.trackerAddProcedure)),
      body: templates.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.genericError),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => ref.invalidate(procedureTemplatesProvider),
                    child: Text(l10n.chatRetry),
                  ),
                ],
              ),
            ),
        data: (templateList) {
          if (templateList.isEmpty) {
            return Center(child: Text(l10n.trackerNoTemplates));
          }

          final essential =
              templateList.where((t) => t.isArrivalEssential).toList();
          final others =
              templateList.where((t) => !t.isArrivalEssential).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Free tier notice
              Container(
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
              ),
              const SizedBox(height: 16),

              if (essential.isNotEmpty) ...[
                Text(
                  l10n.trackerEssentialProcedures,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...essential.map(
                  (t) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.errorContainer,
                        child: Icon(
                          Icons.priority_high,
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                      title: Text(t.title),
                      subtitle:
                          t.description != null
                              ? Text(
                                t.description!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )
                              : null,
                      trailing:
                          _isAdding
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed:
                                    () => _addProcedure(t.id, t.procedureType),
                              ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (others.isNotEmpty) ...[
                Text(
                  l10n.trackerOtherProcedures,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...others.map(
                  (t) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.secondaryContainer,
                        child: Icon(
                          Icons.assignment_outlined,
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                      ),
                      title: Text(t.title),
                      subtitle:
                          t.description != null
                              ? Text(
                                t.description!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )
                              : null,
                      trailing:
                          _isAdding
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed:
                                    () => _addProcedure(t.id, t.procedureType),
                              ),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
