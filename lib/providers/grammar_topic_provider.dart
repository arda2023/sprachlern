import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprachlern/models/grammar_topic_data.dart';

const _mockGrammarTopics = [
  GrammarTopicData(
    id: 'adjektiv-oder-adverb',
    title: 'Adjektiv oder Adverb',
    taskDescription: 'Wähle das Wort, das am besten in die Lücke passt.',
    metaLabel: 'Grammatik | Level 1',
    isCompleted: false,
  ),
  GrammarTopicData(
    id: 'simple-past',
    title: 'Simple Past',
    taskDescription: 'Setze die richtige Vergangenheitsform ein.',
    metaLabel: 'Grammatik | Level 1',
    isCompleted: false,
  ),
  GrammarTopicData(
    id: 'praepositionen-der-zeit',
    title: 'Präpositionen der Zeit',
    taskDescription: 'Wähle die passende Präposition.',
    metaLabel: 'Grammatik | Level 2',
    isCompleted: false,
  ),
  GrammarTopicData(
    id: 'artikel-a-an-the',
    title: 'Artikel: a, an, the',
    taskDescription: 'Wähle den richtigen Artikel.',
    metaLabel: 'Grammatik | Level 1',
    isCompleted: true,
  ),
  GrammarTopicData(
    id: 'present-perfect',
    title: 'Present Perfect',
    taskDescription: 'Wähle die richtige Antwort.',
    metaLabel: 'Grammatik | Level 2',
    isCompleted: true,
  ),
  GrammarTopicData(
    id: 'bedingungssaetze',
    title: 'Bedingungssätze',
    taskDescription: 'Wähle die Form, die den Satz vollendet.',
    metaLabel: 'Grammatik | Level 3',
    isCompleted: true,
  ),
];

const _mockExplanationTopics = [
  GrammarExplanationTopicData(
    id: 'wochentage',
    title: 'Wochentage',
    levelLabel: 'Anfänger',
    wordPairs: [
      GrammarWordPair(english: 'Monday', german: 'Montag'),
      GrammarWordPair(english: 'Tuesday', german: 'Dienstag'),
      GrammarWordPair(english: 'Wednesday', german: 'Mittwoch'),
      GrammarWordPair(english: 'Thursday', german: 'Donnerstag'),
    ],
    warnings: [
      'Wochentage schreibt man im Englischen immer groß: on Monday, never on '
          'monday.',
      'Für einen einzelnen Tag steht die Präposition on: on Tuesday, on '
          'Wednesday.',
    ],
  ),
  GrammarExplanationTopicData(
    id: 'zahlen-eins-bis-zehn',
    title: 'Zahlen von eins bis zehn',
    levelLabel: 'Anfänger',
    wordPairs: [
      GrammarWordPair(english: 'one', german: 'eins'),
      GrammarWordPair(english: 'two', german: 'zwei'),
      GrammarWordPair(english: 'three', german: 'drei'),
      GrammarWordPair(english: 'four', german: 'vier'),
    ],
    warnings: [
      'Nach einer Zahl bleibt die Einheit im Plural: two hours, three days.',
      'Vor einer Zahl steht kein unbestimmter Artikel: one book, never a one '
          'book.',
    ],
  ),
  GrammarExplanationTopicData(
    id: 'unregelmaessige-verben',
    title: 'Unregelmäßige Verben',
    levelLabel: 'Mittleres Niveau',
    wordPairs: [
      GrammarWordPair(english: 'go – went – gone', german: 'gehen'),
      GrammarWordPair(english: 'see – saw – seen', german: 'sehen'),
      GrammarWordPair(english: 'take – took – taken', german: 'nehmen'),
    ],
    warnings: [
      'Unregelmäßige Verben bilden die Vergangenheit ohne -ed: he went, never '
          'he goed.',
      'Das dritte Feld ist das Partizip und verlangt ein Hilfsverb: she has '
          'taken it.',
    ],
  ),
  GrammarExplanationTopicData(
    id: 'modalverben',
    title: 'Modalverben',
    levelLabel: 'Mittleres Niveau',
    wordPairs: [
      GrammarWordPair(english: 'can', german: 'können'),
      GrammarWordPair(english: 'must', german: 'müssen'),
      GrammarWordPair(english: 'should', german: 'sollen'),
    ],
    warnings: [
      'Nach einem Modalverb steht der Infinitiv ohne Partikel: I can swim, '
          'never I can to swim.',
      'Modalverben bekommen in der dritten Person kein -s: she can, never she '
          'cans.',
    ],
  ),
  GrammarExplanationTopicData(
    id: 'passiv',
    title: 'Passiv',
    levelLabel: 'Fortgeschrittene',
    wordPairs: [
      GrammarWordPair(english: 'is written', german: 'wird geschrieben'),
      GrammarWordPair(english: 'was written', german: 'wurde geschrieben'),
      GrammarWordPair(
        english: 'has been written',
        german: 'ist geschrieben worden',
      ),
    ],
    warnings: [
      'Das Passiv braucht immer ein Hilfsverb plus Partizip: it is done, it '
          'was done.',
      'Den Urheber nennt man mit einer Präposition: written by her.',
    ],
  ),
  GrammarExplanationTopicData(
    id: 'indirekte-rede',
    title: 'Indirekte Rede',
    levelLabel: 'Fortgeschrittene',
    wordPairs: [
      GrammarWordPair(english: 'he says he is', german: 'er sagt, er sei'),
      GrammarWordPair(english: 'he said he was', german: 'er sagte, er sei'),
      GrammarWordPair(
        english: 'he said he had been',
        german: 'er sagte, er sei gewesen',
      ),
    ],
    warnings: [
      'Steht der Hauptsatz in der Vergangenheit, rückt die Zeit eine Stufe '
          'zurück: he said he was late.',
      'Das einleitende Wort ist freiwillig und darf entfallen: he said he was '
          'tired.',
    ],
  ),
];

/// All grammar exercise rows. The two tabs of the Grammatik screen filter this
/// one list by `isCompleted` (design.md 6).
final grammarTopicsProvider = Provider<List<GrammarTopicData>>(
  (ref) => _mockGrammarTopics,
);

/// All "Grammatikhinweise" topics, in one list; the level tabs filter it.
final grammarExplanationTopicsProvider =
    Provider<List<GrammarExplanationTopicData>>(
      (ref) => _mockExplanationTopics,
    );

/// The three level labels, in the order design.md 6 lists the tabs.
const grammarExplanationLevels = [
  'Anfänger',
  'Mittleres Niveau',
  'Fortgeschrittene',
];

/// Topics of one level.
final grammarExplanationTopicsByLevelProvider =
    Provider.family<List<GrammarExplanationTopicData>, String>(
      (ref, level) => ref
          .watch(grammarExplanationTopicsProvider)
          .where((topic) => topic.levelLabel == level)
          .toList(),
    );

/// A single topic by id, for the light explanation page.
final grammarExplanationTopicProvider =
    Provider.family<GrammarExplanationTopicData?, String>((ref, id) {
      for (final topic in ref.watch(grammarExplanationTopicsProvider)) {
        if (topic.id == id) return topic;
      }
      return null;
    });
