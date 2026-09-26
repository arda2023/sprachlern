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
      ContentTileData(
        icon: FLucideIcons.box,
        label: 'Eigene Stapel',
        route: '/custom-stack',
      ),
    ],
  ),
  ContentSectionData(
    title: 'ÜBUNGSAUFGABEN',
    tiles: [
      ContentTileData(
        icon: FLucideIcons.libraryBig,
        label: 'Vokabeln',
        route: '/word-list',
      ),
      ContentTileData(
        icon: FLucideIcons.repeat2,
        label: 'Stapel-Revue',
        route: '/stack-revue',
      ),
      ContentTileData(
        icon: FLucideIcons.fileText,
        label: 'Texte',
        route: '/texts',
      ),
      ContentTileData(icon: FLucideIcons.messagesSquare, label: 'Sprechen'),
      ContentTileData(
        icon: FLucideIcons.languages,
        label: 'Grammatik',
        route: '/grammar-list',
      ),
      ContentTileData(icon: FLucideIcons.headphones, label: 'Hören'),
      ContentTileData(icon: FLucideIcons.music, label: 'Musik'),
    ],
  ),
];

const _travelStack = VocabularyStackData(
  id: 'reisen-und-alltag',
  icon: FLucideIcons.bookOpen,
  title: 'Reisen und Alltag',
  difficultyLevel: 2,
  progress: StackProgressData(learnedWords: 28, seenWords: 41, totalWords: 126),
);

const _conversationStack = VocabularyStackData(
  id: 'nuetzliche-gespraeche',
  icon: FLucideIcons.messagesSquare,
  title: 'Nützliche Gespräche',
  difficultyLevel: 1,
);

const _workStack = VocabularyStackData(
  id: 'arbeit-und-termine',
  icon: FLucideIcons.folderOpen,
  title: 'Arbeit und Termine',
  difficultyLevel: 3,
  progress: StackProgressData(learnedWords: 8, seenWords: 16, totalWords: 40),
);

const _mockStacks = [_travelStack, _conversationStack, _workStack];

const _mockStackDetails = <String, StackDetailData>{
  'reisen-und-alltag': StackDetailData(
    stack: _travelStack,
    description:
        'Wörter und Wendungen für unterwegs: Bahnhof, Hotel, Restaurant und '
        'kleine Gespräche zwischendurch.',
    difficultyLabel: 'Mittleres Niveau',
    newWordsSeen: 41,
    newWordsTotal: 126,
    learnedWords: 28,
    totalWords: 126,
    recentWords: [
      RecentWordEntry(
        germanWord: 'Gepäck',
        germanExample: 'Mein Gepäck ist noch nicht angekommen.',
        englishExample: 'My luggage has not arrived yet.',
      ),
      RecentWordEntry(
        germanWord: 'Bahnsteig',
        germanExample: 'Der Zug fährt von Bahnsteig drei ab.',
        englishExample: 'The train leaves from platform three.',
      ),
      RecentWordEntry(
        germanWord: 'buchen',
        germanExample: 'Ich möchte ein Zimmer buchen.',
        englishExample: 'I would like to book a room.',
      ),
      RecentWordEntry(
        germanWord: 'Quittung',
        germanExample: 'Können Sie mir bitte eine Quittung geben?',
        englishExample: 'Could you give me a receipt, please?',
      ),
      RecentWordEntry(
        germanWord: 'umsteigen',
        germanExample: 'Du musst in Köln umsteigen.',
        englishExample: 'You have to change trains in Cologne.',
      ),
    ],
  ),
  'nuetzliche-gespraeche': StackDetailData(
    stack: _conversationStack,
    description:
        'Kurze Sätze für den Einstieg: begrüßen, nachfragen und höflich '
        'antworten.',
    difficultyLabel: 'Anfänger',
    newWordsSeen: 0,
    newWordsTotal: 80,
    learnedWords: 0,
    totalWords: 80,
    recentWords: [],
  ),
  'arbeit-und-termine': StackDetailData(
    stack: _workStack,
    description:
        'Wortschatz für Büro und Zusammenarbeit: Termine abstimmen, Aufgaben '
        'verteilen und Ergebnisse festhalten.',
    difficultyLabel: 'Fortgeschritten',
    newWordsSeen: 16,
    newWordsTotal: 40,
    learnedWords: 8,
    totalWords: 40,
    recentWords: [
      RecentWordEntry(
        germanWord: 'Besprechung',
        germanExample: 'Die Besprechung beginnt um neun Uhr.',
        englishExample: 'The meeting starts at nine.',
      ),
      RecentWordEntry(
        germanWord: 'Frist',
        germanExample: 'Wir müssen die Frist einhalten.',
        englishExample: 'We have to meet the deadline.',
      ),
    ],
  ),
};

final contentSectionsProvider = Provider<List<ContentSectionData>>(
  (ref) => _contentSections,
);

final stackListProvider = Provider<List<VocabularyStackData>>(
  (ref) => _mockStacks,
);

final stackDetailsProvider = Provider<Map<String, StackDetailData>>(
  (ref) => _mockStackDetails,
);
