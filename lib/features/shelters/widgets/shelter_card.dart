import 'package:flutter/material.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../shelter_details_screen.dart';

class ShelterModel {
  final String name;
  final String status;
  final Color statusColor;
  final String distance;
  final int currentCapacity;
  final int maxCapacity;
  final List<Map<String, dynamic>> amenities;

  ShelterModel({
    required this.name,
    required this.status,
    required this.statusColor,
    required this.distance,
    required this.currentCapacity,
    required this.maxCapacity,
    required this.amenities,
  });
}

class ShelterCard extends StatelessWidget {
  final ShelterModel shelter;

  const ShelterCard({super.key, required this.shelter});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBgColor = AppColors.getCardBackground(context);
    final footerBgColor = AppColors.getSurface(context);
    final primaryTextColor = AppColors.getTextPrimary(context);
    final secondaryTextColor = AppColors.getTextSecondary(context);
    final borderColor = AppColors.getBorder(context);
    final primaryColor = AppColors.getPrimary(context);
    final onPrimaryColor = AppColors.getOnPrimary(context);
    final double capacityPercent = shelter.currentCapacity / shelter.maxCapacity;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: shelter.statusColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        shelter.name,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryTextColor),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: shelter.statusColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        shelter.status,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: shelter.statusColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 16, color: secondaryTextColor),
                    const SizedBox(width: 4),
                    Text(
                      '${shelter.distance} ${AppLocalizations.of(context).translate('away')}',
                      style: TextStyle(fontSize: 14, color: secondaryTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context).translate('capacity'), style: TextStyle(fontSize: 13, color: secondaryTextColor)),
                    Text('${shelter.currentCapacity} / ${shelter.maxCapacity}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: primaryTextColor)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: capacityPercent,
                    backgroundColor: borderColor,
                    valueColor: AlwaysStoppedAnimation<Color>(shelter.statusColor),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: shelter.amenities.map((amenity) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: footerBgColor,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: borderColor, width: 0.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(amenity['icon'] as IconData, size: 14, color: secondaryTextColor),
                          const SizedBox(width: 4),
                          Text(
                            amenity['label'] as String,
                            style: TextStyle(fontSize: 12, color: secondaryTextColor, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: footerBgColor,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              border: Border(top: BorderSide(color: borderColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShelterDetailsScreen(shelter: shelter),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(foregroundColor: primaryColor),
                  child: Text(AppLocalizations.of(context).translate('view_details'), style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.map);
                  },
                  icon: const Icon(Icons.directions, size: 18),
                  label: Text(AppLocalizations.of(context).translate('directions'), style: const TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: onPrimaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


