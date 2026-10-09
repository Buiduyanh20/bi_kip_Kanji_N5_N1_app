/// Bảng bỏ dấu tiếng Việt (không cần thư viện Unicode normalize).
final Map<String, String> _viMap = () {
  const groups = {
    'a': 'àáạảãâầấậẩẫăằắặẳẵ',
    'e': 'èéẹẻẽêềếệểễ',
    'i': 'ìíịỉĩ',
    'o': 'òóọỏõôồốộổỗơờớợởỡ',
    'u': 'ùúụủũưừứựửữ',
    'y': 'ỳýỵỷỹ',
    'd': 'đ',
  };
  final map = <String, String>{};
  groups.forEach((base, chars) {
    for (final rune in chars.runes) {
      map[String.fromCharCode(rune)] = base;
    }
  });
  return map;
}();

final RegExp _combiningMarks = RegExp(r'[\u0300-\u036f]');
final RegExp _whitespaceRuns = RegExp(r'\s+');
final RegExp _trailingJunk = RegExp(r'[\s\p{P}\p{S}]+$', unicode: true);
final RegExp _punctSymbol = RegExp(r'[\p{P}\p{S}]+', unicode: true);

/// trim, gộp khoảng trắng, lowercase, đ→d, bỏ dấu.
String normalizeViet(String value) {
  final lower =
  value.trim().replaceAll(_whitespaceRuns, ' ').toLowerCase();
  final buffer = StringBuffer();
  for (final rune in lower.runes) {
    final ch = String.fromCharCode(rune);
    buffer.write(_viMap[ch] ?? ch);
  }
  // Xử lý luôn trường hợp bàn phím gửi dấu dạng tổ hợp (NFD).
  return buffer.toString().replaceAll(_combiningMarks, '');
}

String capitalizeFirst(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return '';
  return '${trimmed[0].toUpperCase()}${trimmed.substring(1)}';
}

/// Dùng cho chấm đáp án: như normalizeViet và cắt dấu câu ở cuối.
String normalizeAnswerText(String value) =>
    normalizeViet(value).replaceAll(_trailingJunk, '').trim();

/// Dùng cho ô tìm kiếm.
String normalizeSearchValue(String value) => normalizeViet(value)
    .replaceAll(_punctSymbol, ' ')
    .replaceAll(_whitespaceRuns, ' ')
    .trim();