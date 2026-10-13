import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import 'package:bikip_kanji_app/app/theme/app_colors.dart';
import 'package:bikip_kanji_app/core/logic/backup_codec.dart';
import 'package:bikip_kanji_app/data/providers/app_state.dart';
import 'package:bikip_kanji_app/data/repositories/backup_repository.dart';

const _invalidFile = 'Tệp tiến độ không hợp lệ.';

class ProgressTransferWidget extends ConsumerStatefulWidget {
  const ProgressTransferWidget({super.key});

  @override
  ConsumerState<ProgressTransferWidget> createState() =>
      _ProgressTransferWidgetState();
}

class _ProgressTransferWidgetState
    extends ConsumerState<ProgressTransferWidget> {
  bool _busy = false;

  void _log(String message) {
    debugPrint('[BACKUP_DEBUG] $message');
  }

  void _snack(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _alert(String message) async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,

      builder: (ctx) {
        return AlertDialog(
          title: const Text('Thông báo'),

          content: Text(message),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),

              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _export() async {
    if (_busy) return;

    _log('========== EXPORT START ==========');

    final actions = ref.read(backupActionsProvider);

    setState(() {
      _busy = true;
    });

    try {
      _log('1. Calling backupActions.exportToFile()');

      final file = await actions.exportToFile();

      _log('2. Export returned file:');

      _log('   path = ${file.path}');

      final exists = await file.exists();

      _log('3. File exists = $exists');

      if (!exists) {
        throw Exception('Backup file does not exist');
      }

      final length = await file.length();

      _log('4. File size = $length bytes');

      _log('5. BEFORE Share.shareXFiles');

      await Share.shareXFiles([XFile(file.path)]);

      _log('6. AFTER Share.shareXFiles');
    } catch (e, stack) {
      _log('EXPORT ERROR = $e');

      _log(stack.toString());

      _snack('Không thể xuất dữ liệu.');
    } finally {
      _log('========== EXPORT END ==========');

      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  Future<void> _import() async {
    if (_busy) return;

    _log('========== IMPORT START ==========');

    final actions = ref.read(backupActionsProvider);

    setState(() {
      _busy = true;
    });

    try {
      _log('1. BEFORE FilePicker');

      final picked = await FilePicker.platform.pickFiles(
        // Không dùng custom json vì Samsung lỗi
        type: FileType.any,

        withData: true,
      );

      _log('2. FilePicker result = $picked');

      if (picked == null || picked.files.isEmpty) {
        _log('3. User cancelled picker');

        return;
      }

      final file = picked.files.single;

      _log('4. Selected file name = ${file.name}');

      if (!file.name.toLowerCase().endsWith('.json')) {
        await _alert('Vui lòng chọn file .json');

        return;
      }

      final bytes =
          file.bytes ??
          (file.path == null ? null : await File(file.path!).readAsBytes());

      _log('5. Bytes length = ${bytes?.length}');

      if (bytes == null) {
        throw Exception('Cannot read file bytes');
      }

      _log('6. BEFORE importFromText');

      final summary = await actions.importFromText(utf8.decode(bytes));

      _log('7. Import success: $summary');

      _snack(_summaryText(summary));
    } catch (e, stack) {
      _log('IMPORT ERROR = $e');

      _log(stack.toString());

      _snack('Không thể nhập dữ liệu.');
    } finally {
      _log('========== IMPORT END ==========');

      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  String _summaryText(ImportSummary s) {
    var text = 'Đã khôi phục ${s.progressItems} mục tiến độ';

    if (s.favorites != null) {
      text += ', ${s.favorites} mục yêu thích';
    }

    if (s.skipped > 0) {
      text += ' (bỏ qua ${s.skipped} mục không hợp lệ)';
    }

    return '$text.';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.06),

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: Colors.blue.withValues(alpha: 0.15)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Bảo vệ tiến độ học',

            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,

            child: FilledButton.icon(
              icon: const Icon(Icons.upload_file),

              label: Text(_busy ? 'Đang xử lý...' : 'Xuất backup'),

              onPressed: _busy ? null : _export,
            ),
          ),

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,

            child: OutlinedButton.icon(
              icon: const Icon(Icons.download),

              label: const Text('Khôi phục backup'),

              onPressed: _busy ? null : _import,
            ),
          ),
        ],
      ),
    );
  }
}
