import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/assets.dart';
import 'package:sprachlern/models/content_data.dart';
import 'package:sprachlern/services/stack_repository.dart';
import 'package:sprachlern/services/supabase_client.dart';

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

final contentSectionsProvider = Provider<List<ContentSectionData>>(
  (ref) => _contentSections,
);

final stackRepositoryProvider = Provider<StackRepository>(
  (ref) => StackRepository(ref.watch(supabaseClientProvider)),
);

final stackListProvider = FutureProvider<List<VocabularyStackData>>(
  (ref) => ref.watch(stackRepositoryProvider).fetchStacks(),
);

final stackDetailsProvider = FutureProvider.family<StackDetailData?, String>(
  (ref, stackId) =>
      ref.watch(stackRepositoryProvider).fetchStackDetail(stackId),
);
