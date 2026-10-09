import 'package:flutter/material.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';

class MethodSelectorWidget extends StatelessWidget {
  const MethodSelectorWidget({
    super.key,
    required this.availableMethods,
    required this.selected,
    required this.onChanged,
  });

  final List<LearnMethod> availableMethods;
  final LearnMethod? selected;
  final ValueChanged<LearnMethod> onChanged;

  String _label(LearnMethod method) {
    switch (method) {
      case LearnMethod.hanviet:
        return 'Hán Việt';
      case LearnMethod.meaning:
        return 'Nghĩa';
      case LearnMethod.reading:
        return 'Cách đọc';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Phương pháp học', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        RadioGroup<LearnMethod>(
          groupValue: selected,
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
          child: Column(
            children: availableMethods
                .map(
                  (method) => RadioListTile<LearnMethod>(
                    value: method,
                    title: Text(_label(method)),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
