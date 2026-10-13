import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bikip_kanji_app/core/logic/text_normalizer.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/favorite.dart';
import 'package:bikip_kanji_app/data/models/kanji.dart';
import 'package:bikip_kanji_app/data/providers/app_state.dart';
import 'package:bikip_kanji_app/data/repositories/content_repository.dart';
import 'package:bikip_kanji_app/data/repositories/providers.dart';

/// Một mục yêu thích kèm nội dung Kanji.
class FavoriteEntry {
  const FavoriteEntry({required this.favorite, required this.kanji});

  final Favorite favorite;
  final Kanji kanji;
}

/// Giữ thứ tự của [favorites] (mới nhất trước), bỏ mục không còn trong nội dung.
List<FavoriteEntry> computeFavoriteEntries({
  required ContentRepository content,
  required List<Favorite> favorites,
}) {
  final result = <FavoriteEntry>[];
  for (final f in favorites) {
    final kanji = content.kanjiById(f.kanjiId);
    if (kanji != null) result.add(FavoriteEntry(favorite: f, kanji: kanji));
  }
  return result;
}

/// Lọc theo level (null = tất cả) và từ khóa (Kanji, Hán Việt, nghĩa).
List<FavoriteEntry> filterFavoriteEntries(
    List<FavoriteEntry> entries, {
      JlptLevel? level,
      String query = '',
    }) {
  final q = normalizeSearchValue(query);
  return entries.where((e) {
    if (level != null && e.kanji.level != level) return false;
    if (q.isEmpty) return true;
    final values = [e.kanji.char, ...e.kanji.hanViet, ...e.kanji.meanings];
    return values.map(normalizeSearchValue).any((v) => v.contains(q));
  }).toList();
}

final favoriteEntriesProvider = Provider<List<FavoriteEntry>>((ref) {
  return computeFavoriteEntries(
    content: ref.watch(contentRepositoryProvider),
    favorites: ref.watch(favoritesProvider).valueOrNull ?? const [],
  );
});