import 'package:flutter/material.dart';

import 'package:bikip_kanji_app/data/models/enums.dart';

/// Chọn loại nội dung (Kanji / Từ vựng) và level JLPT.
class ProgressFilterBarWidget extends StatelessWidget {
  const ProgressFilterBarWidget({
    super.key,
    required this.type,
    required this.levels,
    required this.level,
    required this.onTypeChanged,
    required this.onLevelChanged,
  });

  final ContentType type;
  final List<JlptLevel> levels;
  final JlptLevel? level;
  final ValueChanged<ContentType> onTypeChanged;
  final ValueChanged<JlptLevel> onLevelChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<ContentType>(
          segments: const [
            ButtonSegment(value: ContentType.kanji, label: Text('Kanji')),
            ButtonSegment(value: ContentType.vocabulary, label: Text('Từ vựng')),
          ],
          selected: {type},
          onSelectionChanged: (s) => onTypeChanged(s.first),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final l in levels)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(l.code),
                    selected: l == level,
                    onSelected: (_) => onLevelChanged(l),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}