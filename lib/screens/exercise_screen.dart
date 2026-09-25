import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/providers/exercise_provider.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/widgets/exercise_input_bar.dart';
import 'package:sprachlern/widgets/exercise_top_bar.dart';
import 'package:sprachlern/widgets/fill_in_card.dart';
import 'package:sprachlern/widgets/grammar_hint_sheet.dart';
import 'package:sprachlern/widgets/translation_card.dart';

class ExerciseScreen extends ConsumerStatefulWidget {
  const ExerciseScreen({super.key});

  @override
  ConsumerState<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends ConsumerState<ExerciseScreen> {
  String? _answer;

  @override
  Widget build(BuildContext context) {
    final exercise = ref.watch(exerciseProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      bottomNavigationBar: const ExerciseInputBar(),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ExerciseTopBar(
              currentCard: exercise.currentCard,
              totalCards: exercise.totalCards,
              onHome: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/home');
                }
              },
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
                          exercise: exercise,
                          answer: _answer,
                          onBlankTap: () =>
                              setState(() => _answer = exercise.targetAnswer),
                          onGrammarHintTap: () =>
                              showGrammarHintSheet(context, exercise),
                        ),
                        const SizedBox(height: AppSpacing.s16),
                        TranslationCard(
                          headword: exercise.germanHeadword,
                          exampleSentence: exercise.germanExampleSentence,
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
  }
}
