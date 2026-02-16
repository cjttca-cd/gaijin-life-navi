import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/router_provider.dart';
import 'providers/banking_providers.dart';

/// Displays a list of banks sorted by foreigner-friendly score.
class BankingListScreen extends ConsumerWidget {
  const BankingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final bankList = ref.watch(bankListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bankingTitle),
        actions: [
          TextButton.icon(
            onPressed: () => context.push(AppRoutes.bankingRecommend),
            icon: const Icon(Icons.recommend),
            label: Text(l10n.bankingRecommendButton),
          ),
        ],
      ),
      body: bankList.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48,
                  color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text(l10n.genericError,
                  style: theme.textTheme.bodyLarge),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () => ref.invalidate(bankListProvider),
                child: Text(l10n.chatRetry),
              ),
            ],
          ),
        ),
        data: (banks) {
          if (banks.isEmpty) {
            return Center(
              child: Text(l10n.bankingEmpty,
                  style: theme.textTheme.bodyLarge),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: banks.length,
            itemBuilder: (context, index) {
              final bank = banks[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Text(
                      '${bank.foreignerFriendlyScore}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  title: Text(bank.bankName),
                  subtitle: Text(
                    '${l10n.bankingFriendlyScore}: ${bank.foreignerFriendlyScore}/5',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(
                    AppRoutes.bankingGuide
                        .replaceFirst(':bankId', bank.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
