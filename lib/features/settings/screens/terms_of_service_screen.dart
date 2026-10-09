import 'package:flutter/material.dart';

import 'package:bikip_kanji_app/features/settings/widgets/legal_document_widgets.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentPage(
      appBarTitle: 'Điều khoản sử dụng',
      titleEn: 'Terms of Service',
      titleVi: 'Điều Khoản Sử Dụng',
      sections: [
        LegalSection(
          number: 1,
          titleEn: 'Educational Purpose',
          titleVi: 'Mục Đích Giáo Dục',
          children: [
            LegalParagraph(
              en: 'Bí Kíp Kanji is an educational application designed to help Vietnamese users learn Japanese Kanji and vocabulary.',
              vi: 'Bí Kíp Kanji là ứng dụng giáo dục giúp người Việt học Kanji và từ vựng tiếng Nhật.',
            ),
          ],
        ),
        LegalSection(
          number: 2,
          titleEn: 'User Responsibilities',
          titleVi: 'Trách Nhiệm Của Người Dùng',
          children: [
            LegalParagraph(
              en: 'Users are responsible for using the application appropriately.',
              vi: 'Người dùng có trách nhiệm sử dụng ứng dụng một cách phù hợp.',
            ),
          ],
        ),
        LegalSection(
          number: 3,
          titleEn: 'Content Accuracy',
          titleVi: 'Độ Chính Xác Của Nội Dung',
          children: [
            LegalParagraph(
              en: 'The application provides learning materials for educational purposes.',
              vi: 'Ứng dụng cung cấp tài liệu học tập với mục đích giáo dục.',
            ),
            LegalParagraph(
              en: 'We try to maintain accuracy but cannot guarantee all content is error-free.',
              vi: 'Chúng tôi cố gắng đảm bảo độ chính xác nhưng không thể cam kết mọi nội dung đều không có sai sót.',
            ),
          ],
        ),
        LegalSection(
          number: 4,
          titleEn: 'Intellectual Property',
          titleVi: 'Quyền Sở Hữu Trí Tuệ',
          children: [
            LegalParagraph(
              en: 'Application design, features and original content belong to Bí Kíp Kanji unless otherwise stated.',
              vi: 'Thiết kế, tính năng và nội dung gốc của ứng dụng thuộc về Bí Kíp Kanji, trừ khi có ghi chú khác.',
            ),
          ],
        ),
        LegalSection(
          number: 5,
          titleEn: 'Service Changes',
          titleVi: 'Thay Đổi Dịch Vụ',
          children: [
            LegalParagraph(
              en: 'Future versions may update or modify features.',
              vi: 'Các phiên bản sau có thể cập nhật hoặc thay đổi tính năng.',
            ),
          ],
        ),
        LegalSection(
          number: 6,
          titleEn: 'Data Responsibility',
          titleVi: 'Trách Nhiệm Về Dữ Liệu',
          children: [
            LegalParagraph(
              en: 'Because Version 1.0.0 stores data locally, users are responsible for keeping backup files if needed.',
              vi: 'Vì phiên bản 1.0.0 lưu dữ liệu cục bộ, người dùng tự chịu trách nhiệm giữ tệp sao lưu khi cần.',
            ),
          ],
        ),
        LegalSection(
          number: 7,
          titleEn: 'Limitation of Liability',
          titleVi: 'Giới Hạn Trách Nhiệm',
          children: [
            LegalParagraph(
              en: 'Bí Kíp Kanji is provided for educational purposes.',
              vi: 'Bí Kíp Kanji được cung cấp với mục đích giáo dục.',
            ),
            LegalParagraph(
              en: 'The application is not responsible for learning results or indirect damages.',
              vi: 'Ứng dụng không chịu trách nhiệm về kết quả học tập hoặc các thiệt hại gián tiếp.',
            ),
          ],
        ),
        LegalSection(
          number: 8,
          titleEn: 'Contact',
          titleVi: 'Liên Hệ',
          children: [LegalContact()],
        ),
      ],
    );
  }
}
