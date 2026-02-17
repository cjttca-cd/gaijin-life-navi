import 'package:flutter/material.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/chat_message.dart';

/// Source citation section — handoff-chat.md §3 Source Citation Section.
///
/// Displayed inside AI bubble below the divider.
class SourceCitationWidget extends StatelessWidget {
  const SourceCitationWidget({super.key, required this.sources});

  final List<SourceCitation> sources;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header.
        Text(
          l10n.chatSourcesHeader,
          style: tt.labelSmall?.copyWith(
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.spaceXs),
        // Source rows.
        ...sources.map(
          (source) => InkWell(
            onTap: () => _openUrl(source.url),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Icon(Icons.attach_file, size: 16, color: cs.primary),
                  const SizedBox(width: AppSpacing.spaceXs),
                  Expanded(
                    child: Text(
                      source.title.isNotEmpty ? source.title : source.url,
                      style: tt.bodySmall?.copyWith(color: cs.primary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
