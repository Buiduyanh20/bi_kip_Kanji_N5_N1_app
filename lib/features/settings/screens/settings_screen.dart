import 'package:flutter/material.dart';

import 'package:bikip_kanji_app/features/settings/widgets/app_info_section_widget.dart';
import 'package:bikip_kanji_app/features/settings/widgets/progress_transfer_widget.dart';
import 'package:bikip_kanji_app/features/settings/widgets/reset_data_dialog_widget.dart';
import 'package:bikip_kanji_app/features/settings/widgets/settings_section_label_widget.dart';
import 'package:bikip_kanji_app/features/settings/widgets/settings_shortcuts_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const double _maxWidth = 672;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt')),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontal = constraints.maxWidth < 360 ? 12.0 : 16.0;

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 24),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SettingsSectionLabel('LỐI TẮT'),
                      SettingsShortcutsWidget(),
                      SizedBox(height: 24),
                      SettingsSectionLabel('SAO LƯU DỮ LIỆU'),
                      ProgressTransferWidget(),
                      SizedBox(height: 24),
                      SettingsSectionLabel('VÙNG NGUY HIỂM'),
                      ResetLearningWidget(),
                      SizedBox(height: 24),
                      AppInfoSectionWidget(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}