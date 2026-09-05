import 'package:flutter/material.dart';
import '../../core/routes/app_router.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';

class UniversalNavBar extends StatelessWidget {
  final int currentIndex;

  const UniversalNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final navBgColor = AppColors.getNavBarBg(context);

    return Semantics(
      label: 'Bottom Navigation Bar',
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: navBgColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 16,
              offset: const Offset(0, 6),
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
            selectedItemColor: AppColors.getNavBarSelected(context),
            unselectedItemColor: AppColors.getTextSecondary(context),
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: const Icon(Icons.home_rounded),
                label: loc.translate('home'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.map_outlined),
                activeIcon: const Icon(Icons.map_rounded),
                label: loc.translate('map'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.location_on_outlined),
                activeIcon: const Icon(Icons.location_on),
                label: loc.translate('shelters'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.cell_tower),
                activeIcon: const Icon(Icons.cell_tower),
                label: loc.translate('report'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                activeIcon: const Icon(Icons.person_rounded),
                label: loc.translate('profile'),
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
      ),
    );
  }
}
