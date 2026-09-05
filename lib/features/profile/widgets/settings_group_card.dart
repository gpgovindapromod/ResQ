import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SettingsItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool hasSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onChanged;

  SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.hasSwitch = false,
    this.switchValue = false,
    this.onChanged,
  });
}

class SettingsGroupCard extends StatelessWidget {
  final List<SettingsItem> items;
  final bool isDark;

  const SettingsGroupCard({
    super.key,
    required this.items,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final cardBgColor = AppColors.getCardBackground(context);
    final borderColor = AppColors.getBorder(context);
    final primaryTextColor = AppColors.getTextPrimary(context);
    final secondaryTextColor = AppColors.getTextSecondary(context);
    final iconBgColor = AppColors.getSurface(context);
    final primaryColor = AppColors.getPrimary(context);

    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          return Column(
            children: [
              Material(
                color: Colors.transparent,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(item.icon, color: primaryColor, size: 20),
                  ),
                  title: Text(
                    item.title,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primaryTextColor),
                  ),
                  subtitle: item.subtitle != null
                      ? Text(
                          item.subtitle!,
                          style: TextStyle(fontSize: 12, color: secondaryTextColor),
                        )
                      : null,
                  trailing: item.hasSwitch
                      ? Switch(
                          value: item.switchValue,
                          onChanged: item.onChanged,
                          activeThumbColor: primaryColor,
                        )
                      : Icon(Icons.chevron_right, color: secondaryTextColor, size: 20),
                  onTap: item.hasSwitch ? null : item.onTap,
                ),
              ),
              if (index < items.length - 1)
                Divider(height: 1, color: borderColor, indent: 60),
            ],
          );
        }),
      ),
    );
  }
}
