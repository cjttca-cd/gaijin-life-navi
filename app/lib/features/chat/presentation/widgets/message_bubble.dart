import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

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
