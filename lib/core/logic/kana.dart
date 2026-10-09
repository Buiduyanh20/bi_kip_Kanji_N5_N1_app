import 'package:kana_kit/kana_kit.dart';

const KanaKit _kit = KanaKit();

/// Tương đương `toHiragana` của wanakana.
/// Hạ chữ thường trước vì bàn phím mobile hay tự viết hoa chữ đầu ("Haha").
String toHiragana(String input) => _kit.toHiragana(input.toLowerCase());