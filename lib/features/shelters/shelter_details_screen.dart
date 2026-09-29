import 'package:flutter/material.dart';
import 'widgets/shelter_card.dart';
import '../../shared/widgets/universal_header.dart';
import '../../shared/widgets/universal_nav_bar.dart';
import '../../core/routes/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class ShelterDetailsScreen extends StatelessWidget {
  final ShelterModel shelter;

  const ShelterDetailsScreen({super.key, required this.shelter});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBgColor = AppColors.getCardBackground(context);
    final primaryTextColor = AppColors.getTextPrimary(context);
    final secondaryTextColor = AppColors.getTextSecondary(context);
    final borderColor = AppColors.getBorder(context);
    final primaryColor = AppColors.getPrimary(context);
    final onPrimaryColor = AppColors.getOnPrimary(context);
    final errorColor = AppColors.getError(context);
    final errorBg = AppColors.getErrorBg(context);
    final warningColor = AppColors.getWarning(context);
    final warningBg = AppColors.getWarningBg(context);
    final double capacityPercent = shelter.currentCapacity / shelter.maxCapacity;
    final int capacityPercentInt = (capacityPercent * 100).round();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: UniversalHeader(
        title: AppLocalizations.of(context).translate('shelter_details'),
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: primaryColor),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${AppLocalizations.of(context).translate('shelter_details_copied')}"${shelter.name}"${AppLocalizations.of(context).translate('copied_to_clipboard')}'),
                  backgroundColor: AppColors.getSurface(context),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/shelter.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                shelter.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: primaryTextColor, letterSpacing: -0.01),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 16, color: secondaryTextColor),
                  const SizedBox(width: 4),
                  Text(
                    AppLocalizations.of(context).translate('sample_address'),
                    style: TextStyle(fontSize: 14, color: secondaryTextColor),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 48,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.map);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: onPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.directions, size: 20),
                      const SizedBox(width: 8),
                      Text(AppLocalizations.of(context).translate('get_directions'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildCardContainer(
                cardBgColor: cardBgColor,
                borderColor: borderColor,
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context).translate('occupancy_status'), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: primaryTextColor, height: 1.2)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: warningBg,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            AppLocalizations.of(context).translate('filling_fast'),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: warningColor, height: 1.2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('$capacityPercentInt%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: primaryTextColor)),
                        Text('${shelter.currentCapacity} / ${shelter.maxCapacity} ${AppLocalizations.of(context).translate('beds')}', style: TextStyle(fontSize: 14, color: secondaryTextColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(9999),
                      child: LinearProgressIndicator(
                        value: capacityPercent,
                        backgroundColor: borderColor,
                        valueColor: AlwaysStoppedAnimation<Color>(errorColor),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildCardContainer(
                cardBgColor: cardBgColor,
                borderColor: borderColor,
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context).translate('available_facilities'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: primaryTextColor)),
                    const SizedBox(height: 16),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        final items = [
                          {'icon': Icons.restaurant, 'label': AppLocalizations.of(context).translate('food')},
                          {'icon': Icons.water_drop, 'label': AppLocalizations.of(context).translate('water')},
                          {'icon': Icons.medical_services, 'label': AppLocalizations.of(context).translate('medical')},
                          {'icon': Icons.wc, 'label': AppLocalizations.of(context).translate('restrooms')},
                          {'icon': Icons.power, 'label': AppLocalizations.of(context).translate('power')},
                          {'icon': Icons.wifi, 'label': AppLocalizations.of(context).translate('wifi')},
                        ];
                        return _buildFacilityBox(context, items[index]['label'] as String, items[index]['icon'] as IconData);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildCardContainer(
                cardBgColor: cardBgColor,
                borderColor: borderColor,
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context).translate('contact_info'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: primaryTextColor)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.phone_outlined, size: 20, color: secondaryTextColor),
                        const SizedBox(width: 12),
                        Text(AppLocalizations.of(context).translate('sample_phone'), style: TextStyle(fontSize: 14, color: primaryTextColor, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.access_time, size: 20, color: secondaryTextColor),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context).translate('intake_time'), style: TextStyle(fontSize: 14, color: primaryTextColor, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 4),
                            Text(AppLocalizations.of(context).translate('door_lock_time'), style: TextStyle(fontSize: 12, color: secondaryTextColor)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: errorBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: errorColor, size: 20),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context).translate('critical_alert'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: errorColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context).translate('shelter_critical_alert'),
                      style: TextStyle(fontSize: 14, color: errorColor, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                     BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05), blurRadius: 4, offset: const Offset(0, 1))
                  ]
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 120,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.getSurface(context),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/map_bg.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Center(
                            child: Icon(Icons.map_outlined, color: secondaryTextColor, size: 32),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRouter.map);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: errorColor,
                            foregroundColor: AppColors.getOnError(context),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.navigation, size: 20),
                              const SizedBox(width: 8),
                              Text(AppLocalizations.of(context).translate('navigate_now'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 88),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const UniversalNavBar(currentIndex: 2),
    );
  }

  Widget _buildCardContainer({required Widget child, required Color cardBgColor, required Color borderColor, required bool isDark}) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
           BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03), blurRadius: 8, offset: const Offset(0, 2))
        ]
      ),
      child: child,
    );
  }

  Widget _buildFacilityBox(BuildContext context, String label, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.getBorder(context)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: AppColors.getPrimary(context)),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.getTextPrimary(context)),
          ),
        ],
      ),
    );
  }
}


