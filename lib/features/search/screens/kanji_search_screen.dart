import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../providers/kanji_search_provider.dart';
import '../widgets/kanji_search_bar.dart';
import '../widgets/kanji_search_result_card.dart';
import '../widgets/kanji_empty_state.dart';

class KanjiSearchScreen extends ConsumerStatefulWidget {
  const KanjiSearchScreen({super.key});

  @override
  ConsumerState<KanjiSearchScreen> createState() => _KanjiSearchScreenState();
}

class _KanjiSearchScreenState extends ConsumerState<KanjiSearchScreen> {
  static const double _maxWidth = 672;

  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(kanjiSearchProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          '🔍 Tra Kanji',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontal = constraints.maxWidth < 360 ? 12.0 : 16.0;

                return Padding(
                  padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 16),
                  child: Column(
                    children: [
                      KanjiSearchBar(
                        controller: controller,
                        onChanged:
                        ref.read(kanjiSearchProvider.notifier).search,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: state.results.isNotEmpty
                            ? ListView.builder(
                          itemCount: state.results.length,
                          itemBuilder: (_, index) {
                            final item = state.results[index];
                            return KanjiSearchResultCard(
                              kanji: item,
                              onTap: () {
                                context.push(
                                  AppRoutes.kanjiDetailOf(item.id),
                                );
                              },
                            );
                          },
                        )
                            : const KanjiEmptyState(),
                      ),
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