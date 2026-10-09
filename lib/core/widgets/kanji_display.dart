import 'package:flutter/material.dart';

import 'package:bikip_kanji_app/app/theme/app_colors.dart';

/// Chữ Kanji/từ vựng cỡ lớn, tự thu nhỏ nếu từ dài.
class KanjiDisplay extends StatelessWidget {
  const KanjiDisplay(this.text, {super.key, this.size = 88});

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) => FittedBox(
    fit: BoxFit.scaleDown,
    child: Text(
      text,
      locale: const Locale('ja', 'JP'),
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w600,
        height: 1.15,
        color: AppColors.textPrimary,
      ),
    ),
  );
}
