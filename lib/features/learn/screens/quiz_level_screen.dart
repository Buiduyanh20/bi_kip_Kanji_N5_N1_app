import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bikip_kanji_app/app/router.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/repositories/providers.dart';

class QuizLevelScreen extends ConsumerWidget {
  const QuizLevelScreen({super.key, required this.contentType});

  final ContentType contentType;

  static const double _maxWidth = 672;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(contentRepositoryProvider);
    final levels = repo.levelsWithContent(contentType);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          contentType == ContentType.kanji ? '📚 Học Kanji' : '📖 Học từ vựng',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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

                return ListView(
                  padding: EdgeInsets.fromLTRB(horizontal, 12, horizontal, 24),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            Colors.indigo.withValues(alpha: 0.15),
                            Colors.blue.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chọn cấp độ phù hợp để bắt đầu học.',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    for (final level in levels)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _LevelCard(
                          level: level,
                          count: repo.countByLevel(contentType, level),
                          onTap: () {
                            context.push(
                              AppRoutes.quizConfigOf(
                                contentType.name,
                                level: level.name,
                              ),
                            );
                          },
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

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.level,
    required this.count,
    required this.onTap,
  });

  final JlptLevel level;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _levelColor(level);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  level.code,
                  style: TextStyle(
                    color: color,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title(level),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$count mục học',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 0,
                        minHeight: 6,
                        backgroundColor: Colors.grey[200],
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Color _levelColor(JlptLevel level) {
    switch (level) {
      case JlptLevel.n5:
        return Colors.green;
      case JlptLevel.n4:
        return Colors.blue;
      case JlptLevel.n3:
        return Colors.purple;
      case JlptLevel.n2:
        return Colors.orange;
      case JlptLevel.n1:
        return Colors.red;
    }
  }

  String _title(JlptLevel level) {
    switch (level) {
      case JlptLevel.n5:
        return 'Nền tảng';
      case JlptLevel.n4:
        return 'Sơ cấp';
      case JlptLevel.n3:
        return 'Trung cấp';
      case JlptLevel.n2:
        return 'Thành thạo';
      case JlptLevel.n1:
        return 'Nâng cao';
    }
  }
}