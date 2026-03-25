import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// MD3 NavigationBar used as the persistent bottom navigation.
/// Pass [currentIndex] and [onTap] from the parent scaffold state.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<_NavItem> _items = [
    _NavItem(
      label: 'Inicio',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    _NavItem(
      label: 'Reportes',
      icon: Icons.article_outlined,
      activeIcon: Icons.article_rounded,
    ),
    _NavItem(
      label: 'Mapa',
      icon: Icons.map_outlined,
      activeIcon: Icons.map_rounded,
    ),
    _NavItem(
      label: 'Perfil',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.infoLight,
      surfaceTintColor: Colors.transparent,
      elevation: 4,
      shadowColor: AppColors.shadow,
      height: 68,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: _items
          .map(
            (item) => NavigationDestination(
              icon: Icon(item.icon, color: AppColors.textDisabled),
              selectedIcon: Icon(item.activeIcon, color: AppColors.primary),
              label: item.label,
            ),
          )
          .toList(),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}
