import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bikip_kanji_app/app/router.dart';
import 'package:bikip_kanji_app/app/theme/app_colors.dart';

/// Phiên bản hiển thị. Web cũng hardcode "v1.0.0".
const String kAppVersion = '1.0.0';

/// Khối "APP INFO": Phiên bản, Điều khoản, Quyền riêng tư và phần chân trang.
class AppInfoSectionWidget extends StatelessWidget {
  const AppInfoSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'THÔNG TIN ỨNG DỤNG',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 2,
              color: AppColors.textHint,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          color: const Color(0xFFEEF2FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFEEF2FF)),
          ),
          child: Column(
            children: [
              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Phiên bản'),
                trailing: Text(kAppVersion),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('Điều khoản sử dụng'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.termsOfService),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.shield_outlined),
                title: const Text('Chính sách quyền riêng tư'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.privacyPolicy),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Center(
          child: Column(
            children: [
              SizedBox(height: 8),
              Text(
                'Created by Bùi Duy Anh',
                style: TextStyle(fontSize: 11, color: AppColors.textHint),
              ),
              Text(
                'info.buiduyanh@gmail.com',
                style: TextStyle(fontSize: 11, color: AppColors.textHint),
              ),
              SizedBox(height: 2),
              Text(
                '© 2026 All Rights Reserved',
                style: TextStyle(fontSize: 10, color: AppColors.textHint),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
