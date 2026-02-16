import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import 'providers/community_providers.dart';

/// Community post creation screen — Premium only.
class CommunityCreateScreen extends ConsumerStatefulWidget {
  const CommunityCreateScreen({super.key});

  @override
  ConsumerState<CommunityCreateScreen> createState() =>
      _CommunityCreateScreenState();
}

class _CommunityCreateScreenState
    extends ConsumerState<CommunityCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedChannel = 'en';
  String _selectedCategory = 'visa';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final categoryLabels = {
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.communityNewPost),
        actions: [
          FilledButton(
            onPressed: _isSubmitting ? null : _submit,
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.communitySubmit),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Channel selector
              Text(
                l10n.communityChannelLabel,
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _channelChip('en', 'English'),
                  _channelChip('zh', '中文'),
                  _channelChip('vi', 'Tiếng Việt'),
                  _channelChip('ko', '한국어'),
                  _channelChip('pt', 'Português'),
                ],
              ),
              const SizedBox(height: 16),

              // Category dropdown
              Text(
                l10n.communityCategoryLabel,
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: categoryLabels.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Title
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: l10n.communityTitleLabel,
                  hintText: l10n.communityTitleHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLength: 200,
                validator: (value) {
                  if (value == null || value.trim().length < 5) {
                    return l10n.communityTitleMinLength;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Content
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: l10n.communityContentLabel,
                  hintText: l10n.communityContentHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignLabelWithHint: true,
                ),
                maxLines: 10,
                minLines: 5,
                maxLength: 5000,
                validator: (value) {
                  if (value == null || value.trim().length < 10) {
                    return l10n.communityContentMinLength;
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Moderation notice
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 20,
                        color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.communityModerationNotice,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _channelChip(String value, String label) {
    final isSelected = _selectedChannel == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() => _selectedChannel = value);
      },
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final repo = ref.read(communityRepositoryProvider);
      await repo.createPost(
        channel: _selectedChannel,
        category: _selectedCategory,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
      );

      // Refresh the post list
      ref.invalidate(communityPostsProvider);

      if (mounted) {
        context.pop();
      }
    } catch (_) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.genericError)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
