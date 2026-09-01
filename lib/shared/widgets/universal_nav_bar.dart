import 'package:flutter/material.dart';
import '../../core/routes/app_router.dart';
import '../../core/theme/app_colors.dart';

class UniversalNavBar extends StatelessWidget {
  final int currentIndex;

  const UniversalNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              activeIcon: Icon(Icons.map_rounded),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined),
              activeIcon: Icon(Icons.location_on),
              label: 'Shelters',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cell_tower),
              activeIcon: Icon(Icons.cell_tower),
              label: 'Report',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
          onTap: (index) {
            if (index == currentIndex) return;
            if (index == 0) {
              Navigator.pushReplacementNamed(context, AppRouter.home);
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, AppRouter.map);
            } else if (index == 2) {
              Navigator.pushReplacementNamed(context, AppRouter.shelters);
            } else if (index == 3) {
              Navigator.pushReplacementNamed(context, AppRouter.report);
            } else if (index == 4) {
              Navigator.pushReplacementNamed(context, AppRouter.profile);
            }
          },
        ),
      ),
    );
  }
}
