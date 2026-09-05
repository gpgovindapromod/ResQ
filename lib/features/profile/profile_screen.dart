import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/universal_nav_bar.dart';
import '../../shared/widgets/universal_header.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/theme_service.dart';
import '../../core/services/language_service.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/routes/app_router.dart';
import 'widgets/settings_group_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Alex Mercer';
  String _role = 'Field Volunteer';
  String _location = 'Kollam, India';
  bool _offlineData = true;
  bool _emergencyAlerts = true;
  bool _nearbyAlerts = true;
  bool _shelterUpdates = true;
  bool _locationSharing = true;

  void _showLanguageDialog() {
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
                setState(() {});
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showEditProfileModal() {
    final nameController = TextEditingController(text: _name);
    final roleController = TextEditingController(text: _role);
    final locationController = TextEditingController(text: _location);
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
            Text(
              'Edit Profile',
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
                  setState(() {
                    _name = nameController.text;
                    _role = roleController.text;
                    _location = locationController.text;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Profile updated successfully!'),
                      backgroundColor: primaryColor,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: onPrimaryColor,
                ),
                child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoModal(String title, String description, {List<Widget>? extraActions}) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context)),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: AppColors.getTextSecondary(context)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Divider(color: AppColors.getBorder(context)),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: AppColors.getTextSecondary(context), height: 1.4),
            ),
            const SizedBox(height: 20),
            ...?extraActions,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    final currentLangName = LanguageService.supportedLanguages.firstWhere(
      (l) => l['code'] == LanguageService.instance.currentLanguageCode,
      orElse: () => LanguageService.supportedLanguages.first,
    )['native'];
    final primaryColor = AppColors.getPrimary(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: UniversalHeader(
        title: loc.translate('profile'),
        showBackButton: false,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: primaryColor,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileCard(isDark),
                const SizedBox(height: 28),
                _buildSectionTitle(loc.translate('emergency_safety')),
                const SizedBox(height: 12),
                SettingsGroupCard(isDark: isDark, items: [
                  SettingsItem(
                    icon: Icons.group_add_outlined,
                    title: 'Emergency Contacts',
                    subtitle: '3 saved contacts',
                    onTap: () => _showInfoModal(
                      'Emergency Contacts',
                      '1. Disaster Control Room (+91 474 2794002)\n2. Primary Relative (+91 98470 12345)\n3. Local Volunteer Group (+91 94471 67890)',
                    ),
                  ),
                  SettingsItem(
                    icon: Icons.warning_amber_outlined,
                    title: 'Emergency Alert Preferences',
                    subtitle: 'High & Moderate alerts enabled',
                    onTap: () => _showInfoModal(
                      'Alert Preferences',
                      'You are set to receive Push Broadcasts and SMS Alerts for High Risk events (Floods, Landslides, Coastal Surges).',
                    ),
                  ),
                  SettingsItem(
                    icon: Icons.share_location_outlined,
                    title: loc.translate('location_sharing'),
                    hasSwitch: true,
                    switchValue: _locationSharing,
                    onChanged: (val) => setState(() => _locationSharing = val),
                  ),
                  SettingsItem(
                    icon: Icons.medical_information_outlined,
                    title: 'Medical / Accessibility Info',
                    subtitle: 'Blood Group O+, No Allergies',
                    onTap: () => _showInfoModal(
                      'Medical & Accessibility Profile',
                      'Blood Group: O+\nAllergies: None Recorded\nSpecial Equipment: Standard First Aid Kit',
                    ),
                  ),
                ]),
                const SizedBox(height: 28),
                _buildSectionTitle(loc.translate('app_offline_access')),
                const SizedBox(height: 12),
                SettingsGroupCard(isDark: isDark, items: [
                  SettingsItem(
                    icon: Icons.translate,
                    title: loc.translate('language'),
                    subtitle: currentLangName,
                    onTap: _showLanguageDialog,
                  ),
                  SettingsItem(
                    icon: ThemeService.instance.isDarkMode ? Icons.dark_mode : Icons.light_mode_outlined,
                    title: loc.translate('dark_mode'),
                    subtitle: ThemeService.instance.isDarkMode ? 'Dark theme active' : 'Light theme active',
                    hasSwitch: true,
                    switchValue: ThemeService.instance.isDarkMode,
                    onChanged: (val) {
                      ThemeService.instance.toggleTheme(val);
                      setState(() {});
                    },
                  ),
                  SettingsItem(
                    icon: Icons.offline_pin_outlined, 
                    title: 'Offline Data', 
                    subtitle: _offlineData ? 'Active & Synced' : 'Disabled',
                    hasSwitch: true, 
                    switchValue: _offlineData, 
                    onChanged: (val) => setState(() => _offlineData = val),
                  ),
                  SettingsItem(
                    icon: Icons.download_done_outlined,
                    title: 'Downloaded Emergency Info',
                    subtitle: '12 MB cached',
                    onTap: () => _showInfoModal(
                      'Downloaded Packets',
                      'Cached Content:\n- Kollam Emergency Shelter Index\n- First Aid Manual PDF\n- Local Hotline Directory',
                    ),
                  ),
                  SettingsItem(
                    icon: Icons.map_outlined,
                    title: 'Offline Maps',
                    subtitle: 'Kollam Region (Offline)',
                    onTap: () {
                      Navigator.pushNamed(context, AppRouter.map);
                    },
                  ),
                  SettingsItem(
                    icon: Icons.data_usage_outlined,
                    title: 'Data Usage',
                    subtitle: 'Low Data Mode Disabled',
                    onTap: () => _showInfoModal(
                      'Data Usage Options',
                      'ResQ automatically compresses tile maps and emergency images to minimize network usage during low-connectivity scenarios.',
                    ),
                  ),
                ]),
                const SizedBox(height: 28),
                _buildSectionTitle('NOTIFICATIONS'),
                const SizedBox(height: 12),
                SettingsGroupCard(isDark: isDark, items: [
                  SettingsItem(
                    icon: Icons.campaign_outlined,
                    title: 'Emergency Alerts',
                    hasSwitch: true,
                    switchValue: _emergencyAlerts,
                    onChanged: (val) => setState(() => _emergencyAlerts = val),
                  ),
                  SettingsItem(
                    icon: Icons.notifications_active_outlined,
                    title: 'Nearby Incident Alerts',
                    hasSwitch: true,
                    switchValue: _nearbyAlerts,
                    onChanged: (val) => setState(() => _nearbyAlerts = val),
                  ),
                  SettingsItem(
                    icon: Icons.night_shelter_outlined,
                    title: 'Shelter Updates',
                    hasSwitch: true,
                    switchValue: _shelterUpdates,
                    onChanged: (val) => setState(() => _shelterUpdates = val),
                  ),
                ]),
                const SizedBox(height: 28),
                _buildSectionTitle('SUPPORT'),
                const SizedBox(height: 12),
                SettingsGroupCard(isDark: isDark, items: [
                  SettingsItem(
                    icon: Icons.help_outline,
                    title: 'Help & Feedback',
                    onTap: () => _showInfoModal(
                      'Help & Support',
                      'Need help using ResQ?\nContact Support Hotline: 1077 (Toll-Free)\nEmail: support@resq.gov.in',
                    ),
                  ),
                  SettingsItem(
                    icon: Icons.info_outline,
                    title: 'About ResQ',
                    subtitle: 'v2.4.1 (Build 108)',
                    onTap: () => _showInfoModal(
                      'About ResQ Platform',
                      'ResQ - Emergency Response & Disaster Assistance Platform.\nBuilt for rapid dispatch, shelter finding, and offline emergency navigation.',
                    ),
                  ),
                ]),
                const SizedBox(height: 28),
                _buildLogoutButton(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const UniversalNavBar(currentIndex: 4),
    );
  }

  Widget _buildProfileCard(bool isDark) {
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
                  _name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor),
                ),
                const SizedBox(height: 2),
                Text(
                  _role,
                  style: TextStyle(fontSize: 14, color: secondaryTextColor),
                ),
                const SizedBox(height: 2),
                Text(
                  _location,
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
                        'Active Status',
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
            onPressed: _showEditProfileModal,
          )
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.getTextSecondary(context),
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildLogoutButton() {
    final errorColor = AppColors.getError(context);
    final onErrorColor = AppColors.getOnError(context);

    return OutlinedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.getSurface(context),
            title: Text('Confirm Logout', style: TextStyle(color: AppColors.getTextPrimary(context))),
            content: Text('Are you sure you want to log out of ResQ?', style: TextStyle(color: AppColors.getTextSecondary(context))),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: AppColors.getTextSecondary(context))),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await AuthService.setLoggedIn(false);
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(context, AppRouter.auth, (route) => false);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: errorColor,
                  foregroundColor: onErrorColor,
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
        );
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: errorColor,
        side: BorderSide(color: errorColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        minimumSize: const Size(double.infinity, 48),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout, size: 20),
          SizedBox(width: 8),
          Text('Logout', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
