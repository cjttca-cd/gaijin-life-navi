import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// Typing indicator (S08) — DESIGN_SYSTEM.md §6.9.5.
///
/// 3 dots bouncing with 300ms offset, in AI bubble shape.
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceMd,
        vertical: AppSpacing.spaceXs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Avatar.
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: cs.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.explore, size: 16, color: cs.onPrimary),
          ),
          const SizedBox(height: AppSpacing.spaceXs),
          // Bubble with dots.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
                bottomLeft: Radius.circular(2),
              ),
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    final offset = index * 0.25;
                    final t = ((_controller.value + offset) % 1.0);
                    // Bounce: 0→0.5 goes up, 0.5→1.0 goes down.
                    final bounce = t < 0.5 ? t * 2 * 4 : (1 - t) * 2 * 4;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Transform.translate(
                        offset: Offset(0, -bounce),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.onSurfaceVariant,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
