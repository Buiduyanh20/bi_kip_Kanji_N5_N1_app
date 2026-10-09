import 'package:flutter/material.dart';

import 'package:bikip_kanji_app/app/theme/app_colors.dart';
import 'package:bikip_kanji_app/features/progress/widgets/progress_summary_widget.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tiến độ')),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 672),
          child: const SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Theo dõi những gì bạn đã nhớ.',
                  style: TextStyle(fontSize: 14, color: AppColors.textHint),
                ),
                SizedBox(height: 16),
                ProgressSummaryWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
