import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/navigation/navigation_provider.dart';
import '../../../app/theme/app_colors.dart';

class _TabItem {
  final String label;
  final IconData icon;
  final IconData iconActive;

  const _TabItem({
    required this.label,
    required this.icon,
    required this.iconActive,
  });
}

const _tabs = [
  _TabItem(
    label: 'Trang chủ',
    icon: Icons.home_outlined,
    iconActive: Icons.home_rounded,
  ),
  _TabItem(
    label: 'Ôn tập',
    icon: Icons.replay_outlined,
    iconActive: Icons.replay_rounded,
  ),
  _TabItem(
    label: 'Yêu thích',
    icon: Icons.favorite_border_rounded,
    iconActive: Icons.favorite_rounded,
  ),
  _TabItem(
    label: 'Tiến độ',
    icon: Icons.bar_chart_outlined,
    iconActive: Icons.bar_chart_rounded,
  ),
  _TabItem(
    label: 'Cài đặt',
    icon: Icons.settings_outlined,
    iconActive: Icons.settings_rounded,
  ),
];

class MainShellScreen extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellScreen({super.key, required this.navigationShell});

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(navigationShellProvider.notifier).state = widget.navigationShell;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: widget.navigationShell,

      bottomNavigationBar: _BottomNav(
        currentIndex: widget.navigationShell.currentIndex,

        onTap: (index) {
          widget.navigationShell.goBranch(
            index,

            initialLocation: index == widget.navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(
              _tabs.length,
              (i) => Expanded(
                child: _NavItem(
                  tab: _tabs[i],
                  isActive: currentIndex == i,
                  onTap: () => onTap(i),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final _TabItem tab;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.tab,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: 40,
            height: 28,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: Icon(
                  isActive ? tab.iconActive : tab.icon,
                  key: ValueKey(isActive),
                  size: 20,
                  color: isActive ? AppColors.primary : AppColors.navInactive,
                ),
              ),
            ),
          ),
          const SizedBox(height: 3),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              color: isActive ? AppColors.primary : AppColors.navInactive,
              height: 1,
            ),
            child: Text(tab.label),
          ),
        ],
      ),
    );
  }
}
