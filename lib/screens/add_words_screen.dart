import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/assets.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/providers/custom_stack_provider.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/widgets/input_mode_toggle.dart';

class AddWordsScreen extends ConsumerStatefulWidget {
  const AddWordsScreen({super.key});

  @override
  ConsumerState<AddWordsScreen> createState() => _AddWordsScreenState();
}

class _AddWordsScreenState extends ConsumerState<AddWordsScreen> {
  final _controller = TextEditingController();
  InputMode _mode = InputMode.words;

  /// True from the tap until the cards are stored or the save failed. Every
  /// entry costs an Edge Function call, so saving takes noticeable time.
  bool _saving = false;
  String? _error;

  static const double _topBarHeight = 44.0;
  static const double _topBarIconSize = 24.0;
  static const double _disabledOpacity = 0.4;
  static const int _fieldLines = 6;

  bool get _canSubmit => !_saving && _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onTextChanged)
      ..dispose();
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  Future<void> _submit() async {
    // Set before the first await, so a second tap cannot start another save
    // and store the same cards twice.
    setState(() {
      _saving = true;
      _error = null;
    });

    final raw = _controller.text;
    final notifier = ref.read(customStackProvider.notifier);

    try {
      if (_mode == InputMode.words) {
        await notifier.addFromWords(raw);
      } else {
        await notifier.addFromText(raw);
      }
    } on Exception {
      // Nothing was stored (generation fails as a whole before the insert),
      // so the input stays for a retry.
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error =
            'Die Karten konnten nicht erstellt werden. Bitte versuche es '
            'erneut.';
      });
      return;
    }

    if (!mounted) return;
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/custom-stack');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWords = _mode == InputMode.words;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(onSubmit: _canSubmit ? _submit : null, saving: _saving),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageMargin,
                AppSpacing.s16,
                AppSpacing.pageMargin,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InputModeToggle(
                    mode: _mode,
                    onChanged: (mode) {
                      if (!_saving) setState(() => _mode = mode);
                    },
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  Text(
                    isWords ? 'Wörter' : 'Text',
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    isWords
                        ? 'Gebe die Wörter ein, die du lernen möchtest.'
                        : 'Wörter von einem Textstück hinzufügen.',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  TextField(
                    key: const ValueKey('add_words_field'),
                    controller: _controller,
                    enabled: !_saving,
                    maxLines: _fieldLines,
                    cursorColor: AppColors.lilac,
                    style: AppTextStyles.body.copyWith(color: AppColors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.surface,
                      hintText: isWords
                          ? 'Wörter hier eintippen …'
                          : 'Text hier tippen oder einsetzen …',
                      hintStyle: AppTextStyles.body.copyWith(
                        color: AppColors.textMuted,
                      ),
                      contentPadding: const EdgeInsets.all(
                        AppSpacing.cardPadding,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusSmall,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusSmall,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusSmall,
                        ),
                        borderSide: const BorderSide(
                          color: AppColors.lilac,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    'Trenne mehrere Einträge mit einem Semikolon.',
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: AppSpacing.s16),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        _error!,
                        key: const ValueKey('add_words_error'),
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onSubmit, required this.saving});

  /// `null` disables the action — design.md 5.12: 40 % opacity when disabled.
  final Future<void> Function()? onSubmit;

  /// Shows a spinner in place of the link while the cards are being saved.
  final bool saving;

  static const double _spinnerStroke = 2.0;

  @override
  Widget build(BuildContext context) {
    const size = _AddWordsScreenState._topBarHeight;
    final enabled = onSubmit != null;

    return SizedBox(
      height: size,
      child: Row(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: IconButton(
              tooltip: 'Schließen',
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/custom-stack');
                }
              },
              padding: EdgeInsets.zero,
              icon: const Icon(
                FLucideIcons.x,
                size: _AddWordsScreenState._topBarIconSize,
                color: AppColors.white,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Wörter hinzufügen',
                style: AppTextStyles.navTitle.copyWith(color: AppColors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.pageMargin),
            child: Opacity(
              // Saving is busy, not unavailable: no dimming.
              opacity: enabled || saving
                  ? 1.0
                  : _AddWordsScreenState._disabledOpacity,
              child: GestureDetector(
                key: const ValueKey('add_words_submit'),
                onTap: enabled ? () => onSubmit!() : null,
                behavior: HitTestBehavior.opaque,
                // The hidden link keeps its width, so the title does not shift.
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Visibility(
                      visible: !saving,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: Text(
                        'Hinzufügen',
                        style: AppTextStyles.title.copyWith(
                          color: AppColors.lilac,
                        ),
                      ),
                    ),
                    if (saving)
                      Semantics(
                        label: 'Wird gespeichert',
                        child: const SizedBox.square(
                          key: ValueKey('add_words_saving'),
                          dimension: _AddWordsScreenState._topBarIconSize,
                          child: CircularProgressIndicator(
                            strokeWidth: _spinnerStroke,
                            color: AppColors.lilac,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
