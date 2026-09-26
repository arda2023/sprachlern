import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/assets.dart';
import 'package:sprachlern/models/knowledge_center_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/utils/german_number.dart';

/// The two cards of "Mein Wissenszentrum" exactly as design.md 5.6 lists them:
/// card 1 with three rows, card 2 with a single row.
final knowledgeStatCardsProvider = Provider<List<KnowledgeStatCard>>((ref) {
  return [
    KnowledgeStatCard(
      entries: [
        KnowledgeStatEntry(
          id: 'total-words',
          icon: FLucideIcons.chartNoAxesColumn,
          label: 'Gesamtzahl der Wörter',
          value: formatGermanInt(1456),
          dotColor: AppColors.cyan,
          description:
              'Alle Wörter, die in deinen Stapeln stecken – gelernte, '
              'gesehene und noch unbekannte zusammen.',
        ),
        KnowledgeStatEntry(
          id: 'known-words',
          icon: FLucideIcons.listChecks,
          label: 'Bekannte Wörter',
          value: formatGermanInt(1433),
          dotColor: AppColors.cyan,
          description:
              'Wörter, die du mindestens einmal gesehen hast. Sie zählen als '
              'aktiviert, auch wenn du sie noch nicht sicher beherrschst.',
        ),
        KnowledgeStatEntry(
          id: 'words-to-learn',
          icon: FLucideIcons.layoutGrid,
          label: 'Gesamtzahl zu lernender Wörter',
          value: formatGermanInt(23),
          dotColor: AppColors.orange,
          description:
              'Wörter, die noch als „Neues Wort“ auf dich warten. Sie kommen '
              'in den nächsten Übungen zum ersten Mal vor.',
        ),
      ],
    ),
    KnowledgeStatCard(
      entries: [
        KnowledgeStatEntry(
          id: 'learned-words',
          icon: FLucideIcons.bookOpen,
          label: 'Gesamtzahl gelernter Wörter',
          value: formatGermanInt(872),
          dotColor: AppColors.lilac,
          description:
              'Wörter, die du mehrfach richtig beantwortet hast. Sie kehren '
              'nur noch in größeren Abständen zurück.',
        ),
      ],
    ),
  ];
});
