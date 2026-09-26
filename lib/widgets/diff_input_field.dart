import 'package:flutter/material.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

/// The gap of the fill-in card (design.md 5.7). Typed text is plain cyan;
/// feedback appears only after an answer was confirmed — nothing is compared
/// while typing.
class DiffInputField extends StatefulWidget {
  const DiffInputField({
    super.key,
    required this.targetAnswer,
    required this.isWrong,
    required this.attemptCount,
    required this.solutionRevealed,
    required this.isCorrect,
    required this.onChanged,
    this.onSubmitted,
    this.focusNode,
  });

  final String targetAnswer;

  /// The last confirmation was wrong and the input is unchanged since: red
  /// frame plus a partial hint whose length depends on [attemptCount].
  final bool isWrong;

  /// Wrong confirmations on this card so far.
  final int attemptCount;

  /// "Wort erfahren" was tapped: while empty, the gap shows the answer dimmed
  /// in cyan. Nothing turns red — revealing is not shown as an error, even
  /// though the card is scored as not known.
  final bool solutionRevealed;

  /// The answer was confirmed correct: green frame, input locked.
  final bool isCorrect;

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

  // design.md 5.7: the gap and its cursor.
  static const double _minWidth = 100.0;
  static const double _minHeight = 32.0;
  static const double _cursorWidth = 2.0;
  static const double _cursorHeight = 24.0;

  // design.md 3.4: feedback frame, as in the error frame pattern.
  static const double _frameWidth = 2.0;

  /// Hint and revealed answer are dimmed like a disabled element (5.12).
  static const double _dimmedOpacity = 0.4;

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
    final isEmpty = _controller.text.isEmpty;
    final showSolution = isEmpty && widget.solutionRevealed;
    final hint = widget.isWrong
        ? _hintFor(widget.targetAnswer, widget.attemptCount)
        : null;
    // In the gap's own colour the frame is invisible, so switching to red or
    // green does not change the size.
    final frameColor = widget.isWrong
        ? AppColors.error
        : widget.isCorrect
        ? AppColors.success
        : AppColors.field;

    return Container(
      key: const ValueKey('diff_input_frame'),
      constraints: const BoxConstraints(
        minWidth: _minWidth,
        minHeight: _minHeight,
      ),
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(AppSpacing.radiusBadge),
        border: Border.all(color: frameColor, width: _frameWidth),
      ),
      child: IntrinsicWidth(
        child: Row(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  TextField(
                    key: const ValueKey('diff_input_text_field'),
                    controller: _controller,
                    focusNode: _focusNode,
                    readOnly: widget.isCorrect,
                    onChanged: (value) {
                      setState(() {});
                      widget.onChanged(value);
                    },
                    onSubmitted: widget.onSubmitted,
                    textInputAction: TextInputAction.done,
                    maxLines: 1,
                    cursorColor: AppColors.cyan,
                    cursorHeight: _cursorHeight,
                    style: AppTextStyles.sentence,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.s8,
                      ),
                      isDense: true,
                    ),
                  ),
                  if (showSolution)
                    // Not positioned: the revealed word sizes the gap.
                    IgnorePointer(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s8,
                        ),
                        child: Text(
                          widget.targetAnswer,
                          key: const ValueKey('diff_input_solution'),
                          maxLines: 1,
                          style: AppTextStyles.sentence.copyWith(
                            color: AppColors.cyan.withValues(
                              alpha: _dimmedOpacity,
                            ),
                          ),
                        ),
                      ),
                    )
                  else if (isEmpty)
                    const Positioned(
                      left: AppSpacing.s8,
                      child: IgnorePointer(
                        child: SizedBox(
                          key: ValueKey('diff_input_cursor'),
                          width: _cursorWidth,
                          height: _cursorHeight,
                          child: ColoredBox(color: AppColors.cyan),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (hint != null)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.s8),
                child: Text(
                  hint,
                  key: const ValueKey('diff_input_hint'),
                  maxLines: 1,
                  style: AppTextStyles.sentence.copyWith(
                    color: AppColors.error.withValues(alpha: _dimmedOpacity),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// The first two characters after the first miss ("Fr..." for "Fruit"), just
/// one for answers shorter than three; from the second miss the whole answer.
String _hintFor(String answer, int attemptCount) {
  if (attemptCount >= 2) return answer;
  final characters = answer.characters;
  return '${characters.take(characters.length >= 3 ? 2 : 1)}...';
}
