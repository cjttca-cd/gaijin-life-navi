import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Disclaimer text — shown OUTSIDE the AI bubble per handoff-chat.md.
///
/// labelSmall (11sp), colorOnSurfaceVariant, with warning icon.
class DisclaimerBanner extends StatelessWidget {
  const DisclaimerBanner({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.warning_amber,
          size: 14,
          color: AppColors.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: tt.labelSmall?.copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
