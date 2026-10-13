import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bikip_kanji_app/data/models/kanji.dart';
import 'package:bikip_kanji_app/data/repositories/providers.dart';

class KanjiSearchState {
  final String keyword;
  final List<Kanji> results;

  const KanjiSearchState({
    this.keyword = '',
    this.results = const [],
  });


  KanjiSearchState copyWith({
    String? keyword,
    List<Kanji>? results,
  }) {
    return KanjiSearchState(
      keyword: keyword ?? this.keyword,
      results: results ?? this.results,
    );
  }
}

class KanjiSearchNotifier extends StateNotifier<KanjiSearchState> {
  KanjiSearchNotifier(this.ref) : super(const KanjiSearchState());

  final Ref ref;

  void search(String keyword) {
    final repo = ref.read(contentRepositoryProvider);

    final results = repo.searchKanji(keyword);

    state = state.copyWith(keyword: keyword, results: results);
  }

  void clear() {
    state = const KanjiSearchState();
  }
}

final kanjiSearchProvider =
    StateNotifierProvider<KanjiSearchNotifier, KanjiSearchState>((ref) {
      return KanjiSearchNotifier(ref);
    });
