import 'package:flutter/material.dart';

import 'package:bikip_kanji_app/app/theme/app_colors.dart';

/// Port của `ItemChip.tsx`.
class ItemChipWidget extends StatelessWidget {
  const ItemChipWidget({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 36),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        locale: const Locale('ja', 'JP'),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
