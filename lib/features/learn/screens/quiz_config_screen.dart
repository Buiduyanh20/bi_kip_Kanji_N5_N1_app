import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/providers/app_state.dart';
import 'package:bikip_kanji_app/data/repositories/providers.dart';
import '../../../data/models/app_settings.dart';
import '../providers/quiz_controller.dart';
import '../screens/quiz_play_screen.dart';
import '../widgets/count_selector_widget.dart';
import '../widgets/custom_count_sheet.dart';
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
      appBar: AppBar(
        centerTitle: false,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              widget.level.code,

              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),

            const Text(
              'Thiết lập buổi học',

              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            // Header nhỏ
            Text(
              'Chọn cách học phù hợp với bạn',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.15)),
              ),

              child: MethodSelectorWidget(
                availableMethods: methods,
                selected: _method,

                onChanged: (value) {
                  setState(() {
                    _method = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Số lượng muốn học',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.withValues(alpha: 0.15)),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  CountSelectorWidget(
                    total: total,
                    selectedCount: _count!,
                    onChanged: (value) {
                      setState(() {
                        _count = value;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,

                    children: [

                      if (![10, 20, 50, total].contains(_count))
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),

                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),

                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: Row(
                            children: [

                              const Icon(
                                Icons.edit_note,
                                size: 20,
                                color: Colors.blue,
                              ),


                              const SizedBox(width: 8),


                              Text(
                                'Đã chọn $_count chữ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),

                            ],
                          ),
                        ),



                      OutlinedButton.icon(

                        icon: const Icon(
                          Icons.edit,
                        ),


                        label: const Text(
                          'Tùy chỉnh số lượng',
                        ),


                        onPressed: () async {


                          final value =
                          await showCustomCountSheet(
                            context,
                            maxCount: total,
                          );


                          if (value != null) {

                            setState(() {

                              _count = value;

                            });

                          }

                        },

                      ),

                    ],
                  )
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              height: 52,

              child: FilledButton(
                onPressed: () async {
                  if (_method == null || _count == null) {
                    return;
                  }

                  ref
                      .read(quizControllerProvider.notifier)
                      .start(
                        contentType: widget.contentType,

                        level: widget.level,

                        method: _method!,

                        count: _count!,
                      );

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

                child: const Text(
                  'Bắt đầu học',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
