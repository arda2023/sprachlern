import 'package:flutter/material.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

/// A keyboard input that reveals aligned feedback after a failed attempt.
class DiffInputField extends StatefulWidget {
  const DiffInputField({
    super.key,
    required this.targetAnswer,
    required this.attemptFailed,
    required this.onChanged,
    this.onSubmitted,
    this.focusNode,
  });

  final String targetAnswer;
  final bool attemptFailed;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;

  @override
  State<DiffInputField> createState() => _DiffInputFieldState();
}

class _DiffInputFieldState extends State<DiffInputField> {
  late final TextEditingController _controller;
  late FocusNode _focusNode;
  late bool _ownsFocusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _setFocusNode(widget.focusNode);
  }

  void _setFocusNode(FocusNode? focusNode) {
    _ownsFocusNode = focusNode == null;
    _focusNode = focusNode ?? FocusNode();
  }

  @override
  void didUpdateWidget(covariant DiffInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      if (_ownsFocusNode) _focusNode.dispose();
      _setFocusNode(widget.focusNode);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 100, minHeight: 32),
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(AppSpacing.radiusBadge),
      ),
      child: IntrinsicWidth(
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            TextField(
              key: const ValueKey('diff_input_text_field'),
              controller: _controller,
              focusNode: _focusNode,
              onChanged: (value) {
                setState(() {});
                widget.onChanged(value);
              },
              onSubmitted: widget.onSubmitted,
              textInputAction: TextInputAction.done,
              maxLines: 1,
              cursorColor: AppColors.cyan,
              cursorHeight: 24,
              style: AppTextStyles.sentence.copyWith(
                color: AppColors.cyan.withValues(alpha: 0),
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.s8,
                  vertical: 0,
                ),
                isDense: true,
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: _controller.text.isEmpty
                    ? const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: AppSpacing.s8),
                          child: SizedBox(
                            key: ValueKey('diff_input_cursor'),
                            width: 2,
                            height: 24,
                            child: ColoredBox(color: AppColors.cyan),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s8,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            key: const ValueKey('diff_input_overlay'),
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                            text: _diffText(
                              _controller.text,
                              widget.targetAnswer,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextSpan _diffText(String input, String target) {
    if (input.isEmpty) return const TextSpan(text: '');

    if (!widget.attemptFailed) return _plainInput(input);

    final entered = input.runes.map(String.fromCharCode).toList();
    final answer = target.runes.map(String.fromCharCode).toList();
    final alignment = _align(entered, answer);
    if (alignment.distance == 0 ||
        (alignment.distance == 1 &&
            alignment.insertions == 1 &&
            alignment.substitutions == 0 &&
            alignment.missingAnswer.isEmpty)) {
      return _plainInput(input);
    }

    final spans = <InlineSpan>[];
    for (var i = 0; i < entered.length; i++) {
      spans.add(
        TextSpan(
          text: entered[i],
          style: AppTextStyles.sentence.copyWith(
            color: alignment.matches[i] ? AppColors.cyan : AppColors.error,
          ),
        ),
      );
    }

    // Incomplete matching input needs only the missing characters. Conflicting
    // input gets the full solution, as in the reference's substitution example.
    final hint = alignment.matches.every((match) => match)
        ? alignment.missingAnswer.join()
        : target;
    if (hint.isNotEmpty) {
      spans.add(
        TextSpan(
          text: hint,
          style: AppTextStyles.sentence.copyWith(
            color: AppColors.cyan.withValues(alpha: 0.4),
          ),
        ),
      );
    }
    return TextSpan(children: spans);
  }

  TextSpan _plainInput(String input) => TextSpan(
    text: input,
    style: AppTextStyles.sentence.copyWith(color: AppColors.cyan),
  );
}

class _Alignment {
  const _Alignment({
    required this.distance,
    required this.matches,
    required this.insertions,
    required this.substitutions,
    required this.missingAnswer,
  });

  final int distance;
  final List<bool> matches;
  final int insertions;
  final int substitutions;
  final List<String> missingAnswer;
}

_Alignment _align(List<String> entered, List<String> answer) {
  final inputLower = entered.map((char) => char.toLowerCase()).toList();
  final answerLower = answer.map((char) => char.toLowerCase()).toList();
  final distances = List.generate(
    entered.length + 1,
    (_) => List.filled(answer.length + 1, 0),
  );
  for (var i = entered.length; i >= 0; i--) {
    for (var j = answer.length; j >= 0; j--) {
      if (i == entered.length) {
        distances[i][j] = answer.length - j;
      } else if (j == answer.length) {
        distances[i][j] = entered.length - i;
      } else {
        final diagonal =
            distances[i + 1][j + 1] + (inputLower[i] == answerLower[j] ? 0 : 1);
        final insertion = distances[i + 1][j] + 1;
        final deletion = distances[i][j + 1] + 1;
        distances[i][j] = [
          diagonal,
          insertion,
          deletion,
        ].reduce((a, b) => a < b ? a : b);
      }
    }
  }

  final matches = List.filled(entered.length, false);
  final missingAnswer = <String>[];
  var insertions = 0;
  var substitutions = 0;
  var i = 0;
  var j = 0;
  // Recover an optimal path through the suffix-distance matrix. Prefer early
  // matches so repeated trailing characters are marked as extra characters.
  while (i < entered.length || j < answer.length) {
    if (i < entered.length &&
        j < answer.length &&
        inputLower[i] == answerLower[j] &&
        distances[i][j] == distances[i + 1][j + 1]) {
      matches[i] = true;
      i++;
      j++;
    } else if (i < entered.length &&
        j < answer.length &&
        distances[i][j] == distances[i + 1][j + 1] + 1) {
      substitutions++;
      missingAnswer.add(answer[j]);
      i++;
      j++;
    } else if (i < entered.length &&
        distances[i][j] == distances[i + 1][j] + 1) {
      insertions++;
      i++;
    } else {
      missingAnswer.add(answer[j]);
      j++;
    }
  }
  return _Alignment(
    distance: distances[0][0],
    matches: matches,
    insertions: insertions,
    substitutions: substitutions,
    missingAnswer: missingAnswer,
  );
}
