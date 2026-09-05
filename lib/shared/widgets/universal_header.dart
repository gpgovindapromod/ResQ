import 'package:flutter/material.dart';
import '../../core/routes/app_router.dart';
import '../../core/services/language_service.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';

class UniversalHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final bool showBackButton;
  final List<Widget>? actions;

  const UniversalHeader({
    super.key,
    this.title,
    this.titleWidget,
    this.showBackButton = true,
    this.actions,
  });

  void _showNotificationsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Emergency Broadcasts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: AppColors.getTextSecondary(context)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Divider(color: AppColors.getBorder(context)),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.getErrorBg(context),
                child: Icon(Icons.warning, color: AppColors.getError(context)),
              ),
              title: Text(
                'Flood Warning - Kollam Sector 4',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
              subtitle: Text(
                'Water levels rising near river basin. Evacuate to high ground.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.getTextSecondary(context),
                ),
              ),
              trailing: Text(
                '10m ago',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.getTextSecondary(context),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRouter.map);
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.getInfoBg(context),
                child: Icon(Icons.night_shelter, color: AppColors.getInfo(context)),
              ),
              title: Text(
                'Shelter Opened: Govt High School',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
              subtitle: Text(
                'Capacity: 120/400. Food and medical aid available.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.getTextSecondary(context),
                ),
              ),
              trailing: Text(
                '1h ago',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.getTextSecondary(context),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRouter.shelters);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.getSurface(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          AppLocalizations.of(context).translate('select_language'),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.getTextPrimary(context),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: LanguageService.supportedLanguages.map((lang) {
            final isSelected = LanguageService.instance.currentLanguageCode == lang['code'];
            return ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              tileColor: isSelected ? AppColors.getPrimary(context).withValues(alpha: 0.12) : null,
              title: Text(
                lang['native']!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.getPrimary(context) : AppColors.getTextPrimary(context),
                ),
              ),
              subtitle: Text(
                lang['name']!,
                style: TextStyle(color: AppColors.getTextSecondary(context)),
              ),
              trailing: isSelected
                  ? Icon(Icons.check_circle, color: AppColors.getPrimary(context))
                  : null,
              onTap: () {
                LanguageService.instance.setLanguage(lang['code']!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final headerBg = title != null
        ? AppColors.getSurface(context)
        : AppColors.getBackground(context);
    final iconColor = AppColors.getPrimary(context);
    final borderColor = AppColors.getBorder(context);

    if (titleWidget != null) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.getSurface(context),
          border: Border(bottom: BorderSide(color: borderColor, width: 1)),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                if (showBackButton && Navigator.canPop(context))
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: iconColor,
                    ),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                if (showBackButton && Navigator.canPop(context))
                  const SizedBox(width: 16),
                Expanded(child: titleWidget!),
                ...(actions ?? [
                  IconButton(
                    icon: Icon(
                      Icons.translate,
                      color: AppColors.getTextSecondary(context),
                      size: 24,
                    ),
                    tooltip: 'Language',
                    onPressed: () => _showLanguageDialog(context),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: AppColors.getTextSecondary(context),
                      size: 26,
                    ),
                    onPressed: () => _showNotificationsModal(context),
                  ),
                ]),
              ],
            ),
          ),
        ),
      );
    }

    return AppBar(
      backgroundColor: headerBg,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: borderColor, height: 1.0),
      ),
      leading: showBackButton && Navigator.canPop(context)
          ? IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: iconColor,
              ),
              onPressed: () => Navigator.pop(context),
            )
          : IconButton(
              icon: Icon(
                Icons.location_on,
                color: iconColor,
                size: 28,
              ),
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.map);
              },
            ),
      centerTitle: true,
      title: Text(
        title ?? 'ResQ',
        style: TextStyle(
          color: AppColors.getTextPrimary(context),
          fontSize: title != null ? 18 : 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: actions ??
          [
            IconButton(
              icon: Icon(
                Icons.translate,
                color: AppColors.getTextSecondary(context),
                size: 24,
              ),
              tooltip: 'Language',
              onPressed: () => _showLanguageDialog(context),
            ),
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: AppColors.getTextSecondary(context),
                size: 26,
              ),
              onPressed: () => _showNotificationsModal(context),
            ),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}


