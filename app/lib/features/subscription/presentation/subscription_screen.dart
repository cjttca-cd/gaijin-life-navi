import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../domain/subscription_plan.dart';
import 'providers/subscription_providers.dart';

/// Subscription management screen — plan comparison + checkout.
class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final plansAsync = ref.watch(subscriptionPlansProvider);
    final mySubAsync = ref.watch(mySubscriptionProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.subscriptionTitle)),
      body: plansAsync.when(
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
                    onPressed: () => ref.invalidate(subscriptionPlansProvider),
                    child: Text(l10n.chatRetry),
                  ),
                ],
              ),
            ),
        data: (plans) {
          final mySub = mySubAsync.valueOrNull;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Current plan info
              _CurrentPlanCard(subscription: mySub),
              const SizedBox(height: 24),

              // Plan comparison header
              Text(
                l10n.subscriptionPlansTitle,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.subscriptionPlansSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Free plan card
              _FreePlanCard(isCurrentPlan: mySub?.isFree ?? true),
              const SizedBox(height: 12),

              // Paid plan cards
              ...plans.map((plan) {
                final isCurrent =
                    mySub != null &&
                    !mySub.isFree &&
                    ((plan.id == 'premium_monthly' &&
                            mySub.tier == 'premium') ||
                        (plan.id == 'premium_plus_monthly' &&
                            mySub.tier == 'premium_plus'));
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _PlanCard(
                    plan: plan,
                    isCurrentPlan: isCurrent,
                    isCancelling: isCurrent && mySub.isCancelling,
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

// ─── Current Plan Card ───────────────────────────────────────

class _CurrentPlanCard extends StatelessWidget {
  const _CurrentPlanCard({this.subscription});

  final UserSubscription? subscription;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isFree = subscription?.isFree ?? true;
    final tierName =
        isFree
            ? l10n.subscriptionTierFree
            : subscription?.tier == 'premium_plus'
            ? l10n.subscriptionTierPremiumPlus
            : l10n.subscriptionTierPremium;

    return Card(
      color:
          isFree
              ? theme.colorScheme.surfaceContainerHighest
              : theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              isFree ? Icons.person_outline : Icons.star,
              size: 32,
              color:
                  isFree
                      ? theme.colorScheme.onSurfaceVariant
                      : theme.colorScheme.onPrimaryContainer,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.subscriptionCurrentPlan,
              style: theme.textTheme.bodyMedium?.copyWith(
                color:
                    isFree
                        ? theme.colorScheme.onSurfaceVariant
                        : theme.colorScheme.onPrimaryContainer,
              ),
            ),
            Text(
              tierName,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color:
                    isFree
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onPrimaryContainer,
              ),
            ),
            if (subscription != null &&
                subscription!.isCancelling &&
                subscription!.currentPeriodEnd != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  l10n.subscriptionCancellingAt(
                    _formatDate(subscription!.currentPeriodEnd!),
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }
}

// ─── Free Plan Card ──────────────────────────────────────────

class _FreePlanCard extends StatelessWidget {
  const _FreePlanCard({required this.isCurrentPlan});

  final bool isCurrentPlan;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final features = [
      l10n.subscriptionFeatureFreeChat,
      l10n.subscriptionFeatureFreeScans,
      l10n.subscriptionFeatureFreeTracker,
      l10n.subscriptionFeatureFreeCommunityRead,
    ];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side:
            isCurrentPlan
                ? BorderSide(color: theme.colorScheme.primary, width: 2)
                : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              l10n.subscriptionTierFree,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.subscriptionFreePrice,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            ...features.map((f) => _FeatureRow(text: f, included: true)),
            _FeatureRow(
              text: l10n.subscriptionFeatureCommunityPost,
              included: false,
            ),
            _FeatureRow(
              text: l10n.subscriptionFeatureUnlimitedChat,
              included: false,
            ),
            if (isCurrentPlan)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: OutlinedButton(
                  onPressed: null,
                  child: Text(l10n.subscriptionCurrentPlanBadge),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Paid Plan Card ──────────────────────────────────────────

class _PlanCard extends ConsumerWidget {
  const _PlanCard({
    required this.plan,
    required this.isCurrentPlan,
    required this.isCancelling,
  });

  final SubscriptionPlan plan;
  final bool isCurrentPlan;
  final bool isCancelling;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isPremiumPlus = plan.id == 'premium_plus_monthly';

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side:
            isCurrentPlan
                ? BorderSide(color: theme.colorScheme.primary, width: 2)
                : isPremiumPlus
                ? BorderSide(
                  color: theme.colorScheme.tertiary.withValues(alpha: 0.5),
                )
                : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (isPremiumPlus)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  l10n.subscriptionRecommended,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onTertiary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Text(
              plan.name,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.subscriptionPricePerMonth(plan.price),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            ...plan.features.map((f) => _FeatureRow(text: f, included: true)),
            const SizedBox(height: 16),
            if (isCurrentPlan)
              isCancelling
                  ? OutlinedButton(
                    onPressed: null,
                    child: Text(l10n.subscriptionCancelling),
                  )
                  : OutlinedButton(
                    onPressed: null,
                    child: Text(l10n.subscriptionCurrentPlanBadge),
                  )
            else
              FilledButton(
                onPressed: () => _checkout(context, ref),
                child: Text(l10n.subscriptionCheckout),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkout(BuildContext context, WidgetRef ref) async {
    try {
      final repo = ref.read(subscriptionRepositoryProvider);
      final checkoutUrl = await repo.createCheckout(planId: plan.id);

      final uri = Uri.parse(checkoutUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      if (context.mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.genericError)));
      }
    }
  }
}

// ─── Feature Row ─────────────────────────────────────────────

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.text, required this.included});

  final String text;
  final bool included;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            included ? Icons.check_circle : Icons.cancel,
            size: 20,
            color:
                included
                    ? theme.colorScheme.tertiary
                    : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color:
                    included
                        ? null
                        : theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.5,
                        ),
                decoration: included ? null : TextDecoration.lineThrough,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
