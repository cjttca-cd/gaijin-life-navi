import 'package:flutter/material.dart';

import '../../domain/chat_message.dart';
import 'disclaimer_banner.dart';
import 'source_citation.dart';

/// A chat bubble for user or assistant messages.
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    this.isStreaming = false,
  });

  final ChatMessage message;
  final bool isStreaming;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primary,
              child: Icon(
                Icons.smart_toy,
                size: 18,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isUser
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft:
                          isUser ? const Radius.circular(16) : Radius.zero,
                      bottomRight:
                          isUser ? Radius.zero : const Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        message.content.isEmpty && isStreaming
                            ? '...'
                            : message.content,
                        style: TextStyle(
                          color: isUser
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      if (isStreaming && message.content.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: isUser
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Source citations (assistant only).
                if (!isUser &&
                    message.sources != null &&
                    message.sources!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: SourceCitationWidget(sources: message.sources!),
                  ),
                // Disclaimer (assistant only).
                if (!isUser && message.disclaimer != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: DisclaimerBanner(text: message.disclaimer!),
                  ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.secondary,
              child: Icon(
                Icons.person,
                size: 18,
                color: theme.colorScheme.onSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
