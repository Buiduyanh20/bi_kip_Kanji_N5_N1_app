import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:bikip_kanji_app/core/logic/text_normalizer.dart';
import 'package:bikip_kanji_app/data/models/content_item.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/kanji.dart';
import 'package:bikip_kanji_app/data/models/vocab.dart';

/// Dữ liệu tĩnh, nạp một lần vào bộ nhớ (tương đương contentRepository.ts).
class ContentRepository {
  ContentRepository(List<Kanji> kanji, List<Vocab> vocab)
      : _kanji = List.unmodifiable(kanji),
        _vocab = List.unmodifiable(vocab),
        _kanjiById = {for (final k in kanji) k.id: k},
        _vocabById = {for (final v in vocab) v.id: v} {
    assert(_kanjiById.length == _kanji.length, 'Trùng id Kanji');
    assert(_vocabById.length == _vocab.length, 'Trùng id Vocab');
    assert(
    !_kanjiById.keys.any(_vocabById.containsKey),
    'Id Kanji trùng id Vocab',
    );
  }

  final List<Kanji> _kanji;
  final List<Vocab> _vocab;
  final Map<String, Kanji> _kanjiById;
  final Map<String, Vocab> _vocabById;

  static Future<ContentRepository> load({AssetBundle? bundle}) async {
    final b = bundle ?? rootBundle;
    final kanji = <Kanji>[];
    final vocab = <Vocab>[];

    // Thứ tự N1 → N5 giống `Object.values(kanjiData)` bên web.
    for (final level in JlptLevel.values.reversed) {
      final file = level.code.toLowerCase();
      kanji.addAll(await _readList(b, 'assets/data/kanji/$file.json', Kanji.fromJson));
      vocab.addAll(await _readList(b, 'assets/data/vocabulary/$file.json', Vocab.fromJson));
    }
    return ContentRepository(kanji, vocab);
  }

  static Future<List<T>> _readList<T>(
      AssetBundle bundle,
      String path,
      T Function(Map<String, dynamic>) parse,
      ) async {
    var text = await bundle.loadString(path);
    if (text.startsWith('\uFEFF')) text = text.substring(1); // bỏ BOM nếu có
    final list = jsonDecode(text) as List<dynamic>;
    return list.map((e) => parse(Map<String, dynamic>.from(e as Map))).toList();
  }

  // ── Kanji ──
  List<Kanji> kanjiByLevel(JlptLevel level) =>
      _kanji.where((k) => k.level == level).toList();

  Kanji? kanjiById(String id) => _kanjiById[id];

  List<Kanji> searchKanji(String keyword) {
    final query = normalizeSearchValue(keyword);
    if (query.isEmpty) return const [];
    return _kanji.where((k) {
      final values = [k.char, ...k.hanViet, ...k.meanings];
      return values.map(normalizeSearchValue).any((v) => v.contains(query));
    }).toList();
  }

  // ── Vocab ──
  List<Vocab> vocabByLevel(JlptLevel level) =>
      _vocab.where((v) => v.level == level).toList();

  Vocab? vocabById(String id) => _vocabById[id];

  // ── Dùng chung ──
  List<ContentItem> itemsByLevel(ContentType type, JlptLevel level) =>
      type == ContentType.kanji ? kanjiByLevel(level) : vocabByLevel(level);

  ContentItem? itemById(ContentType type, String id) =>
      type == ContentType.kanji ? kanjiById(id) : vocabById(id);

  int countByLevel(ContentType type, JlptLevel level) =>
      itemsByLevel(type, level).length;

  List<LearnMethod> availableMethods(ContentType type, JlptLevel level) {
    if (type == ContentType.vocabulary) {
      return vocabByLevel(level).isEmpty
          ? const []
          : const [LearnMethod.reading, LearnMethod.meaning];
    }
    final items = kanjiByLevel(level);
    if (items.isEmpty) return const [];
    return [
      LearnMethod.hanviet,
      LearnMethod.meaning,
      if (items.any((k) => k.hasReadings)) LearnMethod.reading,
    ];
  }

  List<JlptLevel> levelsWithContent(ContentType type) => JlptLevel.values
      .where((level) => countByLevel(type, level) > 0)
      .toList();
}