import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bikip_kanji_app/app/router.dart';
import 'package:bikip_kanji_app/app/theme/app_colors.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/providers/app_state.dart';
import 'package:bikip_kanji_app/data/repositories/providers.dart';
import 'package:bikip_kanji_app/features/favorite/providers/favorite_entries_provider.dart';
import 'package:bikip_kanji_app/features/favorite/widgets/favorite_card_widget.dart';
import 'package:bikip_kanji_app/features/favorite/widgets/favorite_empty_state_widget.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  static const double _maxWidth = 672;

  final TextEditingController _search = TextEditingController();
  JlptLevel? _level; // null = Tất cả

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _remove(FavoriteEntry entry) async {
    final repo = ref.read(favoriteRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    await repo.remove(entry.kanji.id);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Đã bỏ yêu thích ${entry.kanji.char}'),
          action: SnackBarAction(
            label: 'Hoàn tác',
            onPressed: () => repo.toggle(entry.kanji.id, entry.kanji.level),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final loaded = ref.watch(favoritesProvider).hasValue;
    final all = ref.watch(favoriteEntriesProvider);
    final filtered = filterFavoriteEntries(
      all,
      level: _level,
      query: _search.text,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yêu thích'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.favorite,
                        size: 16, color: AppColors.error),
                    const SizedBox(width: 4),
                    Text(
                      '${all.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontal = constraints.maxWidth < 360 ? 12.0 : 16.0;

                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 0),
                      child: TextField(
                        controller: _search,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Tìm Kanji, Hán Việt, nghĩa...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _search.text.isEmpty
                              ? null
                              : IconButton(
                            tooltip: 'Xóa',
                            icon: const Icon(Icons.close),
                            onPressed: () => setState(_search.clear),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding:
                      EdgeInsets.fromLTRB(horizontal, 12, horizontal, 8),
                      child: Row(
                        spacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('Tất cả'),
                            selected: _level == null,
                            showCheckmark: false,
                            onSelected: (_) => setState(() => _level = null),
                          ),
                          for (final lv in JlptLevel.values)
                            ChoiceChip(
                              label: Text(lv.code),
                              selected: _level == lv,
                              showCheckmark: false,
                              onSelected: (_) => setState(() => _level = lv),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: !loaded
                          ? const Center(child: CircularProgressIndicator())
                          : filtered.isEmpty
                          ? FavoriteEmptyStateWidget(
                        noFavorites: all.isEmpty,
                      )
                          : ListView.separated(
                        padding: EdgeInsets.fromLTRB(
                          horizontal,
                          8,
                          horizontal,
                          16,
                        ),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) =>
                        const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final e = filtered[i];
                          return FavoriteCardWidget(
                            key: ValueKey(e.kanji.id),
                            entry: e,
                            onTap: () => context.push(
                              AppRoutes.kanjiDetailOf(e.kanji.id),
                            ),
                            onRemove: () => _remove(e),
                          );
                        },
                      ),
                    ),
                    // Quiz từ Yêu thích — hướng mở rộng v2
                    Padding(
                      padding:
                      EdgeInsets.fromLTRB(horizontal, 8, horizontal, 12),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton.icon(
                          onPressed: null,
                          icon: const Icon(Icons.quiz_outlined),
                          label: Text(
                            'Làm quiz từ Yêu thích (${all.length}) · sắp có',
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}