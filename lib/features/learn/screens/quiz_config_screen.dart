import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bikip_kanji_app/app/router.dart';
import 'package:bikip_kanji_app/data/models/app_settings.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/providers/app_state.dart';
import 'package:bikip_kanji_app/data/repositories/providers.dart';
import '../providers/quiz_controller.dart';
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
  static const double _maxWidth = 672;

  late final List<LearnMethod> _methods;
  late final int _total;
  LearnMethod? _method;
  late int _count;

  @override
  void initState() {
    super.initState();
    final repo = ref.read(contentRepositoryProvider);
    final settings = ref.read(settingsProvider);

    _methods = repo.availableMethods(widget.contentType, widget.level);
    _total = repo.countByLevel(widget.contentType, widget.level);

    // Giống web: nhớ lastMethod nếu còn dùng được, không thì phương pháp đầu.
    _method = _methods.contains(settings.lastMethod)
        ? settings.lastMethod
        : _methods.firstOrNull;

    final last = settings.lastCount;
    _count = (last == null || last.isAll || last.count! > _total)
        ? _total
        : last.count!;
  }

  Future<void> _start() async {
    final method = _method;
    if (method == null || _count < 1) return;

    final started = ref.read(quizControllerProvider.notifier).start(
      contentType: widget.contentType,
      level: widget.level,
      method: method,
      count: _count,
    );
    if (!started) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tạo được phiên học.')),
      );
      return;
    }

    unawaited(
      ref.read(settingsProvider.notifier).setLastLearningOptions(
        method,
        _count == _total
            ? const CountChoice.all()
            : CountChoice.of(_count),
      ),
    );

    // Thay config bằng quiz: back từ quiz về thẳng danh sách cấp độ.
    context.pushReplacement(AppRoutes.quizPlayOf(widget.contentType.name));
  }

  @override
  Widget build(BuildContext context) {
    final isCustom = ![10, 20, 50, _total].contains(_count);

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
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontal = constraints.maxWidth < 360 ? 12.0 : 16.0;

                if (_methods.isEmpty || _total == 0) {
                  return const Center(
                    child: Text('Cấp độ này chưa có nội dung.'),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding:
                        EdgeInsets.fromLTRB(horizontal, 8, horizontal, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Chọn cách học phù hợp với bạn',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.blue.withValues(alpha: 0.15),
                                ),
                              ),
                              child: MethodSelectorWidget(
                                availableMethods: _methods,
                                selected: _method,
                                onChanged: (value) =>
                                    setState(() => _method = value),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Số lượng muốn học',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.green.withValues(alpha: 0.15),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  CountSelectorWidget(
                                    total: _total,
                                    selectedCount: _count,
                                    onChanged: (value) =>
                                        setState(() => _count = value),
                                  ),
                                  const SizedBox(height: 12),
                                  if (isCustom)
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                        Colors.blue.withValues(alpha: 0.08),
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
                                    icon: const Icon(Icons.edit),
                                    label: const Text('Tùy chỉnh số lượng'),
                                    onPressed: () async {
                                      final value = await showCustomCountSheet(
                                        context,
                                        maxCount: _total,
                                      );
                                      if (value != null) {
                                        setState(() => _count = value);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 12),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton(
                          onPressed: _method == null ? null : _start,
                          child: const Text(
                            'Bắt đầu học',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
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