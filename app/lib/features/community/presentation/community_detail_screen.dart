import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/router_provider.dart';
import '../../common/upgrade_banner.dart';
import '../../subscription/presentation/providers/subscription_providers.dart';
import '../domain/community_post.dart';
import '../domain/community_reply.dart';
import 'providers/community_providers.dart';

/// Community post detail screen — post body, replies, voting, best answer.
class CommunityDetailScreen extends ConsumerStatefulWidget {
  const CommunityDetailScreen({super.key, required this.postId});

  final String postId;

  @override
  ConsumerState<CommunityDetailScreen> createState() =>
      _CommunityDetailScreenState();
}

class _CommunityDetailScreenState
    extends ConsumerState<CommunityDetailScreen> {
  final _replyController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final postAsync = ref.watch(communityPostDetailProvider(widget.postId));
    final repliesAsync = ref.watch(communityRepliesProvider(widget.postId));
    final isPremium = ref.watch(isPremiumProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.communityDetailTitle),
      ),
      body: postAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline,
                  size: 48, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text(l10n.genericError),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () => ref.invalidate(
                    communityPostDetailProvider(widget.postId)),
                child: Text(l10n.chatRetry),
              ),
            ],
          ),
        ),
        data: (post) {
          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(
                        communityPostDetailProvider(widget.postId));
                    ref.invalidate(
                        communityRepliesProvider(widget.postId));
                  },
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Post header
                      _PostHeader(post: post),
                      const SizedBox(height: 16),

                      // Post content
                      Text(
                        post.content,
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),

                      // Vote bar
                      _VoteBar(post: post),

                      const Divider(height: 32),

                      // Replies header
                      Text(
                        l10n.communityReplies(post.replyCount),
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),

                      // Replies list
                      repliesAsync.when(
                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (_, __) => Center(
                          child: Text(l10n.genericError),
                        ),
                        data: (replies) {
                          if (replies.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Text(
                                  l10n.communityNoReplies,
                                  style: theme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: theme
                                        .colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            );
                          }
                          return Column(
                            children: replies.map((reply) {
                              return _ReplyCard(
                                reply: reply,
                                isPostAuthor:
                                    post.userId == reply.userId,
                                postUserId: post.userId,
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Reply input (Premium) or upgrade banner (Free)
              if (isPremium)
                _ReplyInput(
                  controller: _replyController,
                  isSubmitting: _isSubmitting,
                  onSubmit: () => _submitReply(context),
                )
              else
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: UpgradeBanner(
                    message: l10n.communityReplyPremiumOnly,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _submitReply(BuildContext context) async {
    final content = _replyController.text.trim();
    if (content.isEmpty || content.length < 5) return;

    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _isSubmitting = true);

    try {
      final repo = ref.read(communityRepositoryProvider);
      final reply = await repo.createReply(
        postId: widget.postId,
        content: content,
      );

      ref
          .read(communityRepliesProvider(widget.postId).notifier)
          .addReply(reply);
      _replyController.clear();

      // Refresh post to update reply count
      ref.invalidate(communityPostDetailProvider(widget.postId));
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.genericError)),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}

// ─── Post Header ─────────────────────────────────────────────

class _PostHeader extends StatelessWidget {
  const _PostHeader({required this.post});

  final CommunityPost post;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Moderation badge
        if (post.moderationStatus != ModerationStatus.approved)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: post.moderationStatus == ModerationStatus.pending
                  ? theme.colorScheme.tertiaryContainer
                  : theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              post.moderationStatus == ModerationStatus.pending
                  ? l10n.communityModerationPending
                  : l10n.communityModerationFlagged,
              style: theme.textTheme.labelSmall?.copyWith(
                color: post.moderationStatus == ModerationStatus.pending
                    ? theme.colorScheme.onTertiaryContainer
                    : theme.colorScheme.onErrorContainer,
              ),
            ),
          ),

        // Category + Answered badge
        Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                post.category,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (post.isAnswered)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle,
                        size: 14,
                        color: theme.colorScheme.onTertiaryContainer),
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
        const SizedBox(height: 12),

        // Title
        Text(
          post.title,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),

        // Meta
        Row(
          children: [
            Icon(Icons.visibility_outlined,
                size: 14, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 4),
            Text(
              '${post.viewCount}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 12),
            if (post.createdAt != null)
              Text(
                _formatDate(post.createdAt!),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }
}

// ─── Vote Bar ────────────────────────────────────────────────

class _VoteBar extends ConsumerWidget {
  const _VoteBar({required this.post});

  final CommunityPost post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isPremium = ref.watch(isPremiumProvider);

    return Row(
      children: [
        // Upvote button
        IconButton.filledTonal(
          onPressed: () {
            if (isPremium) {
              _vote(ref);
            } else {
              context.push(AppRoutes.subscription);
            }
          },
          icon: Icon(
            post.userVoted ? Icons.thumb_up : Icons.thumb_up_outlined,
            color: post.userVoted ? theme.colorScheme.primary : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          l10n.communityVoteCount(post.upvoteCount),
          style: theme.textTheme.bodyMedium,
        ),
        if (!isPremium) ...[
          const SizedBox(width: 8),
          Icon(Icons.lock_outline,
              size: 14, color: theme.colorScheme.onSurfaceVariant),
        ],
      ],
    );
  }

  Future<void> _vote(WidgetRef ref) async {
    try {
      final repo = ref.read(communityRepositoryProvider);
      await repo.votePost(post.id);
      ref.invalidate(communityPostDetailProvider(post.id));
    } catch (_) {
      // Silently fail — UI will refresh on next load
    }
  }
}

// ─── Reply Card ──────────────────────────────────────────────

class _ReplyCard extends ConsumerWidget {
  const _ReplyCard({
    required this.reply,
    required this.isPostAuthor,
    required this.postUserId,
  });

  final CommunityReply reply;
  final bool isPostAuthor;
  final String postUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isPremium = ref.watch(isPremiumProvider);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: reply.isBestAnswer
          ? theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3)
          : null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Best answer badge
            if (reply.isBestAnswer)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle,
                        size: 14, color: theme.colorScheme.onTertiary),
                    const SizedBox(width: 4),
                    Text(
                      l10n.communityBestAnswer,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onTertiary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            // Moderation badge
            if (reply.moderationStatus != ModerationStatus.approved)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: reply.moderationStatus == ModerationStatus.pending
                      ? theme.colorScheme.tertiaryContainer
                      : theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  reply.moderationStatus == ModerationStatus.pending
                      ? l10n.communityModerationPending
                      : l10n.communityModerationFlagged,
                  style: theme.textTheme.labelSmall,
                ),
              ),

            // Content
            Text(
              reply.content,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),

            // Actions row
            Row(
              children: [
                // Vote
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    if (isPremium) {
                      _voteReply(ref);
                    } else {
                      context.push(AppRoutes.subscription);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          reply.userVoted
                              ? Icons.thumb_up
                              : Icons.thumb_up_outlined,
                          size: 16,
                          color: reply.userVoted
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${reply.upvoteCount}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Timestamp
                if (reply.createdAt != null)
                  Text(
                    _formatDate(reply.createdAt!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _voteReply(WidgetRef ref) async {
    try {
      final repo = ref.read(communityRepositoryProvider);
      await repo.voteReply(reply.id);
      ref.invalidate(communityRepliesProvider(reply.postId));
    } catch (_) {
      // Silently fail
    }
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }
}

// ─── Reply Input ─────────────────────────────────────────────

class _ReplyInput extends StatelessWidget {
  const _ReplyInput({
    required this.controller,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: l10n.communityReplyHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  isDense: true,
                ),
                maxLines: 3,
                minLines: 1,
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: isSubmitting ? null : onSubmit,
              icon: isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
