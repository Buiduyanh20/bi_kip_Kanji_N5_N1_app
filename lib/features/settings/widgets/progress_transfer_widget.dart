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

/// Sao lưu và khôi phục hành trình học.
class ProgressTransferWidget extends ConsumerStatefulWidget {
  const ProgressTransferWidget({super.key});

  @override
  ConsumerState<ProgressTransferWidget> createState() =>
      _ProgressTransferWidgetState();
}

class _ProgressTransferWidgetState
    extends ConsumerState<ProgressTransferWidget> {
  bool _busy = false;

  void _snack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _alert(String message) => showDialog<void>(
    context: context,

    builder: (ctx) => AlertDialog(
      title: const Text('Thông báo'),

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

    setState(() {
      _busy = true;
    });

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
      if (mounted) {
        _snack('Không thể xuất dữ liệu.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  Future<void> _import() async {
    if (_busy) return;

    final actions = ref.read(backupActionsProvider);

    setState(() {
      _busy = true;
    });

    try {
      final picked = await FilePicker.platform.pickFiles(
        type: FileType.custom,

        allowedExtensions: const ['json'],

        withData: true,
      );

      if (picked == null || picked.files.isEmpty) {
        return;
      }

      final file = picked.files.single;

      final bytes =
          file.bytes ??
          (file.path == null ? null : await File(file.path!).readAsBytes());

      if (bytes == null) {
        throw const FormatException('Không đọc được tệp.');
      }

      final summary = await actions.importFromText(utf8.decode(bytes));

      if (mounted) {
        _showImportSuccess(summary);
      }
    } on BackupFormatException catch (e) {
      if (mounted) {
        await _alert(e.message);
      }
    } on FormatException {
      if (mounted) {
        await _alert(_invalidFile);
      }
    } catch (_) {
      if (mounted) {
        _snack('Không thể nhập dữ liệu.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  void _showImportSuccess(ImportSummary summary) {
    _snack(_summaryText(summary));
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.12),

                  borderRadius: BorderRadius.circular(12),
                ),

                child: const Icon(Icons.cloud_outlined, color: Colors.blue),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  'Bảo vệ tiến độ học',

                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            'Lưu lại Kanji đã học, lịch sử quiz '
            'và danh sách ôn tập của bạn.',

            style: TextStyle(color: AppColors.textHint, height: 1.4),
          ),

          const SizedBox(height: 12),

          const _InfoRow(icon: Icons.devices, text: 'Không cần tài khoản'),

          const _InfoRow(
            icon: Icons.lock_outline,

            text: 'Dữ liệu được lưu trên thiết bị',
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,

            child: FilledButton.icon(
              icon: _busy
                  ? const SizedBox(
                      width: 18,

                      height: 18,

                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.upload_file),

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

class _InfoRow extends StatelessWidget {
  final IconData icon;

  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),

      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),

          const SizedBox(width: 8),

          Text(text, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
