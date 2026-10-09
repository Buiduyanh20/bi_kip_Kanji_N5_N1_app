import 'package:flutter/material.dart';

import 'package:bikip_kanji_app/app/theme/app_colors.dart';

class SettingsSectionLabel extends StatelessWidget {
  const SettingsSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 12),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        letterSpacing: 2,
        color: AppColors.textHint,
      ),
    ),
  );
}
