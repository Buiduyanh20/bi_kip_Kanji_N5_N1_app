import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/providers/app_state.dart';
import 'package:bikip_kanji_app/data/repositories/providers.dart';
import '../../../data/models/app_settings.dart';
import '../providers/quiz_controller.dart';
import '../screens/quiz_play_screen.dart';
import '../widgets/count_selector_widget.dart';
import '../widgets/method_selector_widget.dart';

class QuizConfigScreen extends ConsumerStatefulWidget {
  const QuizConfigScreen({
    super.key,
    required this.contentType,
    required this.level,
  });

  final ContentType contentType;
  final JlptLevel level;

  @override
  ConsumerState<QuizConfigScreen> createState() => _QuizConfigScreenState();
}

class _QuizConfigScreenState extends ConsumerState<QuizConfigScreen> {
  LearnMethod? _method;
  int? _count;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final repo = ref.read(contentRepositoryProvider);

      final methods = repo.availableMethods(widget.contentType, widget.level);

      final total = repo.countByLevel(widget.contentType, widget.level);

      setState(() {
        _method = methods.firstOrNull;
        _count = total;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(contentRepositoryProvider);

    final settings = ref.watch(settingsProvider);

    final methods = repo.availableMethods(widget.contentType, widget.level);

    final total = repo.countByLevel(widget.contentType, widget.level);

    _method ??= methods.contains(settings.lastMethod)
        ? settings.lastMethod
        : methods.first;

    _count ??= total;

    return Scaffold(
      appBar: AppBar(title: Text(widget.level.code)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            MethodSelectorWidget(
              availableMethods: methods,
              selected: _method,
              onChanged: (value) {
                setState(() {
                  _method = value;
                });
              },
            ),
            const SizedBox(height: 24),
            CountSelectorWidget(
              total: total,
              selectedCount: _count!,
              onChanged: (value) {
                setState(() {
                  _count = value;
                });
              },
            ),
            const Spacer(),
            FilledButton(
              onPressed: () async {
                if (_method == null || _count == null) return;

                ref
                    .read(quizControllerProvider.notifier)
                    .start(
                      contentType: widget.contentType,
                      level: widget.level,
                      method: _method!,
                      count: _count!,
                    );

                // Convert int → CountChoice
                final countChoice = (_count == total)
                    ? const CountChoice.all()
                    : CountChoice.of(_count!);

                await ref
                    .read(settingsProvider.notifier)
                    .setLastLearningOptions(_method!, countChoice);

                if (!context.mounted) return;

                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const QuizPlayScreen()),
                );
              },
              child: const Text('Bắt đầu học'),
            ),
          ],
        ),
      ),
    );
  }
}
