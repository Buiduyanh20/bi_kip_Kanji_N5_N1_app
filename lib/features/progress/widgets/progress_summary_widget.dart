import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bikip_kanji_app/features/progress/providers/progress_summary_provider.dart';
import 'package:bikip_kanji_app/features/progress/widgets/level_progress_card_widget.dart';

/// Port của `ProgressClient` + `ProgressSummary`.
class ProgressSummaryWidget extends ConsumerWidget {
  const ProgressSummaryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = ref.watch(progressSectionsProvider);
    return Column(
      children: [
        for (var i = 0; i < sections.length; i++) ...[
          if (i > 0) const SizedBox(height: 24),
          LevelProgressCardWidget(data: sections[i]),
        ],
      ],
    );
  }
}
