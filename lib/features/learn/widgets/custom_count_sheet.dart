import 'package:flutter/material.dart';

Future<int?> showCustomCountSheet(
  BuildContext context, {
  required int maxCount,
}) {
  return showModalBottomSheet<int>(
    context: context,

    isScrollControlled: true,

    showDragHandle: true,

    builder: (_) {
      return _CustomCountSheet(maxCount: maxCount);
    },
  );
}

class _CustomCountSheet extends StatefulWidget {
  const _CustomCountSheet({required this.maxCount});

  final int maxCount;

  @override
  State<_CustomCountSheet> createState() => _CustomCountSheetState();
}

class _CustomCountSheetState extends State<_CustomCountSheet> {
  final controller = TextEditingController(text: '10');

  String? error;

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 24, keyboard + 24),

      child: Column(
        mainAxisSize: MainAxisSize.min,

        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          const Text(
            '✨ Mục tiêu hôm nay',

            textAlign: TextAlign.center,

            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),

          const SizedBox(height: 8),

          Text(
            'Chọn số lượng Kanji muốn học',

            textAlign: TextAlign.center,

            style: TextStyle(color: Colors.grey[600]),
          ),

          const SizedBox(height: 24),

          TextField(
            controller: controller,

            autofocus: true,

            textAlign: TextAlign.center,

            keyboardType: TextInputType.number,

            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),

            decoration: InputDecoration(
              suffixText: ' chữ',

              errorText: error,

              filled: true,

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Bạn đang có ${widget.maxCount} mục trong cấp độ này',

            textAlign: TextAlign.center,

            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),

          const SizedBox(height: 20),

          Wrap(
            alignment: WrapAlignment.center,

            spacing: 10,

            children: [
              for (final value in [10, 20, 50])
                ActionChip(
                  label: Text('$value'),

                  onPressed: () {
                    controller.text = value.toString();
                  },
                ),
            ],
          ),

          const SizedBox(height: 20),

          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(0, 52)),

            onPressed: _submit,

            child: const Text(
              'Bắt đầu học',

              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    final value = int.tryParse(controller.text);

    if (value == null || value <= 0) {
      setState(() {
        error = 'Nhập số lượng hợp lệ';
      });

      return;
    }

    if (value > widget.maxCount) {
      setState(() {
        error = 'Chỉ có ${widget.maxCount} mục trong cấp độ này';
      });

      return;
    }

    Navigator.pop(context, value);
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }
}
