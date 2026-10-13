import 'package:flutter/material.dart';

class KanjiSearchBar extends StatelessWidget {
  const KanjiSearchBar({
    super.key,

    required this.controller,

    required this.onChanged,
  });

  final TextEditingController controller;

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,

      onChanged: onChanged,

      decoration: InputDecoration(
        hintText: 'Nhập Kanji, Hán Việt, nghĩa...',

        prefixIcon: const Icon(Icons.search),

        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.clear),

                onPressed: () {
                  controller.clear();

                  onChanged('');
                },
              ),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
