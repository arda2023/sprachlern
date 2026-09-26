import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/assets.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/models/text_data.dart';
import 'package:sprachlern/providers/text_provider.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/widgets/text_gap_field.dart';

class TextExerciseScreen extends ConsumerStatefulWidget {
  const TextExerciseScreen({super.key, required this.textId});

  final String textId;

  @override
  ConsumerState<TextExerciseScreen> createState() => _TextExerciseScreenState();
}

class _TextExerciseScreenState extends ConsumerState<TextExerciseScreen> {
  late final TextExerciseData? _data;
  final _controllers = <TextEditingController>[];
  final _focusNodes = <FocusNode>[];

  /// Tapping the accessory bar may take the focus away from the gap, so the
  /// last gap the learner worked in is remembered.
  int? _lastFocusedGap;

  @override
  void initState() {
    super.initState();
    _data = ref.read(textExerciseProvider(widget.textId));

    for (var i = 0; i < (_data?.gaps.length ?? 0); i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(
        FocusNode()..addListener(() {
          if (_focusNodes[i].hasFocus) _lastFocusedGap = i;
        }),
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/texts');
    }
  }

  /// Fills the gap the learner is working in; if that one already shows its
  /// answer, the first gap that does not.
  void _revealAnswer() {
    final gaps = _data!.gaps;
    bool isOpen(int i) => _controllers[i].text != gaps[i].answer;

    final focused = _lastFocusedGap;
    final target = focused != null && isOpen(focused)
        ? focused
        : Iterable<int>.generate(gaps.length)
              .firstWhere(isOpen, orElse: () => -1);
    if (target < 0) return;

    final answer = gaps[target].answer;
    _controllers[target].value = TextEditingValue(
      text: answer,
      selection: TextSelection.collapsed(offset: answer.length),
    );
    _focusNodes[target].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TextExerciseTopBar(
              title: data?.title ?? '',
              currentCard: data?.currentCard ?? 0,
              totalCards: data?.totalCards ?? 0,
              onClose: _close,
            ),
            if (data == null)
              const Expanded(child: _MissingText())
            else ...[
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.pageMargin,
                    AppSpacing.s16,
                    AppSpacing.pageMargin,
                    AppSpacing.s24,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppSpacing.contentWidth,
                      ),
                      child: _ReadingText(
                        data: data,
                        controllers: _controllers,
                        focusNodes: _focusNodes,
                      ),
                    ),
                  ),
                ),
              ),
              _KeyboardAccessoryBar(onReveal: _revealAnswer),
            ],
          ],
        ),
      ),
    );
  }
}

/// Reading text with the gaps set inline, design.md 5.8.
class _ReadingText extends StatelessWidget {
  const _ReadingText({
    required this.data,
    required this.controllers,
    required this.focusNodes,
  });

  final TextExerciseData data;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;

  @override
  Widget build(BuildContext context) {
    final spans = <InlineSpan>[];
    var gapIndex = 0;

    for (final segment in data.segments) {
      switch (segment) {
        case PlainTextSegment(:final text):
          spans.add(TextSpan(text: text));
        case GapSegment(:final baseWord):
          spans.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: TextGapField(
                key: ValueKey('text_gap_$gapIndex'),
                controller: controllers[gapIndex],
                focusNode: focusNodes[gapIndex],
                placeholder: baseWord,
              ),
            ),
          );
          gapIndex++;
      }
    }

    return Text.rich(
      TextSpan(
        style: AppTextStyles.read.copyWith(color: AppColors.white),
        children: spans,
      ),
    );
  }
}

class _MissingText extends StatelessWidget {
  const _MissingText();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sheetMargin),
        child: Text(
          'Dieser Text ist nicht verfügbar.',
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
        ),
      ),
    );
  }
}

/// ✕ left, title centered, lightbulb right, 2 px progress bar below
/// (design.md 5.8). Mirrors the bar of the grammar exercise.
class _TextExerciseTopBar extends StatelessWidget {
  const _TextExerciseTopBar({
    required this.title,
    required this.currentCard,
    required this.totalCards,
    required this.onClose,
  });

  final String title;
  final int currentCard;
  final int totalCards;
  final VoidCallback onClose;

  static const double _barHeight = 44.0;
  static const double _progressHeight = 2.0;

  @override
  Widget build(BuildContext context) {
    final progress = totalCards == 0
        ? 0.0
        : (currentCard / totalCards).clamp(0.0, 1.0).toDouble();

    return SizedBox(
      height: _barHeight + _progressHeight,
      child: Column(
        children: [
          SizedBox(
            height: _barHeight,
            child: Row(
              children: [
                _BarIconButton(
                  key: const ValueKey('text_exercise_close'),
                  icon: FLucideIcons.x,
                  tooltip: 'Übung schließen',
                  onPressed: onClose,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.meta.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                _BarIconButton(
                  icon: FLucideIcons.lightbulb,
                  tooltip: 'Tipp anzeigen',
                  onPressed: _doNothing,
                ),
              ],
            ),
          ),
          // Full width: without it the bar shrinks to the width of its fill.
          SizedBox(
            width: double.infinity,
            height: _progressHeight,
            child: Stack(
              children: [
                const Positioned.fill(
                  child: ColoredBox(color: AppColors.surface),
                ),
                FractionallySizedBox(
                  widthFactor: progress,
                  heightFactor: 1,
                  child: const ColoredBox(color: AppColors.lilac),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Bar directly above the keyboard, design.md 5.8: translate and cycle on the
/// left (inert for now), "Antwort anzeigen" as a flat text button on the right.
class _KeyboardAccessoryBar extends StatelessWidget {
  const _KeyboardAccessoryBar({required this.onReveal});

  final VoidCallback onReveal;

  static const double _height = 48.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ColoredBox(
        color: AppColors.surface,
        child: SizedBox(
          height: _height,
          child: Row(
            children: [
              const SizedBox(width: AppSpacing.s8),
              _BarIconButton(
                icon: FLucideIcons.languages,
                tooltip: 'Übersetzen',
                onPressed: _doNothing,
              ),
              _BarIconButton(
                icon: FLucideIcons.arrowLeftRight,
                tooltip: 'Wechseln',
                onPressed: _doNothing,
              ),
              // Shrinks (ellipsis) instead of overflowing on large system text.
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    key: const ValueKey('text_exercise_reveal'),
                    onPressed: onReveal,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s16,
                      ),
                      minimumSize: const Size(0, _height),
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: Text(
                      'Antwort anzeigen',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarIconButton extends StatelessWidget {
  const _BarIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  static const double _size = 44.0;
  static const double _iconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size,
      height: _size,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: _size, height: _size),
        icon: Icon(icon, size: _iconSize, color: AppColors.white),
      ),
    );
  }
}

void _doNothing() {}
