import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../room/presentation/room_screen.dart';
import '../../network/presentation/network_screen.dart';
import '../../connections/presentation/connections_screen.dart';
import '../../upskill/presentation/upskill_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';

class MainShell extends HookConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = useState(0);

    // Every user gets the same five tabs — the party is open to everyone.
    const tabs = [
      RoomScreen(),
      NetworkScreen(),
      ConnectionsScreen(),
      UpskillScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: tab.value,
        children: tabs,
      ),
      bottomNavigationBar: _NavBar(
        selected: tab.value,
        onTap: (i) => tab.value = i,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Navigation bar
// ─────────────────────────────────────────────────────────

const _navItems = [
  _NavItem(icon: Icons.celebration_rounded,   label: 'Room'),
  _NavItem(icon: Icons.forum_rounded,          label: 'Community'),
  _NavItem(icon: Icons.handshake_rounded,      label: 'Connections'),
  _NavItem(icon: Icons.auto_graph_rounded,     label: 'Grow'),
  _NavItem(icon: Icons.person_rounded,         label: 'Profile'),
];

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class _NavBar extends StatelessWidget {
  const _NavBar({required this.selected, required this.onTap});
  final int selected;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.card, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: _navItems.asMap().entries.map((e) {
              final i = e.key;
              final item = e.value;
              final active = i == selected;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.primary.withValues(alpha: 0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            item.icon,
                            size: 22,
                            color: active
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: AppTextStyles.label.copyWith(
                            color: active
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            fontWeight: active
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
