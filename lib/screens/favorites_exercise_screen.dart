import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/models/exercise_data.dart';
import 'package:sprachlern/models/word_list_data.dart';
import 'package:sprachlern/providers/word_list_provider.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/widgets/exercise_input_bar.dart';
import 'package:sprachlern/widgets/exercise_top_bar.dart';
import 'package:sprachlern/widgets/fill_in_card.dart';
import 'package:sprachlern/widgets/grammar_hint_sheet.dart';
import 'package:sprachlern/widgets/translation_card.dart';

/// Local practice of favorited words. It deliberately has no SM-2 or RPC
/// scoring: changing a favorite should not change learning progress.
class FavoritesExerciseScreen extends ConsumerStatefulWidget {
  const FavoritesExerciseScreen({super.key});

  @override
  ConsumerState<FavoritesExerciseScreen> createState() =>
      _FavoritesExerciseScreenState();
}

class _FavoritesExerciseScreenState
    extends ConsumerState<FavoritesExerciseScreen> {
  int _index = 0;
  WordListEntry? _entry;
  String _answer = '';
  int _attemptCount = 0;
  bool _solutionRevealed = false;
  bool _isWrong = false;
  bool _isCorrect = false;

  void _syncEntry(WordListEntry entry) {
    if (identical(entry, _entry)) return;
    _entry = entry;
    _answer = '';
    _attemptCount = 0;
    _solutionRevealed = false;
    _isWrong = false;
    _isCorrect = false;
  }

  ExerciseAction get _action => _isCorrect
      ? ExerciseAction.next
      : _answer.isEmpty
      ? ExerciseAction.revealWord
      : ExerciseAction.submit;

  void _runAction(ExerciseData exercise) {
    switch (_action) {
      case ExerciseAction.revealWord:
        setState(() => _solutionRevealed = true);
      case ExerciseAction.submit:
        final correct =
            _answer.trim().toLowerCase() ==
            exercise.targetAnswer.trim().toLowerCase();
        setState(() {
          _isCorrect = correct;
          _isWrong = !correct;
          if (!correct) _attemptCount++;
        });
      case ExerciseAction.next:
        final favorites =
            ref.read(favoritesListProvider).asData?.value ?? const [];
        if (_index + 1 >= favorites.length) {
          context.go('/stacks');
        } else {
          setState(() => _index++);
        }
    }
  }

  void _back() => context.canPop() ? context.pop() : context.go('/stacks');

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesListProvider);
    return favorites.when(
      loading: () => _status('Favoriten werden geladen.'),
      error: (_, _) => _status('Favoriten konnten nicht geladen werden.'),
      data: (entries) {
        if (entries.isEmpty) {
          return _status('Du hast noch keine Favoriten.');
        }

        if (_index >= entries.length) {
          return _status('Du hast noch keine Favoriten.');
        }

        final entry = entries[_index];
        _syncEntry(entry);
        final ExerciseData exercise;
        try {
          exercise = _exerciseFor(entry, entries.length);
        } on FormatException {
          return _status(
            'Diese Karte hat keinen passenden englischen Lückensatz.',
            currentCard: _index + 1,
            totalCards: entries.length,
          );
        }

        return Scaffold(
          backgroundColor: AppColors.bg,
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: ExerciseInputBar(
              action: _action,
              onAction: () => _runAction(exercise),
            ),
          ),
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                ExerciseTopBar(
                  currentCard: _index + 1,
                  totalCards: entries.length,
                  onHome: _back,
                ),
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
                        child: Column(
                          children: [
                            FillInCard(
                              key: ValueKey('favorites_exercise_card_$_index'),
                              exercise: exercise,
                              showStatusIndicator: false,
                              isWrong: _isWrong,
                              attemptCount: _attemptCount,
                              solutionRevealed: _solutionRevealed,
                              isCorrect: _isCorrect,
                              onAnswerChanged: (value) {
                                if (_answer == value && !_isWrong) return;
                                setState(() {
                                  _answer = value;
                                  _isWrong = false;
                                });
                              },
                              onAnswerSubmitted: (_) => _runAction(exercise),
                              onGrammarHintTap: () =>
                                  showGrammarHintSheet(context, exercise),
                            ),
                            const SizedBox(height: AppSpacing.s16),
                            TranslationCard(
                              key: ValueKey('favorites_translation_$_index'),
                              headword: 'Übersetzung',
                              exampleSentence: entry.translation,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _status(String message, {int currentCard = 0, int totalCards = 0}) =>
      Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: Column(
            children: [
              ExerciseTopBar(
                currentCard: currentCard,
                totalCards: totalCards,
                onHome: _back,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    message,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  ExerciseData _exerciseFor(WordListEntry entry, int totalCards) {
    final sentence = entry.exampleSentence.trim();
    final target = entry.headword.trim();
    if (target.isEmpty) throw const FormatException('Empty target word');
    final match = RegExp(
      r'(^|[^\p{L}\p{N}])' + RegExp.escape(target) + r'(?=$|[^\p{L}\p{N}])',
      caseSensitive: false,
      unicode: true,
    ).firstMatch(sentence);
    if (match == null) {
      throw const FormatException('Target absent from sentence');
    }
    final start = match.start + match.group(1)!.length;
    List<ExerciseToken> tokensFor(String text) => [
      for (final word in text.trim().split(RegExp(r'\s+')))
        if (word.isNotEmpty) ExerciseToken(text: word),
    ];
    return ExerciseData(
      tokens: [
        ...tokensFor(sentence.substring(0, start)),
        const ExerciseToken(text: '', isBlank: true),
        ...tokensFor(sentence.substring(start + target.length)),
      ],
      wordStatus: 0,
      targetAnswer: sentence.substring(start, start + target.length),
      germanHeadword: '',
      germanExampleSentence: entry.translation,
      currentCard: _index + 1,
      totalCards: totalCards,
      grammarHintTitle: 'Grammatikhinweis',
      grammarHintDescription:
          'Für diese Karte ist kein Grammatikhinweis verfügbar.',
    );
  }
}
