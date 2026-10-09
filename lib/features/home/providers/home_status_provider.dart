import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bikip_kanji_app/core/logic/mastery.dart';
import 'package:bikip_kanji_app/data/models/content_item.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/progress.dart';
import 'package:bikip_kanji_app/data/providers/app_state.dart';
import 'package:bikip_kanji_app/data/repositories/providers.dart';

/// Web (HomeStatus.tsx) cố định N5, và N4 là level kế tiếp.
const JlptLevel kHomeLevel = JlptLevel.n5;
const JlptLevel kHomeNextLevel = JlptLevel.n4;

enum HomeStage { notStarted, inProgress, completed }

class HomeStatusData {
  const HomeStatusData({
    required this.stage,
    required this.studied,
    required this.total,
    required this.mastered,
    required this.learning,
    required this.reviewCount,
  });

  final HomeStage stage;
  final int studied;
  final int total;
  final int mastered;
  final int learning;
  final int reviewCount;
}

/// Port nguyên văn phần tính toán của `HomeStatusContent`.
HomeStatusData computeHomeStatus({
  required List<ContentItem> content,
  required List<LearnMethod> methods,
  required Map<String, ItemProgress> progress,
}) {
  final contentIds = {for (final i in content) i.id};

  final studied = content
      .where((i) => progress[i.id]?.methods.isNotEmpty ?? false)
      .toList();

  final reviewCount = getMistakes(progress)
      .where(
        (m) => m.type == ContentType.kanji && contentIds.contains(m.itemId),
      )
      .map((m) => m.itemId)
      .toSet()
      .length;

  final mastered = content
      .where((i) => isItemMastered(i, methods, progress))
      .length;
  final learning = studied
      .where((i) => !isItemMastered(i, methods, progress))
      .length;

  final HomeStage stage;
  if (studied.isEmpty) {
    stage = HomeStage.notStarted;
  } else if (studied.length == content.length) {
    stage = HomeStage.completed;
  } else {
    stage = HomeStage.inProgress;
  }

  return HomeStatusData(
    stage: stage,
    studied: studied.length,
    total: content.length,
    mastered: mastered,
    learning: learning,
    reviewCount: reviewCount,
  );
}

final homeStatusProvider = Provider<HomeStatusData>((ref) {
  final content = ref.watch(contentRepositoryProvider);
  final progress = ref.watch(progressProvider);
  return computeHomeStatus(
    content: content.itemsByLevel(ContentType.kanji, kHomeLevel),
    methods: content.availableMethods(ContentType.kanji, kHomeLevel),
    progress: progress,
  );
});
