import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/localization/app_localizations.dart';

class ActionGridWidget extends StatelessWidget {
  final Color cardBgColor;
  final Color primaryTextColor;
  final AppLocalizations loc;

  const ActionGridWidget({
    super.key,
    required this.cardBgColor,
    required this.primaryTextColor,
    required this.loc,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.getPrimary(context);
    final onPrimaryColor = AppColors.getOnPrimary(context);
    final errorColor = AppColors.getError(context);
    final onErrorColor = AppColors.getOnError(context);
    final borderColor = AppColors.getBorder(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              ActionGridItem(
                title: loc.translate('view_risk_map'),
                icon: Icons.map_outlined,
                backgroundColor: primaryColor,
                textColor: onPrimaryColor,
                iconColor: onPrimaryColor,
                borderColor: null,
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRouter.map);
                },
              ),
              const SizedBox(height: 14),
              ActionGridItem(
                title: loc.translate('report_incident'),
                icon: Icons.cell_tower,
                backgroundColor: errorColor,
                textColor: onErrorColor,
                iconColor: onErrorColor,
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRouter.report);
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            children: [
              ActionGridItem(
                title: loc.translate('find_shelter'),
                icon: Icons.location_on_outlined,
                backgroundColor: cardBgColor,
                textColor: primaryTextColor,
                iconColor: primaryColor,
                hasBorder: true,
                borderColor: borderColor,
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRouter.shelters);
                },
              ),
              const SizedBox(height: 14),
              ActionGridItem(
                title: loc.translate('emergency_contacts'),
                icon: Icons.contact_phone_outlined,
                backgroundColor: cardBgColor,
                textColor: primaryTextColor,
                iconColor: primaryColor,
                hasBorder: true,
                borderColor: borderColor,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: AppColors.getSurface(context),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.translate('emergency_hotlines'),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.getTextPrimary(context),
                            ),
                          ),
                          Divider(color: AppColors.getBorder(context)),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.getErrorBg(context),
                              child: Icon(Icons.phone_in_talk, color: AppColors.getError(context)),
                            ),
                            title: Text(
                              loc.translate('disaster_control'),
                              style: TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor),
                            ),
                            subtitle: Text(AppLocalizations.of(context).translate('1077_91_474_2794002'),
                              style: TextStyle(color: AppColors.getTextSecondary(context)),
                            ),
                            trailing: Icon(Icons.call, color: primaryColor),
                            onTap: () => Navigator.pop(context),
                          ),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.getInfoBg(context),
                              child: Icon(Icons.local_hospital, color: AppColors.getInfo(context)),
                            ),
                            title: Text(
                              loc.translate('ambulance_rescue'),
                              style: TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor),
                            ),
                            subtitle: Text(AppLocalizations.of(context).translate('108_toll_free'),
                              style: TextStyle(color: AppColors.getTextSecondary(context)),
                            ),
                            trailing: Icon(Icons.call, color: primaryColor),
                            onTap: () => Navigator.pop(context),
                          ),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.getWarningBg(context),
                              child: Icon(Icons.local_fire_department, color: AppColors.getWarning(context)),
                            ),
                            title: Text(
                              loc.translate('fire_force'),
                              style: TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor),
                            ),
                            subtitle: Text(AppLocalizations.of(context).translate('101'),
                              style: TextStyle(color: AppColors.getTextSecondary(context)),
                            ),
                            trailing: Icon(Icons.call, color: primaryColor),
                            onTap: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ActionGridItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final bool hasBorder;
  final Color? borderColor;
  final VoidCallback onTap;

  const ActionGridItem({
    super.key,
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    this.hasBorder = false,
    this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: title,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 130,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: hasBorder || borderColor != null ? Border.all(color: borderColor ?? AppColors.getBorder(context)) : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
