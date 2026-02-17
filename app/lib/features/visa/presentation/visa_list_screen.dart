import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/router_provider.dart';
import '../../chat/presentation/widgets/disclaimer_banner.dart';
import 'providers/visa_providers.dart';

/// Displays a list of visa procedures with optional residence status filter.
class VisaListScreen extends ConsumerStatefulWidget {
  const VisaListScreen({super.key});

  @override
  ConsumerState<VisaListScreen> createState() => _VisaListScreenState();
}

class _VisaListScreenState extends ConsumerState<VisaListScreen> {
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final procedures = ref.watch(visaProceduresProvider(_selectedStatus));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.visaTitle)),
      body: Column(
        children: [
          // Disclaimer banner (mandatory for Visa Navigator)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: DisclaimerBanner(text: l10n.visaDisclaimer),
          ),

          // Filter chips
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: Text(l10n.visaFilterAll),
                    selected: _selectedStatus == null,
                    onSelected: (_) {
                      setState(() => _selectedStatus = null);
                    },
                  ),
                  const SizedBox(width: 8),
                  ..._statusFilters(l10n).map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(entry.value),
                        selected: _selectedStatus == entry.key,
                        onSelected: (_) {
                          setState(() => _selectedStatus = entry.key);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Procedure list
          Expanded(
            child: procedures.when(
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
                          onPressed:
                              () => ref.invalidate(
                                visaProceduresProvider(_selectedStatus),
                              ),
                          child: Text(l10n.chatRetry),
                        ),
                      ],
                    ),
                  ),
              data: (procs) {
                if (procs.isEmpty) {
                  return Center(
                    child: Text(
                      l10n.visaEmpty,
                      style: theme.textTheme.bodyLarge,
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: procs.length,
                  itemBuilder: (context, index) {
                    final proc = procs[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.secondaryContainer,
                          child: Icon(
                            Icons.assignment_outlined,
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                        ),
                        title: Text(proc.title),
                        subtitle:
                            proc.description != null
                                ? Text(
                                  proc.description!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                                : null,
                        trailing: const Icon(Icons.chevron_right),
                        onTap:
                            () => context.push(
                              AppRoutes.visaDetail.replaceFirst(
                                ':procedureId',
                                proc.id,
                              ),
                            ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<MapEntry<String, String>> _statusFilters(AppLocalizations l10n) {
    return [
      MapEntry('engineer_specialist', l10n.statusEngineer),
      MapEntry('student', l10n.statusStudent),
      MapEntry('dependent', l10n.statusDependent),
      MapEntry('permanent_resident', l10n.statusPermanent),
      MapEntry('spouse_of_japanese', l10n.statusSpouse),
    ];
  }
}
