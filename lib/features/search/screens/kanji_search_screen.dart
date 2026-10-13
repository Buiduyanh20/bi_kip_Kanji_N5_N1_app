import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../providers/kanji_search_provider.dart';

import '../widgets/kanji_search_bar.dart';
import '../widgets/kanji_search_result_card.dart';
import '../widgets/kanji_detail_preview.dart';
import '../widgets/kanji_empty_state.dart';

class KanjiSearchScreen extends ConsumerStatefulWidget {
  const KanjiSearchScreen({super.key});

  @override
  ConsumerState<KanjiSearchScreen> createState() => _KanjiSearchScreenState();
}

class _KanjiSearchScreenState extends ConsumerState<KanjiSearchScreen> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(kanjiSearchProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              '🔍 Tra Kanji',

              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
          ],
        ),

        elevation: 0,

        backgroundColor: Colors.transparent,

        foregroundColor: Colors.black87,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            KanjiSearchBar(
              controller: controller,

              onChanged: ref.read(kanjiSearchProvider.notifier).search,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: state.results.isNotEmpty
                  ? ListView.builder(
                      itemCount: state.results.length,

                      itemBuilder: (_, index) {
                        final item = state.results[index];

                        return KanjiSearchResultCard(
                          kanji: item,

                          onTap: () {
                            context.push(AppRoutes.kanjiDetailOf(item.id));
                          },
                        );
                      },
                    )
                  : const KanjiEmptyState(),
            ),
          ],
        ),
      ),
    );
  }
}
