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

const _invalidFile = 'Tệp tiến độ không hợp lệ.'; // đúng chữ của web

/// Port của `ProgressTransfer.tsx`.
class ProgressTransferWidget extends ConsumerStatefulWidget {
  const ProgressTransferWidget({super.key});

  @override
  ConsumerState<ProgressTransferWidget> createState() =>
      _ProgressTransferWidgetState();
}

class _ProgressTransferWidgetState
    extends ConsumerState<ProgressTransferWidget> {
  bool _busy = false;

  void _snack(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));

  /// Tương đương `window.alert`.
  Future<void> _alert(String message) => showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );

  Future<void> _export() async {
    if (_busy) return;
    final actions = ref.read(backupActionsProvider);
    setState(() => _busy = true);
    try {
      final file = await actions.exportToFile();
      await Share.shareXFiles([
        XFile(
          file.path,
          mimeType: 'application/json',
          name: BackupRepository.fileName,
        ),
      ]);
    } catch (_) {
      if (mounted) _snack('Không thể xuất dữ liệu.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import() async {
    if (_busy) return;
    final actions = ref.read(backupActionsProvider);
    setState(() => _busy = true);
    try {
      final picked = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['json'],
        withData: true,
      );
      if (picked == null || picked.files.isEmpty) return; // người dùng hủy

      final file = picked.files.single;
      final bytes =
          file.bytes ??
          (file.path == null ? null : await File(file.path!).readAsBytes());
      if (bytes == null) throw const FormatException('Không đọc được tệp.');

      final summary = await actions.importFromText(utf8.decode(bytes));
      if (mounted) _snack(_summaryText(summary));
    } on BackupFormatException catch (e) {
      if (mounted) await _alert(e.message);
    } on FormatException {
      if (mounted) await _alert(_invalidFile);
    } catch (_) {
      if (mounted) _snack('Không thể nhập dữ liệu.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _summaryText(ImportSummary s) {
    var text = 'Đã nhập ${s.progressItems} mục tiến độ';
    if (s.favorites != null) text += ', ${s.favorites} mục yêu thích';
    if (s.skipped > 0) text += ' (bỏ qua ${s.skipped} mục không hợp lệ)';
    return '$text.';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Sao lưu tiến độ',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            'Xuất tiến độ để lưu trữ hoặc nhập lại trên thiết bị khác.',
            style: TextStyle(fontSize: 14, color: AppColors.textHint),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: _busy ? null : _export,
              child: const Text('Xuất dữ liệu'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: _busy ? null : _import,
              child: const Text('Nhập dữ liệu'),
            ),
          ),
        ],
      ),
    );
  }
}
