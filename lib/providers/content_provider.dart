import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/assets.dart';
import 'package:sprachlern/models/content_data.dart';

const _contentSections = [
  ContentSectionData(
    title: 'STAPEL',
    tiles: [
      ContentTileData(
        icon: FLucideIcons.layers,
        label: 'Stapel',
        route: '/stacks',
      ),
      ContentTileData(icon: FLucideIcons.box, label: 'Eigene Stapel'),
    ],
  ),
  ContentSectionData(
    title: 'ÜBUNGSAUFGABEN',
    tiles: [
      ContentTileData(icon: FLucideIcons.libraryBig, label: 'Vokabeln'),
      ContentTileData(icon: FLucideIcons.repeat2, label: 'Stapel-Revue'),
      ContentTileData(icon: FLucideIcons.fileText, label: 'Texte'),
      ContentTileData(icon: FLucideIcons.messagesSquare, label: 'Sprechen'),
      ContentTileData(icon: FLucideIcons.languages, label: 'Grammatik'),
      ContentTileData(icon: FLucideIcons.headphones, label: 'Hören'),
      ContentTileData(icon: FLucideIcons.music, label: 'Musik'),
    ],
  ),
];

const _mockStacks = [
  VocabularyStackData(
    icon: FLucideIcons.bookOpen,
    title: 'Reisen und Alltag',
    difficultyLevel: 2,
    progress: StackProgressData(
      learnedWords: 12,
      seenWords: 23,
      totalWords: 50,
    ),
  ),
  VocabularyStackData(
    icon: FLucideIcons.messagesSquare,
    title: 'Nützliche Gespräche',
    difficultyLevel: 1,
  ),
  VocabularyStackData(
    icon: FLucideIcons.folderOpen,
    title: 'Arbeit und Termine',
    difficultyLevel: 3,
    progress: StackProgressData(learnedWords: 8, seenWords: 16, totalWords: 40),
  ),
];

final contentSectionsProvider = Provider<List<ContentSectionData>>(
  (ref) => _contentSections,
);

final stackListProvider = Provider<List<VocabularyStackData>>(
  (ref) => _mockStacks,
);
