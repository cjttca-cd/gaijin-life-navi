import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../chat/presentation/providers/chat_providers.dart';
import 'providers/subscription_providers.dart';

/// S16: Subscription — plan comparison + charge packs + FAQ.
///
/// Phase 0: Plans display only (IAP purchase is a separate task).
class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final plansAsync = ref.watch(subscriptionPlansProvider);
    final currentTier = ref.watch(userTierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.subTitle)),
      body: plansAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => _buildError(context, ref),
        data: (plans) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.space2xl),

                // Choose a Plan section
                _SectionHeader(title: l10n.subSectionChoose),
                const SizedBox(height: AppSpacing.spaceSm),

                // Horizontal plan cards
                SizedBox(
                  height: 420,
                  child: PageView(
                    controller: PageController(viewportFraction: 0.85),
                    children: [
                      _PlanCard(
                        planId: 'free',
                        planName: l10n.subPlanFree,
                        price: l10n.subPriceFree,
                        interval: l10n.subPriceInterval,
                        features: [
                          _FeatureItem(l10n.subFeatureChatFree, true),
                          _FeatureItem(l10n.subFeatureTrackerFree, true),
                          _FeatureItem(l10n.subFeatureAdsYes, false),
                          _FeatureItem(l10n.subFeatureImageNo, false),
                        ],
                        isCurrentPlan: currentTier == 'free',
                        isRecommended: false,
                        onChoose: null,
                      ),
                      _PlanCard(
                        planId: 'standard',
                        planName: l10n.subPlanStandard,
                        price: l10n.subPriceStandard,
                        interval: l10n.subPriceInterval,
                        features: [
                          _FeatureItem(l10n.subFeatureChatStandard, true),
                          _FeatureItem(l10n.subFeatureTrackerPaid, true),
                          _FeatureItem(l10n.subFeatureAdsNo, true),
                          _FeatureItem(l10n.subFeatureImageNo, false),
                        ],
                        isCurrentPlan: currentTier == 'standard',
                        isRecommended: currentTier != 'standard',
                        onChoose:
                            currentTier == 'standard'
                                ? null
                                : () {
                                  // IAP purchase placeholder — separate task.
                                },
                      ),
                      _PlanCard(
                        planId: 'premium',
                        planName: l10n.subPlanPremium,
                        price: l10n.subPricePremium,
                        interval: l10n.subPriceInterval,
                        features: [
                          _FeatureItem(l10n.subFeatureChatPremium, true),
                          _FeatureItem(l10n.subFeatureTrackerPaid, true),
                          _FeatureItem(l10n.subFeatureAdsNo, true),
                          _FeatureItem(l10n.subFeatureImageYes, true),
                        ],
                        isCurrentPlan: currentTier == 'premium',
                        isRecommended: false,
                        onChoose:
                            currentTier == 'premium'
                                ? null
                                : () {
                                  // IAP purchase placeholder — separate task.
                                },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.space2xl),

                // Charge packs section
                _SectionHeader(title: l10n.subSectionCharge),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Column(
                    children: [
                      _ChargePackCard(
                        title: l10n.subCharge100,
                        price: l10n.subCharge100Price,
                      ),
                      const SizedBox(height: AppSpacing.spaceSm),
                      _ChargePackCard(
                        title: l10n.subCharge50,
                        price: l10n.subCharge50Price,
                      ),
                      const SizedBox(height: AppSpacing.spaceSm),
                      Text(
                        l10n.subChargeDescription,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.space2xl),

                // FAQ section
                _SectionHeader(title: l10n.subSectionFaq),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Card(
                    child: Column(
                      children: [
                        _FaqItem(
                          question: l10n.subFaqBillingQ,
                          answer: l10n.subFaqBillingA,
                        ),
                        Divider(
                          height: 1,
                          color: theme.colorScheme.outlineVariant,
                        ),
                        _FaqItem(
                          question: l10n.subFaqCancelQ,
                          answer: l10n.subFaqCancelA,
                        ),
                        Divider(
                          height: 1,
                          color: theme.colorScheme.outlineVariant,
                        ),
                        _FaqItem(
                          question: l10n.subFaqDowngradeQ,
                          answer: l10n.subFaqDowngradeA,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.space2xl),

                // Footer
                Center(
                  child: Text(
                    l10n.subFooter,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.space3xl),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          Text(
            l10n.subErrorLoad,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          TextButton(
            onPressed: () => ref.invalidate(subscriptionPlansProvider),
            child: Text(l10n.subErrorRetry),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        0,
        AppSpacing.screenPadding,
        AppSpacing.spaceMd,
      ),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _FeatureItem {
  const _FeatureItem(this.text, this.included);
  final String text;
  final bool included;
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.planId,
    required this.planName,
    required this.price,
    required this.interval,
    required this.features,
    required this.isCurrentPlan,
    required this.isRecommended,
    required this.onChoose,
  });

  final String planId;
  final String planName;
  final String price;
  final String interval;
  final List<_FeatureItem> features;
  final bool isCurrentPlan;
  final bool isRecommended;
  final VoidCallback? onChoose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spaceXs),
      child: Card(
        color:
            isRecommended ? AppColors.primaryFixed : theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side:
              isRecommended
                  ? BorderSide(color: theme.colorScheme.primary, width: 2)
                  : isCurrentPlan
                  ? BorderSide(color: theme.colorScheme.primary, width: 2)
                  : BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        elevation: isRecommended ? 1 : 0,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spaceXl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Current Plan / Recommended badge
              if (isCurrentPlan)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.spaceMd,
                    vertical: AppSpacing.spaceXs,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    l10n.subButtonCurrent,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSecondary,
                    ),
                  ),
                )
              else if (isRecommended)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.spaceMd,
                    vertical: AppSpacing.spaceXs,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    l10n.subRecommended,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                )
              else
                const SizedBox(height: 24),
              const SizedBox(height: AppSpacing.spaceSm),

              // Plan name
              Text(planName, style: theme.textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.spaceSm),

              // Price
              Text(
                price,
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                interval,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: AppSpacing.spaceLg),
              Divider(color: theme.colorScheme.outlineVariant),
              const SizedBox(height: AppSpacing.spaceSm),

              // Features
              ...features.map(
                (f) => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.spaceXs,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        f.included ? Icons.check : Icons.close,
                        size: 20,
                        color:
                            f.included
                                ? AppColors.success
                                : theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.spaceSm),
                      Expanded(
                        child: Text(f.text, style: theme.textTheme.bodyMedium),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // CTA button
              SizedBox(
                width: double.infinity,
                child:
                    isCurrentPlan
                        ? OutlinedButton(
                          onPressed: null,
                          child: Text(l10n.subButtonCurrent),
                        )
                        : isRecommended
                        ? ElevatedButton(
                          onPressed: onChoose,
                          child: Text(l10n.subButtonChoose(planName)),
                        )
                        : OutlinedButton(
                          onPressed: onChoose,
                          child: Text(l10n.subButtonChoose(planName)),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChargePackCard extends StatelessWidget {
  const _ChargePackCard({required this.title, required this.price});

  final String title;
  final String price;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // IAP purchase placeholder
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spaceLg),
          child: Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 24,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleSmall),
                    Text(
                      price,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  const _FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ExpansionTile(
      title: Text(question, style: theme.textTheme.titleSmall),
      childrenPadding: const EdgeInsets.fromLTRB(
        AppSpacing.spaceLg,
        0,
        AppSpacing.spaceLg,
        AppSpacing.spaceLg,
      ),
      children: [
        Text(
          answer,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
