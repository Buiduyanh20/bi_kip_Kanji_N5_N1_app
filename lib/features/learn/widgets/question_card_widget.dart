import 'package:flutter/material.dart';

import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/kanji.dart';
import 'package:bikip_kanji_app/data/models/vocab.dart';
import 'package:bikip_kanji_app/features/favorite/widgets/favorite_button_widget.dart';

class QuestionCardWidget extends StatelessWidget {
  const QuestionCardWidget({
    super.key,
    required this.item,
    required this.method,
  });

  final dynamic item;
  final LearnMethod method;

  @override
  Widget build(BuildContext context) {
    final String text = item is Kanji
        ? (item as Kanji).char
        : item is Vocab
        ? (item as Vocab).word
        : '';

    // Không hiện gợi ý phụ ở cả 3 phương pháp vì sẽ lộ đáp án.
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black12),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  locale: const Locale('ja', 'JP'),
                  style: const TextStyle(
                    fontSize: 96,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
              ),
            ),
          ),
          if (item is Kanji)
            Positioned(
              top: 4,
              right: 4,
              child: FavoriteButtonWidget(kanji: item as Kanji),
            ),
        ],
      ),
    );
  }
}