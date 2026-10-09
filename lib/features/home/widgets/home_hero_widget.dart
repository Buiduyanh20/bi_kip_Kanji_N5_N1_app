import 'package:flutter/material.dart';

import 'package:bikip_kanji_app/app/theme/app_colors.dart';

/// Port của `HomeHero.tsx`: thẻ bo tròn, nội dung giữa, chữ 漢 mờ ở góc.
class HomeHero extends StatelessWidget {
  const HomeHero({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -16,
            bottom: -32,
            child: IgnorePointer(
              child: ExcludeSemantics(
                child: Text(
                  '漢',
                  locale: const Locale('ja', 'JP'),
                  style: TextStyle(
                    fontSize: 192,
                    height: 1,
                    color: AppColors.primary.withValues(alpha: 0.10),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 576),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
