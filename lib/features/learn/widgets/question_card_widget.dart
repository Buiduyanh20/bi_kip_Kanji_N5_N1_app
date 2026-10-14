import 'package:flutter/material.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/kanji.dart';
import 'package:bikip_kanji_app/data/models/vocab.dart';

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
    final text = item is Kanji
        ? item.char
        : item is Vocab
        ? item.word
        : '';

    // Hán Việt: chỉ hiện chữ (ẩn subtitle vì đó là đáp án)
    // Nghĩa / Cách đọc: có thể hiện gợi ý phụ nếu cần
    final String? subtitle = switch (method) {
      LearnMethod.hanviet => null,
      LearnMethod.meaning => null, // đang đoán nghĩa → không lộ nghĩa
      LearnMethod.reading => null, // đang đoán cách đọc → không lộ reading
    };

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black12),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: subtitle == null ? 40 : 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 96,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),
            if (subtitle != null && subtitle.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:bikip_kanji_app/data/models/enums.dart';
//
// class QuestionCardWidget extends StatelessWidget {
//   const QuestionCardWidget({
//     super.key,
//     required this.item,
//     required this.method,
//   });
//
//   final dynamic item;
//   final LearnMethod method;
//
//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text(
//         'DEMO',
//         style: TextStyle(
//           fontSize: 120,
//           fontWeight: FontWeight.bold,
//           color: Colors.red,
//         ),
//       ),
//     );
//   }
// }