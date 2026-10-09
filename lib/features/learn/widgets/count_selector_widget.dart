import 'package:flutter/material.dart';

class CountSelectorWidget extends StatelessWidget {
  const CountSelectorWidget({
    super.key,
    required this.total,
    required this.selectedCount,
    required this.onChanged,
  });

  final int total;
  final int selectedCount;
  final ValueChanged<int> onChanged;

  List<int> _options() {
    final values = <int>{10, 20, 50};

    values.removeWhere((e) => e > total);

    if (total > 0) {
      values.add(total);
    }

    final result = values.toList()..sort();

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final options = _options();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Số lượng câu', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: options.map((count) {
            return ChoiceChip(
              label: Text(count == total ? 'Tất cả' : '$count'),
              selected: selectedCount == count,
              onSelected: (_) => onChanged(count),
            );
          }).toList(),
        ),
      ],
    );
  }
}
