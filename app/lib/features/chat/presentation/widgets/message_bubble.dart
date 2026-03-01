import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../../core/providers/router_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/chat_message.dart';
import 'disclaimer_banner.dart';
import 'source_citation.dart';
import 'tracker_item_card.dart';

/// Chat bubble — handoff-chat.md §3 (User & AI bubbles).
///
/// User: [colorPrimary] bg, right-aligned, max 75% width.
/// AI: [colorSurfaceVariant] bg, left-aligned, max 85% width, markdown.
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    this.isStreaming = false,
    this.showAvatar = true,
  });

  final ChatMessage message;
  final bool isStreaming;
  final bool showAvatar;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return isUser
        ? _UserBubble(message: message)
        : _AiBubble(
          message: message,
          isStreaming: isStreaming,
          showAvatar: showAvatar,
        );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.spaceMd,
        right: AppSpacing.spaceMd,
        bottom: AppSpacing.spaceXs,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onLongPress: () => _copyToClipboard(context, message.content),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: screenWidth * 0.75),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Show image thumbnail if the user attached one.
                  if (message.imageBase64 != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.memory(
                        base64Decode(message.imageBase64!),
                        width: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.broken_image,
                          size: 48,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                    if (message.content.isNotEmpty)
                      const SizedBox(height: 6),
                  ],
                  if (message.content.isNotEmpty)
                    Text(
                      message.content,
                      style: tt.bodyLarge?.copyWith(color: cs.onPrimary),
                    ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTime(message.createdAt),
                    style: tt.labelSmall?.copyWith(
                      color: cs.onPrimary.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AiBubble extends StatelessWidget {
  const _AiBubble({
    required this.message,
    this.isStreaming = false,
    this.showAvatar = true,
  });

  final ChatMessage message;
  final bool isStreaming;
  final bool showAvatar;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.spaceMd,
        right: AppSpacing.spaceMd,
        bottom: AppSpacing.spaceXs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Avatar — 28dp.
          if (showAvatar)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.spaceXs),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: cs.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.explore, size: 16, color: cs.onPrimary),
              ),
            ),

          // Bubble.
          GestureDetector(
            onLongPress: () => _copyToClipboard(context, message.content),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screenWidth * 0.85),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Depth level indicator chip.
                    if (message.depthLevel != null) ...[
                      _DepthLevelChip(depthLevel: message.depthLevel!),
                      const SizedBox(height: 4),
                    ],

                    // Markdown-rendered content.
                    if (message.content.isNotEmpty)
                      MarkdownBody(
                        data: message.content,
                        selectable: true,
                        styleSheet: _markdownStyleSheet(context),
                      )
                    else if (isStreaming)
                      Text('...', style: tt.bodyLarge),

                    // Sources section.
                    if (message.sources != null &&
                        message.sources!.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(height: 1),
                      ),
                      SourceCitationWidget(sources: message.sources!),
                    ],

                    // Tracker items section.
                    if (message.trackerItems != null &&
                        message.trackerItems!.isNotEmpty)
                      TrackerItemCards(items: message.trackerItems!),

                    // Summary-level upgrade CTA.
                    if (message.depthLevel == 'summary') ...[
                      const SizedBox(height: 8),
                      _SummaryUpgradeCta(),
                    ],

                    // Timestamp.
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        _formatTime(message.createdAt),
                        style: tt.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // TODO(analytics): chat_feedback — フィードバックボタン未実装。
          // ここに thumbs-up/down ボタンを配置し、押下時に以下を呼ぶ:
          //   ref.read(analyticsServiceProvider).logChatFeedback(
          //     domain: message.domain ?? 'concierge',
          //     rating: 'good' or 'bad',
          //     sessionId: <current_session_id>,
          //   );

          // Disclaimer — outside bubble.
          if (message.disclaimer != null)
            Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.spaceXs,
                left: AppSpacing.spaceMd,
              ),
              child: DisclaimerBanner(text: message.disclaimer!),
            )
          else if (message.isAssistant && message.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.spaceXs,
                left: AppSpacing.spaceMd,
              ),
              child: DisclaimerBanner(text: l10n.chatDisclaimer),
            ),
        ],
      ),
    );
  }

  MarkdownStyleSheet _markdownStyleSheet(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return MarkdownStyleSheet(
      p: tt.bodyLarge?.copyWith(color: cs.onSurface),
      h1: tt.titleMedium?.copyWith(color: cs.onSurface),
      h2: tt.titleSmall?.copyWith(color: cs.onSurface),
      strong: const TextStyle(fontWeight: FontWeight.w600),
      listBullet: tt.bodyMedium?.copyWith(color: cs.primary),
      code: tt.bodySmall?.copyWith(
        fontFamily: 'monospace',
        backgroundColor: AppColors.surfaceDim,
      ),
      codeblockDecoration: BoxDecoration(
        color: AppColors.surfaceDim,
        borderRadius: BorderRadius.circular(4),
      ),
      codeblockPadding: const EdgeInsets.all(8),
      blockquoteDecoration: BoxDecoration(
        color: AppColors.primaryFixed,
        border: Border(left: BorderSide(color: cs.primary, width: 3)),
      ),
      blockquotePadding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
      a: TextStyle(color: cs.primary, decoration: TextDecoration.underline),
    );
  }
}

/// Small chip indicating depth level (deep / summary) at top of AI bubble.
class _DepthLevelChip extends StatelessWidget {
  const _DepthLevelChip({required this.depthLevel});

  final String depthLevel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final isSummary = depthLevel == 'summary';
    final label =
        isSummary ? l10n.chatDepthLevelSummary : l10n.chatDepthLevelDeep;
    final icon = isSummary ? Icons.summarize_outlined : Icons.psychology;
    final bgColor =
        isSummary
            ? AppColors.warningContainer
            : cs.primaryContainer;
    final fgColor =
        isSummary
            ? AppColors.onWarningContainer
            : cs.onPrimaryContainer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fgColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: tt.labelSmall?.copyWith(
              color: fgColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// CTA shown inside summary-level AI bubbles to encourage upgrade.
class _SummaryUpgradeCta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => context.push(AppRoutes.subscription),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: cs.primaryContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('💡 ', style: TextStyle(fontSize: 14)),
            Flexible(
              child: Text(
                l10n.chatSummaryUpgradeCta,
                style: tt.labelSmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatTime(DateTime dt) {
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

void _copyToClipboard(BuildContext context, String text) {
  Clipboard.setData(ClipboardData(text: text));
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Copied'), duration: Duration(seconds: 2)),
  );
}
