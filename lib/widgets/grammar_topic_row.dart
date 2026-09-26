import 'package:flutter/material.dart';
import 'package:forui/assets.dart';
import 'package:sprachlern/models/grammar_topic_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

/// "Grammatik-Zeile" per design.md 5.10: flat on `--bg` without an enclosing
/// card — title, task, meta line and a chevron on the right.
class GrammarTopicRow extends StatelessWidget {
  const GrammarTopicRow({super.key, required this.topic, this.onTap});

  final GrammarTopicData topic;
  final VoidCallback? onTap;

  static const double _chevronSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        key: ValueKey('grammar_topic_${topic.id}'),
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title,
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      topic.taskDescription,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      topic.metaLabel,
                      style: AppTextStyles.meta.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              const Icon(
                FLucideIcons.chevronRight,
                size: _chevronSize,
                color: AppColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
