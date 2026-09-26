import 'package:flutter/material.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The email/password form shared by login and registration: title
/// (`display`), two fields, a primary button (design.md 5.12) with a loading
/// state, an error or info line below it, and a text link to the other screen.
class AuthForm extends StatefulWidget {
  const AuthForm({
    super.key,
    required this.title,
    required this.submitLabel,
    required this.onSubmit,
    required this.switchPrompt,
    required this.switchLabel,
    required this.onSwitch,
  });

  final String title;
  final String submitLabel;

  /// Runs the auth call. May return a message to show once it succeeded
  /// (e.g. "confirm your email"); throws [AuthException] on failure.
  final Future<String?> Function(String email, String password) onSubmit;

  /// Muted lead-in of the bottom link, e.g. "Noch keinen Account?".
  final String switchPrompt;

  /// The link itself, e.g. "Registrieren".
  final String switchLabel;
  final VoidCallback onSwitch;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _loading = false;
  String? _error;
  String? _info;

  bool get _canSubmit =>
      !_loading && _email.text.trim().isNotEmpty && _password.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _email.addListener(_onChanged);
    _password.addListener(_onChanged);
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
      _info = null;
    });
    try {
      final info = await widget.onSubmit(_email.text.trim(), _password.text);
      if (mounted) setState(() => _info = info);
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } on Exception {
      if (mounted) {
        setState(
          () => _error = 'Das hat nicht geklappt. Bitte versuche es erneut.',
        );
      }
    } finally {
      // On success the router usually replaces this screen before this runs.
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageMargin,
        AppSpacing.s40,
        AppSpacing.pageMargin,
        AppSpacing.s24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.title,
            style: AppTextStyles.display.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: AppSpacing.s32),
          _Label('E-Mail'),
          const SizedBox(height: AppSpacing.s8),
          TextField(
            key: const ValueKey('auth_email'),
            controller: _email,
            enabled: !_loading,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            cursorColor: AppColors.lilac,
            style: AppTextStyles.body.copyWith(color: AppColors.white),
            decoration: _fieldDecoration('name@beispiel.de'),
          ),
          const SizedBox(height: AppSpacing.s16),
          _Label('Passwort'),
          const SizedBox(height: AppSpacing.s8),
          TextField(
            key: const ValueKey('auth_password'),
            controller: _password,
            enabled: !_loading,
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) {
              if (_canSubmit) _submit();
            },
            cursorColor: AppColors.lilac,
            style: AppTextStyles.body.copyWith(color: AppColors.white),
            decoration: _fieldDecoration('Passwort'),
          ),
          const SizedBox(height: AppSpacing.s24),
          _PrimaryButton(
            label: widget.submitLabel,
            loading: _loading,
            onPressed: _canSubmit ? _submit : null,
          ),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.s16),
            Semantics(
              liveRegion: true,
              child: Text(
                _error!,
                key: const ValueKey('auth_error'),
                style: AppTextStyles.body.copyWith(color: AppColors.error),
              ),
            ),
          ],
          if (_info != null) ...[
            const SizedBox(height: AppSpacing.s16),
            Semantics(
              liveRegion: true,
              child: Text(
                _info!,
                key: const ValueKey('auth_info'),
                style: AppTextStyles.body.copyWith(color: AppColors.white),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.s24),
          _SwitchLink(
            prompt: widget.switchPrompt,
            label: widget.switchLabel,
            onTap: _loading ? null : widget.onSwitch,
          ),
        ],
      ),
    );
  }
}

/// Same field chrome as the entry field in `add_words_screen.dart` (design.md
/// 5.16 / 3.4): `--surface`, radius 8, padding 16, 2 px `--lilac` on focus.
InputDecoration _fieldDecoration(String hint) {
  final shape = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
    borderSide: BorderSide.none,
  );
  return InputDecoration(
    filled: true,
    fillColor: AppColors.surface,
    hintText: hint,
    hintStyle: AppTextStyles.body.copyWith(color: AppColors.textMuted),
    contentPadding: const EdgeInsets.all(AppSpacing.cardPadding),
    border: shape,
    enabledBorder: shape,
    disabledBorder: shape,
    focusedBorder: shape.copyWith(
      borderSide: const BorderSide(color: AppColors.lilac, width: 2),
    ),
  );
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.body.copyWith(color: AppColors.white),
    );
  }
}

/// Primär-Button per design.md 5.12: white, 46 tall, radius 8, label `title`
/// in `--text-on-light`; 40 % opacity when disabled. While loading it shows a
/// spinner instead of the label and ignores taps.
class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  final String label;
  final bool loading;
  final VoidCallback? onPressed;

  static const double _height = 46.0;
  static const double _disabledOpacity = 0.4;
  static const double _spinnerStroke = 2.0;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return Opacity(
      // The loading state keeps full opacity: it is busy, not unavailable.
      opacity: enabled || loading ? 1 : _disabledOpacity,
      child: SizedBox(
        height: _height,
        child: FilledButton(
          key: const ValueKey('auth_submit'),
          onPressed: loading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.white,
            foregroundColor: AppColors.textOnLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
          ),
          child: loading
              ? Semantics(
                  label: 'Wird geladen',
                  child: const SizedBox.square(
                    key: ValueKey('auth_loading'),
                    dimension: AppSpacing.s24,
                    child: CircularProgressIndicator(
                      strokeWidth: _spinnerStroke,
                      color: AppColors.textOnLight,
                    ),
                  ),
                )
              : Text(
                  label,
                  style: AppTextStyles.title.copyWith(
                    color: AppColors.textOnLight,
                  ),
                ),
        ),
      ),
    );
  }
}

/// "Noch keinen Account? Registrieren": muted prompt plus a `--lilac` text link
/// (design.md 5.12). The whole row is the tap target, at least 44 tall.
class _SwitchLink extends StatelessWidget {
  const _SwitchLink({
    required this.prompt,
    required this.label,
    required this.onTap,
  });

  final String prompt;
  final String label;
  final VoidCallback? onTap;

  static const double _minTapHeight = 44.0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        key: const ValueKey('auth_switch'),
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: _minTapHeight),
          child: Center(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$prompt ',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  TextSpan(
                    text: label,
                    style: AppTextStyles.body.copyWith(color: AppColors.lilac),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
