import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/universal_header.dart';
import '../../shared/widgets/universal_nav_bar.dart';
import '../../core/localization/app_localizations.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng _currentLocation = const LatLng(8.8932, 76.6141); // Default to Kollam
  bool _isLoadingLocation = true;
  bool _locationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) setState(() => _isLoadingLocation = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) setState(() => _isLoadingLocation = false);
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      if (mounted) setState(() => _isLoadingLocation = false);
      return;
    } 

    if (mounted) {
      setState(() {
        _locationPermissionGranted = true;
      });
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _isLoadingLocation = false;
        });
        _mapController.move(_currentLocation, 14.0);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  void _showLayerOptions() {
    final primaryColor = AppColors.getPrimary(context);
    final infoColor = AppColors.getInfo(context);
    final successColor = AppColors.getSuccess(context);

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
              AppLocalizations.of(context).translate('map_layers_overlays'),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
            ),
            Divider(color: AppColors.getBorder(context)),
            ListTile(
              leading: Icon(Icons.map, color: primaryColor),
              title: Text(AppLocalizations.of(context).translate('standard_topo_map'), style: TextStyle(color: AppColors.getTextPrimary(context))),
              trailing: Icon(Icons.check, color: primaryColor),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).translate('standard_layer'))));
              },
            ),
            ListTile(
              leading: Icon(Icons.waves, color: infoColor),
              title: Text(AppLocalizations.of(context).translate('live_flood_layer'), style: TextStyle(color: AppColors.getTextPrimary(context))),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).translate('flood_overlay'))));
              },
            ),
            ListTile(
              leading: Icon(Icons.night_shelter, color: successColor),
              title: Text(AppLocalizations.of(context).translate('shelter_locations_availability'), style: TextStyle(color: AppColors.getTextPrimary(context))),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).translate('shelters_layer'))));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _centerMap() {
    if (_locationPermissionGranted) {
      _mapController.move(_currentLocation, 14.0);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).translate('location_permission_required'))),
      );
      _determinePosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBgColor = AppColors.getCardBackground(context);
    final primaryTextColor = AppColors.getTextPrimary(context);
    final secondaryTextColor = AppColors.getTextSecondary(context);
    final borderColor = AppColors.getBorder(context);
    final primaryColor = AppColors.getPrimary(context);
    final infoColor = AppColors.getInfo(context);
    final successColor = AppColors.getSuccess(context);
    final errorColor = AppColors.getError(context);

    final mockMarkers = [
      Marker(
        point: const LatLng(8.8932, 76.6141),
        width: 40,
        height: 40,
        child: Icon(Icons.water_drop, color: infoColor, size: 40),
      ),
      Marker(
        point: const LatLng(8.8980, 76.6200),
        width: 40,
        height: 40,
        child: Icon(Icons.home, color: successColor, size: 40),
      ),
      Marker(
        point: const LatLng(8.8850, 76.6050),
        width: 40,
        height: 40,
        child: Icon(Icons.remove_road, color: errorColor, size: 40),
      ),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: UniversalHeader(
        title: AppLocalizations.of(context).translate('map'),
        showBackButton: false,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation,
              initialZoom: 13.0,
            ),
            children: [
              OverlayImageLayer(
                overlayImages: [
                  OverlayImage(
                    bounds: LatLngBounds(const LatLng(8.8500, 76.5800), const LatLng(8.9300, 76.6500)),
                    imageProvider: const AssetImage('assets/images/kollam_map.jpg'),
                    opacity: 0.8,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  ...mockMarkers,
                  if (!_isLoadingLocation && _locationPermissionGranted)
                    Marker(
                      point: _currentLocation,
                      width: 50,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(Icons.my_location, color: primaryColor, size: 28),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: TextField(
              style: TextStyle(color: primaryTextColor),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).translate('search_areas'),
                hintStyle: TextStyle(color: secondaryTextColor, fontSize: 14),
                prefixIcon: Icon(Icons.search, color: secondaryTextColor),
                filled: true,
                fillColor: cardBgColor,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: 'map_center',
                  onPressed: _centerMap,
                  backgroundColor: cardBgColor,
                  foregroundColor: primaryTextColor,
                  child: const Icon(Icons.my_location),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'map_layers',
                  onPressed: _showLayerOptions,
                  backgroundColor: cardBgColor,
                  foregroundColor: primaryTextColor,
                  child: const Icon(Icons.layers_outlined),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context).translate('active_zones'),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryTextColor),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildLegendItem(Icons.water_drop, infoColor, AppLocalizations.of(context).translate('floods'), secondaryTextColor),
                      _buildLegendItem(Icons.home, successColor, AppLocalizations.of(context).translate('shelters'), secondaryTextColor),
                      _buildLegendItem(Icons.remove_road, errorColor, AppLocalizations.of(context).translate('blocked'), secondaryTextColor),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const UniversalNavBar(currentIndex: 1),
    );
  }

  Widget _buildLegendItem(IconData icon, Color color, String label, Color textColor) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 13, color: textColor, fontWeight: FontWeight.w500)),
      ],
    );
  }
}


