import 'package:forui/assets.dart';
import 'package:sprachlern/models/content_data.dart';

const _travelStack = VocabularyStackData(
  id: 'reisen-und-alltag',
  icon: FLucideIcons.bookOpen,
  title: 'Reisen und Alltag',
  difficultyLevel: 2,
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

final fixtureStacks = _mockStacks;
final fixtureDetails = _mockStackDetails;
