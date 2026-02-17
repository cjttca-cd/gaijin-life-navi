import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/router_provider.dart';
import '../../subscription/presentation/providers/subscription_providers.dart';
import '../domain/community_post.dart';
import 'providers/community_providers.dart';

/// Community Q&A post list screen with channel/category filters.
class CommunityListScreen extends ConsumerWidget {
  const CommunityListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final posts = ref.watch(communityPostsProvider);
    final channel = ref.watch(communityChannelProvider);
    final category = ref.watch(communityCategoryProvider);
    final sort = ref.watch(communitySortProvider);
    final isPremium = ref.watch(isPremiumProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.communityTitle),
        actions: [
          // Sort toggle
          IconButton(
            icon: Icon(sort == 'newest' ? Icons.schedule : Icons.trending_up),
            tooltip:
                sort == 'newest'
                    ? l10n.communitySortPopular
                    : l10n.communitySortNewest,
            onPressed: () {
              ref.read(communitySortProvider.notifier).state =
                  sort == 'newest' ? 'popular' : 'newest';
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (isPremium) {
            context.push(AppRoutes.communityNew);
          } else {
            context.push(AppRoutes.subscription);
          }
        },
        icon: Icon(isPremium ? Icons.edit : Icons.lock_outline),
        label: Text(l10n.communityNewPost),
      ),
      body: Column(
        children: [
          // Channel selector (language tabs)
          _ChannelSelector(
            selected: channel,
            onChanged:
                (value) =>
                    ref.read(communityChannelProvider.notifier).state = value,
          ),

          // Category filter chips
          _CategoryFilter(
            selected: category,
            onChanged:
                (value) =>
                    ref.read(communityCategoryProvider.notifier).state = value,
          ),

          // Post list
          Expanded(
            child: posts.when(
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
                              () => ref.invalidate(communityPostsProvider),
                          child: Text(l10n.chatRetry),
                        ),
                      ],
                    ),
                  ),
              data: (postList) {
                if (postList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.forum_outlined,
                          size: 64,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.communityEmpty,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh:
                      () => ref.read(communityPostsProvider.notifier).refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: postList.length,
                    itemBuilder: (context, index) {
                      return _PostCard(post: postList[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Channel Selector ────────────────────────────────────────

class _ChannelSelector extends StatelessWidget {
  const _ChannelSelector({required this.selected, required this.onChanged});

  final String selected;
  final ValueChanged<String> onChanged;

  static const _channels = ['en', 'zh', 'vi', 'ko', 'pt'];
  static const _channelLabels = {
    'en': 'English',
    'zh': '中文',
    'vi': 'Tiếng Việt',
    'ko': '한국어',
    'pt': 'Português',
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children:
            _channels.map((ch) {
              final isSelected = ch == selected;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(_channelLabels[ch] ?? ch),
                  selected: isSelected,
                  onSelected: (_) => onChanged(ch),
                ),
              );
            }).toList(),
      ),
    );
  }
}

// ─── Category Filter ─────────────────────────────────────────

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({required this.selected, required this.onChanged});

  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final categoryLabels = {
      null: l10n.communityFilterAll,
      'visa': l10n.communityCategoryVisa,
      'housing': l10n.communityCategoryHousing,
      'banking': l10n.communityCategoryBanking,
      'work': l10n.communityCategoryWork,
      'daily_life': l10n.communityCategoryDailyLife,
      'medical': l10n.communityCategoryMedical,
      'education': l10n.communityCategoryEducation,
      'tax': l10n.communityCategoryTax,
      'other': l10n.communityCategoryOther,
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children:
            categoryLabels.entries.map((entry) {
              final isSelected = entry.key == selected;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(entry.value),
                  selected: isSelected,
                  onSelected: (_) => onChanged(entry.key),
                ),
              );
            }).toList(),
      ),
    );
  }
}

// ─── Post Card ───────────────────────────────────────────────

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});

  final CommunityPost post;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap:
            () => context.push(
              AppRoutes.communityDetail.replaceFirst(':id', post.id),
            ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Moderation status badge (if pending/flagged)
              if (post.moderationStatus != ModerationStatus.approved)
                _ModerationBadge(status: post.moderationStatus),

              // Category chip + answered badge
              Row(
                children: [
                  _CategoryChip(category: post.category),
                  const SizedBox(width: 8),
                  if (post.isAnswered)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 14,
                            color: theme.colorScheme.onTertiaryContainer,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.communityAnswered,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onTertiaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                post.title,
                style: theme.textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Content preview
              Text(
                post.content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Stats row
              Row(
                children: [
                  Icon(
                    Icons.thumb_up_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${post.upvoteCount}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.comment_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${post.replyCount}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.visibility_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${post.viewCount}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  if (post.createdAt != null)
                    Text(
                      _timeAgo(post.createdAt!, l10n),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _timeAgo(DateTime dateTime, AppLocalizations l10n) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) {
      return l10n.communityTimeAgoDays(diff.inDays);
    } else if (diff.inHours > 0) {
      return l10n.communityTimeAgoHours(diff.inHours);
    } else {
      return l10n.communityTimeAgoMinutes(diff.inMinutes);
    }
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _ModerationBadge extends StatelessWidget {
  const _ModerationBadge({required this.status});

  final ModerationStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final isPending = status == ModerationStatus.pending;
    final color =
        isPending
            ? theme.colorScheme.tertiaryContainer
            : theme.colorScheme.errorContainer;
    final textColor =
        isPending
            ? theme.colorScheme.onTertiaryContainer
            : theme.colorScheme.onErrorContainer;
    final label =
        isPending
            ? l10n.communityModerationPending
            : l10n.communityModerationFlagged;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPending ? Icons.hourglass_empty : Icons.flag,
            size: 14,
            color: textColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
