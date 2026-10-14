// import 'package:flutter/material.dart';
// import 'package:bikip_kanji_app/core/logic/answer_checker.dart';
// import 'package:bikip_kanji_app/data/models/kanji.dart';
// import 'package:bikip_kanji_app/data/models/vocab.dart';
//
// class ResultPanelWidget extends StatelessWidget {
//   const ResultPanelWidget({
//     super.key,
//     required this.item,
//     required this.correct,
//     required this.status,
//     required this.input,
//     required this.expected,
//     required this.onNext,
//     required this.last,
//   });
//
//   final dynamic item;
//   final bool correct;
//   final AnswerStatus status;
//   final String input;
//   final List<String> expected;
//   final VoidCallback onNext;
//   final bool last;
//
//   @override
//   Widget build(BuildContext context) {
//     final isNear = status == AnswerStatus.near;
//
//     final title = isNear
//         ? '△ Gần đúng'
//         : correct
//         ? '✓ Chính xác'
//         : '✕ Chưa đúng';
//
//     final color = correct
//         ? Colors.green
//         : Colors.red;
//
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: correct
//             ? Colors.green.shade50
//             : Colors.red.shade50,
//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//
//           const SizedBox(height: 24),
//
//           Text(
//             item is Kanji
//                 ? item.char
//                 : item.word,
//             style: const TextStyle(
//               fontSize: 72,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           Text(
//             expected.join(', '),
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontSize: 26,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           Text(
//             item.meanings.join(', '),
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontSize: 18,
//             ),
//           ),
//
//           const SizedBox(height: 28),
//
//           SizedBox(
//             width: double.infinity,
//             height: 52,
//             child: FilledButton(
//               onPressed: onNext,
//               child: Text(
//                 last
//                     ? 'Xem kết quả'
//                     : 'Tiếp tục',
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';

import 'package:bikip_kanji_app/core/logic/answer_checker.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/kanji.dart';
import 'package:bikip_kanji_app/data/models/vocab.dart';

class ResultPanelWidget extends StatelessWidget {
  const ResultPanelWidget({
    super.key,
    required this.item,
    required this.method,
    required this.correct,
    required this.status,
    required this.input,
    required this.expected,
    required this.onNext,
    required this.last,
  });

  final dynamic item;
  final LearnMethod method;
  final bool correct;
  final AnswerStatus status;
  final String input;
  final List<String> expected;
  final VoidCallback onNext;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final isNear = status == AnswerStatus.near;

    final title = isNear
        ? '△ Gần đúng'
        : correct
        ? '✓ Chính xác'
        : '✕ Chưa đúng';

    final color = correct ? Colors.green : Colors.red;

    // Hán Việt & Nghĩa: ẩn chữ lớn
    final showChar = method == LearnMethod.reading;

    // Hán Việt / Cách đọc: hiện meanings
    final showMeanings =
        method == LearnMethod.hanviet || method == LearnMethod.reading;

    // Nghĩa: hiện Hán Việt
    final showHanViet = method == LearnMethod.meaning && item is Kanji;

    // Chỉ hiện hint khi sai (không hiện khi đúng / gần đúng)
    final showHint = !correct &&
        !isNear &&
        item is Kanji &&
        (item as Kanji).hint.isNotEmpty;

    final charOrWord = item is Kanji
        ? item.char
        : item is Vocab
        ? item.word
        : '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      decoration: BoxDecoration(
        color: correct ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (showChar) ...[
            const SizedBox(height: 16),
            Text(
              charOrWord,
              style: const TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            expected.join(', '),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (showHanViet) ...[
            const SizedBox(height: 12),
            Text(
              (item as Kanji).hanViet.join(', '),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (showMeanings) ...[
            const SizedBox(height: 12),
            Text(
              item.meanings.join(', '),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ],
          if (showHint) ...[
            const SizedBox(height: 12),
            Text(
              (item as Kanji).hint,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.4,
                color: Colors.grey[700],
              ),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: onNext,
              child: Text(last ? 'Xem kết quả' : 'Tiếp tục'),
            ),
          ),
        ],
      ),
    );
  }
}