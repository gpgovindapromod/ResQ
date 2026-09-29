import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';

class LocationSelectorCard extends StatelessWidget {
  final LatLng? currentPosition;
  final String locationName;
  final bool isLoadingLocation;
  final VoidCallback onUpdateLocation;
  final bool isDark;

  const LocationSelectorCard({
    super.key,
    required this.currentPosition,
    required this.locationName,
    required this.isLoadingLocation,
    required this.onUpdateLocation,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final cardBgColor = AppColors.getCardBackground(context);
    final borderColor = AppColors.getBorder(context);
    final primaryTextColor = AppColors.getTextPrimary(context);
    final secondaryTextColor = AppColors.getTextSecondary(context);
    final primaryColor = AppColors.getPrimary(context);
    final errorColor = AppColors.getError(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05), blurRadius: 4, offset: const Offset(0, 1))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context).translate('current_location'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primaryTextColor)),
              GestureDetector(
                onTap: onUpdateLocation,
                child: Row(
                  children: [
                    Icon(Icons.my_location, size: 16, color: primaryColor),
                    const SizedBox(width: 4),
                    Text(AppLocalizations.of(context).translate('update'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primaryColor)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.getSurface(context),
              border: Border.all(color: borderColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: isLoadingLocation 
              ? Center(child: CircularProgressIndicator(color: primaryColor))
              : currentPosition == null
                ? Center(child: Text(AppLocalizations.of(context).translate('could_not_load_map'), style: TextStyle(color: secondaryTextColor)))
                : FlutterMap(
                    options: MapOptions(
                      initialCenter: currentPosition!,
                      initialZoom: 15.0,
                      interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.resq',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: currentPosition!,
                            width: 40,
                            height: 40,
                            child: Icon(Icons.location_on, color: errorColor, size: 40),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.pin_drop_outlined, size: 18, color: secondaryTextColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  locationName,
                  style: TextStyle(fontSize: 14, color: secondaryTextColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
