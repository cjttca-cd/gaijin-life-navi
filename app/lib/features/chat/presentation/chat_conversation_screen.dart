import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/router_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import 'providers/chat_providers.dart';
import 'widgets/message_bubble.dart';
import 'widgets/typing_indicator.dart';
import 'widgets/usage_counter.dart';

/// Chat conversation screen (S08) — Phase 0 synchronous pattern.
///
/// Send → Typing Indicator → Response display.
class ChatConversationScreen extends ConsumerStatefulWidget {
  const ChatConversationScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  ConsumerState<ChatConversationScreen> createState() =>
      _ChatConversationScreenState();
}

class _ChatConversationScreenState
    extends ConsumerState<ChatConversationScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final usage = ref.read(chatUsageProvider);
    if (usage != null && !usage.isUnlimited && usage.remaining <= 0) {
      _showLimitReachedSnackbar();
      return;
    }

    _textController.clear();
    setState(() {}); // Update send button state.

    try {
      final controller = ref.read(chatSendControllerProvider);
      await controller.sendMessage(text);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).genericError)),
        );
      }
    }
  }

  void _showLimitReachedSnackbar() {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.chatLimitExhausted),
        action: SnackBarAction(
          label: l10n.chatLimitUpgrade,
          onPressed: () => context.push(AppRoutes.subscription),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);
    final isLoading = ref.watch(isChatLoadingProvider);
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    ref.listen(chatMessagesProvider, (_, __) {
      _scrollToBottom();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.chatTitle),
        actions: const [
          Padding(padding: EdgeInsets.only(right: 8), child: UsageCounter()),
        ],
      ),
      body: Column(
        children: [
          // Upgrade CTA banner — shown when remaining chats ≤ 1.
          _ChatUpgradeBanner(),

          // Messages list.
          Expanded(
            child:
                messages.isEmpty && !isLoading
                    ? _buildEmptyState(l10n, cs, tt)
                    : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      itemCount: messages.length + (isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == messages.length && isLoading) {
                          return const TypingIndicator();
                        }

                        final message = messages[index];

                        // Determine if we should show avatar (first in group).
                        final showAvatar =
                            index == 0 ||
                            messages[index - 1].isUser != message.isUser;

                        return MessageBubble(
                          message: message,
                          isStreaming: false,
                          showAvatar: showAvatar && message.isAssistant,
                        );
                      },
                    ),
          ),

          // Input bar — §6.3.4.
          Container(
            decoration: BoxDecoration(
              color: cs.surface,
              border: Border(top: BorderSide(color: cs.outlineVariant)),
            ),
            padding: EdgeInsets.only(
              left: AppSpacing.spaceLg,
              right: AppSpacing.spaceLg,
              top: AppSpacing.spaceSm,
              bottom:
                  MediaQuery.of(context).padding.bottom + AppSpacing.spaceSm,
            ),
            child: Row(
              children: [
                // Attach button (disabled Phase 0).
                Opacity(
                  opacity: 0.4,
                  child: Icon(
                    Icons.attach_file,
                    color: cs.onSurfaceVariant,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.spaceSm),
                // Input field.
                Expanded(
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    maxLines: 4,
                    minLines: 1,
                    textInputAction: TextInputAction.newline,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: l10n.chatInputPlaceholder,
                      filled: true,
                      fillColor: AppColors.surfaceVariant,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(999),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(999),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(999),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    enabled: !isLoading,
                  ),
                ),
                const SizedBox(width: AppSpacing.spaceSm),
                // Send button.
                _SendButton(
                  enabled: !isLoading && _textController.text.trim().isNotEmpty,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n, ColorScheme cs, TextTheme tt) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.space3xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: cs.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.spaceLg),
            Text(
              l10n.chatEmptyTitle,
              style: tt.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            Text(
              l10n.chatEmptySubtitle,
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.space2xl),
            // Suggestion chips.
            _SuggestionChip(
              icon: Icons.account_balance,
              iconColor: AppColors.bankingIcon,
              text: l10n.chatSuggestBank,
              onTap: () {
                _textController.text = l10n.chatSuggestBank;
                _sendMessage();
              },
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            _SuggestionChip(
              icon: Icons.badge,
              iconColor: AppColors.visaIcon,
              text: l10n.chatSuggestVisa,
              onTap: () {
                _textController.text = l10n.chatSuggestVisa;
                _sendMessage();
              },
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            _SuggestionChip(
              icon: Icons.local_hospital,
              iconColor: AppColors.medicalIcon,
              text: l10n.chatSuggestMedical,
              onTap: () {
                _textController.text = l10n.chatSuggestMedical;
                _sendMessage();
              },
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            _SuggestionChip(
              icon: Icons.explore,
              iconColor: cs.primary,
              text: l10n.chatSuggestGeneral,
              onTap: () {
                _textController.text = l10n.chatSuggestGeneral;
                _sendMessage();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.enabled, required this.onPressed});

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      width: 40,
      height: 40,
      child: Material(
        color: enabled ? cs.primary : AppColors.surfaceDim,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: enabled ? onPressed : null,
          child: Icon(
            Icons.send,
            size: 20,
            color: enabled ? cs.onPrimary : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// Upgrade banner shown when usage remaining ≤ 1 (excluding unlimited users).
///
/// Per task-041 spec:
///   - colorWarningContainer background
///   - "Upgrade to Premium for unlimited chat"
///   - Tap → /subscription
class _ChatUpgradeBanner extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usage = ref.watch(chatUsageProvider);
    if (usage == null || usage.isUnlimited) return const SizedBox.shrink();
    if (usage.remaining > 1) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final tt = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceLg,
        vertical: AppSpacing.spaceMd,
      ),
      decoration: BoxDecoration(color: AppColors.warningContainer),
      child: Row(
        children: [
          const Icon(Icons.star, size: 20, color: AppColors.onWarningContainer),
          const SizedBox(width: AppSpacing.spaceSm),
          Expanded(
            child: Text(
              l10n.chatUpgradeBanner,
              style: tt.bodySmall?.copyWith(
                color: AppColors.onWarningContainer,
              ),
            ),
          ),
          TextButton(
            onPressed: () => context.push(AppRoutes.subscription),
            child: Text(l10n.chatUpgradeButton),
          ),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: cs.surface,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spaceMd),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: cs.outline),
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: iconColor),
                const SizedBox(width: AppSpacing.spaceMd),
                Expanded(
                  child: Text(
                    text,
                    style: tt.bodyMedium?.copyWith(color: cs.onSurface),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
