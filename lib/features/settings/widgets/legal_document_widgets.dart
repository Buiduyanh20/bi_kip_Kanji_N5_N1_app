import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bikip_kanji_app/app/theme/app_colors.dart';

const String kLegalAppName = 'Bí Kíp Kanji';
const String kLegalSlogan =
    'Người Việt học Kanji dễ hơn bằng âm Hán Việt và mẹo ghi nhớ';
const String kLegalContactEmail = 'info.buiduyanh@gmail.com';
const String kLegalLastUpdated = 'June 2026';

/// Khung chung của một tài liệu pháp lý.
class LegalDocumentPage extends StatelessWidget {
  const LegalDocumentPage({
    super.key,
    required this.appBarTitle,
    required this.titleEn,
    required this.titleVi,
    required this.sections,
  });

  final String appBarTitle;
  final String titleEn;
  final String titleVi;
  final List<Widget> sections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle)),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LegalHeader(titleEn: titleEn, titleVi: titleVi),
                  for (final section in sections) ...[
                    const SizedBox(height: 16),
                    section,
                  ],
                  const SizedBox(height: 24),
                  const Text(
                    '$kLegalAppName v1.0.0',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppColors.textHint),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LegalHeader extends StatelessWidget {
  const LegalHeader({super.key, required this.titleEn, required this.titleVi});

  final String titleEn;
  final String titleVi;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const ExcludeSemantics(
                child: Text(
                  '漢',
                  locale: Locale('ja', 'JP'),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  kLegalAppName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            kLegalSlogan,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            titleEn,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            titleVi,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Last Updated / Cập nhật lần cuối: $kLegalLastUpdated',
            style: TextStyle(fontSize: 13, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}

/// Một mục đánh số, nằm trong thẻ bo tròn.
class LegalSection extends StatelessWidget {
  const LegalSection({
    super.key,
    required this.number,
    required this.titleEn,
    required this.titleVi,
    required this.children,
  });

  final int number;
  final String titleEn;
  final String titleVi;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$number',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleEn,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      titleVi,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          for (final child in children) ...[const SizedBox(height: 12), child],
        ],
      ),
    );
  }
}

/// Đoạn văn song ngữ: dòng Anh đậm hơn, dòng Việt nhạt hơn bên dưới.
class LegalParagraph extends StatelessWidget {
  const LegalParagraph({super.key, required this.en, required this.vi});

  final String en;
  final String vi;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          en,
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          vi,
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Danh sách gạch đầu dòng song ngữ: mỗi phần tử là (English, Tiếng Việt).
class LegalBullets extends StatelessWidget {
  const LegalBullets({super.key, required this.items});

  final List<(String, String)> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 8, right: 12),
                  child: Icon(Icons.circle, size: 6, color: AppColors.primary),
                ),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: item.$1,
                          style: const TextStyle(color: AppColors.textPrimary),
                        ),
                        TextSpan(
                          text: ' / ${item.$2}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Dòng email liên hệ, có nút sao chép (không cần thêm package).
class LegalContact extends StatelessWidget {
  const LegalContact({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.mail_outline, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          const Expanded(
            child: SelectableText(
              kLegalContactEmail,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            tooltip: 'Sao chép email',
            icon: const Icon(Icons.copy_rounded, size: 20),
            onPressed: () async {
              await Clipboard.setData(
                const ClipboardData(text: kLegalContactEmail),
              );
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã sao chép email.')),
              );
            },
          ),
        ],
      ),
    );
  }
}
