import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../profile_controller.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileController controller;
  final bool isDark;

  const ProfileHeader({super.key, required this.controller, required this.isDark});

  void _showEditProfileModal(BuildContext context) {
    final nameController = TextEditingController(text: controller.name);
    final roleController = TextEditingController(text: controller.role);
    final locationController = TextEditingController(text: controller.location);
    final primaryColor = AppColors.getPrimary(context);
    final onPrimaryColor = AppColors.getOnPrimary(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.getSurface(context),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context).translate('edit_profile'),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              style: TextStyle(color: AppColors.getTextPrimary(context)),
              decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: roleController,
              style: TextStyle(color: AppColors.getTextPrimary(context)),
              decoration: const InputDecoration(labelText: 'Role', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: locationController,
              style: TextStyle(color: AppColors.getTextPrimary(context)),
              decoration: const InputDecoration(labelText: 'Location', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  controller.updateProfile(
                    nameController.text,
                    roleController.text,
                    locationController.text,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context).translate('profile_updated')),
                      backgroundColor: primaryColor,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: onPrimaryColor,
                ),
                child: Text(AppLocalizations.of(context).translate('save_changes'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardBgColor = AppColors.getCardBackground(context);
    final primaryTextColor = AppColors.getTextPrimary(context);
    final secondaryTextColor = AppColors.getTextSecondary(context);
    final borderColor = AppColors.getBorder(context);
    final primaryColor = AppColors.getPrimary(context);
    final avatarBgColor = primaryColor.withValues(alpha: 0.1);
    final badgeBgColor = primaryColor.withValues(alpha: 0.1);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: avatarBgColor,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Icon(
              Icons.person,
              size: 38,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor),
                ),
                const SizedBox(height: 2),
                Text(
                  controller.role,
                  style: TextStyle(fontSize: 14, color: secondaryTextColor),
                ),
                const SizedBox(height: 2),
                Text(
                  controller.location,
                  style: TextStyle(fontSize: 13, color: secondaryTextColor),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeBgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        AppLocalizations.of(context).translate('active_status'),
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: primaryColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit_outlined, color: primaryColor),
            onPressed: () => _showEditProfileModal(context),
          )
        ],
      ),
    );
  }
}
