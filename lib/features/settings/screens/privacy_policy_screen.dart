import 'package:flutter/material.dart';

import 'package:bikip_kanji_app/features/settings/widgets/legal_document_widgets.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentPage(
      appBarTitle: 'Quyền riêng tư',
      titleEn: 'Privacy Policy',
      titleVi: 'Chính Sách Quyền Riêng Tư',
      sections: [
        LegalSection(
          number: 1,
          titleEn: 'Information We Collect',
          titleVi: 'Thông Tin Chúng Tôi Thu Thập',
          children: [
            LegalParagraph(
              en: "Bí Kíp Kanji stores learning data locally on the user's device.",
              vi: 'Bí Kíp Kanji lưu dữ liệu học tập ngay trên thiết bị của người dùng.',
            ),
            LegalParagraph(
              en: 'Collected data includes:',
              vi: 'Dữ liệu được lưu gồm:',
            ),
            LegalBullets(
              items: [
                ('Learning progress', 'Tiến độ học tập'),
                ('Kanji progress', 'Tiến độ Kanji'),
                ('Vocabulary progress', 'Tiến độ từ vựng'),
                ('Quiz results', 'Kết quả quiz'),
                ('Favorite items', 'Các mục yêu thích'),
                ('Study statistics', 'Thống kê học tập'),
              ],
            ),
            LegalParagraph(
              en: 'The app does not collect personal information online.',
              vi: 'Ứng dụng không thu thập thông tin cá nhân trực tuyến.',
            ),
          ],
        ),
        LegalSection(
          number: 2,
          titleEn: 'Personal Information',
          titleVi: 'Thông Tin Cá Nhân',
          children: [
            LegalParagraph(
              en: 'The application does not require user registration.',
              vi: 'Ứng dụng không yêu cầu đăng ký tài khoản.',
            ),
            LegalParagraph(
              en: 'No collection of:',
              vi: 'Chúng tôi không thu thập:',
            ),
            LegalBullets(
              items: [
                ('Full name', 'Họ và tên'),
                ('Address', 'Địa chỉ'),
                ('Phone number', 'Số điện thoại'),
                ('Payment information', 'Thông tin thanh toán'),
              ],
            ),
          ],
        ),
        LegalSection(
          number: 3,
          titleEn: 'Data Storage',
          titleVi: 'Lưu Trữ Dữ Liệu',
          children: [
            LegalParagraph(
              en: "All Version 1.0.0 learning data is stored locally on the user's device.",
              vi: 'Toàn bộ dữ liệu học tập của phiên bản 1.0.0 được lưu cục bộ trên thiết bị của người dùng.',
            ),
            LegalParagraph(en: 'Storage:', vi: 'Nơi lưu trữ:'),
            LegalBullets(
              items: [
                ('SQLite database', 'Cơ sở dữ liệu SQLite'),
                ('Local storage', 'Bộ nhớ cục bộ'),
              ],
            ),
            LegalParagraph(
              en: 'Users own their learning data.',
              vi: 'Người dùng sở hữu dữ liệu học tập của mình.',
            ),
          ],
        ),
        LegalSection(
          number: 4,
          titleEn: 'Data Backup',
          titleVi: 'Sao Lưu Dữ Liệu',
          children: [
            LegalParagraph(
              en: 'Users can export and import their learning progress manually.',
              vi: 'Người dùng có thể tự xuất và nhập tiến độ học tập.',
            ),
            LegalParagraph(
              en: 'Version 1.0.0 does not provide cloud synchronization.',
              vi: 'Phiên bản 1.0.0 không có đồng bộ đám mây.',
            ),
          ],
        ),
        LegalSection(
          number: 5,
          titleEn: 'Third-Party Services',
          titleVi: 'Dịch Vụ Bên Thứ Ba',
          children: [
            LegalParagraph(en: 'Version 1.0.0:', vi: 'Phiên bản 1.0.0:'),
            LegalBullets(
              items: [
                ('No advertising service', 'Không có dịch vụ quảng cáo'),
                ('No cloud sync', 'Không đồng bộ đám mây'),
                ('No online tracking', 'Không theo dõi trực tuyến'),
              ],
            ),
          ],
        ),
        LegalSection(
          number: 6,
          titleEn: "Children's Privacy",
          titleVi: 'Quyền Riêng Tư Của Trẻ Em',
          children: [
            LegalParagraph(
              en: 'The application is not directed to children under 13.',
              vi: 'Ứng dụng không hướng đến trẻ em dưới 13 tuổi.',
            ),
          ],
        ),
        LegalSection(
          number: 7,
          titleEn: 'Changes to This Policy',
          titleVi: 'Thay Đổi Chính Sách',
          children: [
            LegalParagraph(
              en: 'This policy may be updated in future versions.',
              vi: 'Chính sách này có thể được cập nhật trong các phiên bản sau.',
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
