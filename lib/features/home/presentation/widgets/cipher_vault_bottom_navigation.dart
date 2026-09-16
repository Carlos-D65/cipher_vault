import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class CipherVaultBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const CipherVaultBottomNavigation({
    super.key,
    required this.currentIndex,
  });

  void _navigate(
    BuildContext context,
    int index,
  ) {
    if (index == currentIndex) {
      return;
    }

    final String route;

    switch (index) {
      case 0:
        route = '/';
        break;

      case 1:
        route = '/protect';
        break;

      case 2:
        route = '/decrypt';
        break;

      case 3:
        route = '/hide';
        break;

      default:
        return;
    }

    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: const BoxDecoration(
        color: AppColors.navigation,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _NavigationItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: 'Inicio',
              selected: currentIndex == 0,
              onTap: () => _navigate(context, 0),
            ),
            _NavigationItem(
              icon: Icons.shield_outlined,
              activeIcon: Icons.shield,
              label: 'Proteger',
              selected: currentIndex == 1,
              onTap: () => _navigate(context, 1),
            ),
            _NavigationItem(
              icon: Icons.lock_outline,
              activeIcon: Icons.lock,
              label: 'Descifrar',
              selected: currentIndex == 2,
              onTap: () => _navigate(context, 2),
            ),
            _NavigationItem(
              icon: Icons.visibility_off_outlined,
              activeIcon: Icons.visibility_off,
              label: 'Ocultar',
              selected: currentIndex == 3,
              onTap: () => _navigate(context, 3),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? AppColors.cyan
        : AppColors.subtle;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? activeIcon : icon,
              color: color,
              size: 17,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 7.5,
                fontWeight: selected
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}