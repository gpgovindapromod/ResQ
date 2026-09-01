import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/universal_nav_bar.dart';
import '../../shared/widgets/universal_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: UniversalHeader(
        title: 'Profile',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: AppColors.primary, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileCard(),
                const SizedBox(height: 32),
                _buildSectionTitle('EMERGENCY & SAFETY'),
                const SizedBox(height: 12),
                _buildSettingsCard([
                  _SettingsItem(icon: Icons.group_add_outlined, title: 'Emergency Contacts', onTap: () {}),
                  _SettingsItem(icon: Icons.warning_amber_outlined, title: 'Emergency Alert Preferences', onTap: () {}),
                  _SettingsItem(icon: Icons.share_location_outlined, title: 'Location Sharing', onTap: () {}),
                  _SettingsItem(icon: Icons.medical_information_outlined, title: 'Medical / Accessibility Info', onTap: () {}),
                ]),
                const SizedBox(height: 32),
                _buildSectionTitle('APP & OFFLINE ACCESS'),
                const SizedBox(height: 12),
                _buildSettingsCard([
                  _SettingsItem(
                    icon: Icons.offline_pin_outlined, 
                    title: 'Offline Data', 
                    subtitle: 'Available',
                    hasSwitch: true, 
                    switchValue: true, 
                    onChanged: (v) {}
                  ),
                  _SettingsItem(icon: Icons.download_done_outlined, title: 'Downloaded Emergency Info', onTap: () {}),
                  _SettingsItem(icon: Icons.map_outlined, title: 'Offline Maps', onTap: () {}),
                  _SettingsItem(icon: Icons.data_usage_outlined, title: 'Data Usage', onTap: () {}),
                ]),
                const SizedBox(height: 32),
                _buildSectionTitle('NOTIFICATIONS'),
                const SizedBox(height: 12),
                _buildSettingsCard([
                  _SettingsItem(icon: Icons.campaign_outlined, title: 'Emergency Alerts', onTap: () {}),
                  _SettingsItem(icon: Icons.notifications_active_outlined, title: 'Nearby Incident Alerts', onTap: () {}),
                  _SettingsItem(icon: Icons.night_shelter_outlined, title: 'Shelter Updates', onTap: () {}),
                ]),
                const SizedBox(height: 32),
                _buildSectionTitle('SUPPORT'),
                const SizedBox(height: 12),
                _buildSettingsCard([
                  _SettingsItem(icon: Icons.help_outline, title: 'Help & Feedback', onTap: () {}),
                  _SettingsItem(icon: Icons.info_outline, title: 'About ResQ', onTap: () {}),
                ]),
                const SizedBox(height: 32),
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

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 2),
              image: const DecorationImage(
                image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuC3gBt9ft3oWrOMZjemt8LGouvhCBuTxcerlkdt8djrd4ty8ggQO6aN8KpHHuhFE7a7SSPEGJ4TWYM2QxQO6W95Cv-Vo_sGjjNf748NegWPgUnYQO11cdAxwQCAUjxabOqkD6J7NXAbiydg-a1SZ0KSxRTsXpGiWcTgb3IJrqQ7G9dFfrscVJ1aDzZqzfC_Bno6t0DMawS8gj3acbSWYRmii3HUb2RISok3SHtKmav9zaBakpsfhgvsjA'),
                fit: BoxFit.cover,
              )
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Alex Mercer',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Field Volunteer',
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Kollam, India',
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Active Status',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildSettingsCard(List<_SettingsItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(item.icon, color: AppColors.textPrimary, size: 20),
                  ),
                  title: Text(
                    item.title,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  subtitle: item.subtitle != null
                      ? Text(
                          item.subtitle!,
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        )
                      : null,
                  trailing: item.hasSwitch
                      ? Switch(
                          value: item.switchValue,
                          onChanged: item.onChanged,
                          activeThumbColor: AppColors.primary,
                        )
                      : const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
                  onTap: item.hasSwitch ? null : item.onTap,
                ),
              ),
              if (index < items.length - 1)
                const Divider(height: 1, color: AppColors.border, indent: 60),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFDC2626),
        side: const BorderSide(color: Color(0xFFDC2626)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout, size: 20),
          SizedBox(width: 8),
          Text('Logout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool hasSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onChanged;

  _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.hasSwitch = false,
    this.switchValue = false,
    this.onChanged,
  });
}
