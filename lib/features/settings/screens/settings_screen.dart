import 'package:flutter/material.dart';

import 'package:bikip_kanji_app/features/settings/widgets/app_info_section_widget.dart';
import 'package:bikip_kanji_app/features/settings/widgets/progress_transfer_widget.dart';
import 'package:bikip_kanji_app/features/settings/widgets/reset_data_dialog_widget.dart';
import 'package:bikip_kanji_app/features/settings/widgets/settings_header_widget.dart';
import 'package:bikip_kanji_app/features/settings/widgets/settings_section_label_widget.dart';
import 'package:bikip_kanji_app/features/settings/widgets/settings_shortcuts_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt')),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 672),
          child: const SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SettingsHeaderWidget(),
                SizedBox(height: 24),
                SettingsSectionLabel('LỐI TẮT'),
                SettingsShortcutsWidget(),
                SizedBox(height: 24),
                SettingsSectionLabel('SAO LƯU DỮ LIỆU'),
                ProgressTransferWidget(),
                SizedBox(height: 24),
                SettingsSectionLabel('VÙNG NGUY HIỂM'),
                ResetDataDialogWidget(),
                SizedBox(height: 24),
                AppInfoSectionWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
