import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_router.dart';
import '../../core/localization/app_localizations.dart';
import '../../shared/widgets/universal_nav_bar.dart';
import '../../shared/widgets/universal_header.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'widgets/greeting_widget.dart';
import 'widgets/action_grid_widget.dart';

// --- Data Models ---
class FloodRisk {
  final String status;
  final String tag;
  final String description;

  const FloodRisk({
    required this.status,
    required this.tag,
    required this.description,
  });
}

class AlertItem {
  final String type;
  final String description;

  const AlertItem({
    required this.type,
    required this.description,
  });
}

class Shelter {
  final String name;
  final String distance;
  final String capacity;
  final IconData icon;
  final bool isHighCapacity;

  const Shelter({
    required this.name,
    required this.distance,
    required this.capacity,
    required this.icon,
    this.isHighCapacity = false,
  });
}

// --- Main Screen ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _locationName = 'Locating...';
  bool _isLoadingLocation = true;

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
      setState(() {
        _locationName = 'Location disabled';
        _isLoadingLocation = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled. Please enable them in your device settings.')),
        );
      }
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationName = 'Permission denied';
          _isLoadingLocation = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied. We cannot fetch your current city.')),
          );
        }
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationName = 'Perm denied forever';
        _isLoadingLocation = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions.')),
        );
      }
      return;
    } 

    try {
      Position position = await Geolocator.getCurrentPosition();
      final geocoding = Geocoding();
      List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(position.latitude, position.longitude);
      
      if (placemarks.isNotEmpty && mounted) {
        Placemark place = placemarks.first;
        setState(() {
          _locationName = place.locality ?? place.subAdministrativeArea ?? 'Unknown Location';
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _locationName = 'Error locating';
          _isLoadingLocation = false;
        });
      }
    }
  }

  // --- Dummy Data Initialization ---
  final FloodRisk currentRisk = const FloodRisk(
    status: 'MEDIUM',
    tag: 'Elevated',
    description: 'Stay alert and monitor updates. Water levels in nearby rivers are rising slowly.',
  );

  final List<AlertItem> alerts = const [
    AlertItem(
      type: 'ROAD CLOSURE',
      description: 'Main Street bridge is temporarily closed due to rising waters.',
    ),
  ];

  final List<Shelter> shelters = const [
    Shelter(
      name: 'Kollam City Hall',
      distance: '1.2 km',
      capacity: '45% Capacity',
      icon: Icons.home_outlined,
      isHighCapacity: false,
    ),
    Shelter(
      name: 'Govt. Higher Sec. School',
      distance: '2.5 km',
      capacity: '90% Capacity',
      icon: Icons.school_outlined,
      isHighCapacity: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final primaryTextColor = AppColors.getTextPrimary(context);
    final secondaryTextColor = AppColors.getTextSecondary(context);
    final cardBgColor = AppColors.getCardBackground(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: UniversalHeader(
        titleWidget: Row(
          children: [
            Icon(Icons.location_on, color: AppColors.getPrimary(context), size: 26),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    loc.translate('current_location'),
                    style: TextStyle(color: secondaryTextColor, fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          _locationName,
                          style: TextStyle(color: primaryTextColor, fontSize: 15, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (_isLoadingLocation) ...[
                        const SizedBox(width: 6),
                        SizedBox(
                          width: 10,
                          height: 10,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        showBackButton: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                color: AppColors.getPrimary(context),
                onRefresh: () async {
                  await _determinePosition();
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GreetingWidget(primaryColor: primaryTextColor, secondaryColor: secondaryTextColor, loc: loc),
                      const SizedBox(height: 20),
                      FloodRiskCard(risk: currentRisk),
                      const SizedBox(height: 20),
                      ActionGridWidget(cardBgColor: cardBgColor, primaryTextColor: primaryTextColor, loc: loc),
                      const SizedBox(height: 28),
                      _buildSectionHeader(loc.translate('latest_alerts'), loc.translate('view_all'), primaryTextColor),
                      const SizedBox(height: 14),
                      ...alerts.map((alert) => AlertCard(alert: alert)),
                      const SizedBox(height: 28),
                      _buildSectionHeader(loc.translate('nearby_shelters'), '', primaryTextColor),
                      const SizedBox(height: 14),
                      ...shelters.map((shelter) => ShelterCard(shelter: shelter)),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const UniversalNavBar(currentIndex: 0),
    );
  }



  Widget _buildSectionHeader(String title, String actionText, Color primaryTextColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(color: primaryTextColor, fontSize: 18, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (actionText.isNotEmpty)
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRouter.map);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.getPrimary(context),
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(actionText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          )
      ],
    );
  }
}

// --- Reusable UI Widgets ---

class FloodRiskCard extends StatelessWidget {
  final FloodRisk risk;

  const FloodRiskCard({super.key, required this.risk});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = AppColors.getCardBackground(context);
    final borderColor = AppColors.getBorder(context);
    final primaryTextColor = AppColors.getTextPrimary(context);
    final secondaryTextColor = AppColors.getTextSecondary(context);
    final warningColor = AppColors.getWarning(context);
    final warningBg = AppColors.getWarningBg(context);
    final loc = AppLocalizations.of(context);

    return Semantics(
      container: true,
      liveRegion: true,
      label: '${loc.translate('flood_risk')}: ${risk.status}, ${risk.tag}. ${risk.description}',
      child: Container(
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: warningColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.translate('flood_risk'),
                    style: TextStyle(color: secondaryTextColor, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        risk.status,
                        style: TextStyle(color: primaryTextColor, fontSize: 24, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: warningBg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: warningColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              risk.tag,
                              style: TextStyle(color: warningColor, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    risk.description,
                    style: TextStyle(color: secondaryTextColor, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class AlertCard extends StatelessWidget {
  final AlertItem alert;

  const AlertCard({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = AppColors.getCardBackground(context);
    final borderColor = AppColors.getBorder(context);
    final primaryTextColor = AppColors.getTextPrimary(context);
    final errorColor = AppColors.getError(context);

    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: errorColor,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ROAD CLOSURE',
                      style: TextStyle(color: errorColor, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      alert.description,
                      style: TextStyle(color: primaryTextColor, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShelterCard extends StatelessWidget {
  final Shelter shelter;

  const ShelterCard({super.key, required this.shelter});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = AppColors.getCardBackground(context);
    final borderColor = AppColors.getBorder(context);
    final primaryTextColor = AppColors.getTextPrimary(context);
    final secondaryTextColor = AppColors.getTextSecondary(context);
    final iconBgColor = AppColors.getPrimary(context);
    final capacityColor = shelter.isHighCapacity ? AppColors.getError(context) : AppColors.getTextPrimary(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pushReplacementNamed(context, AppRouter.shelters);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(shelter.icon, color: AppColors.getOnPrimary(context), size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shelter.name,
                        style: TextStyle(color: primaryTextColor, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.directions_walk, size: 14, color: secondaryTextColor),
                          const SizedBox(width: 4),
                          Text(
                            shelter.distance,
                            style: TextStyle(color: secondaryTextColor, fontSize: 12),
                          ),
                          const SizedBox(width: 8),
                          Text('•', style: TextStyle(color: borderColor, fontSize: 12)),
                          const SizedBox(width: 8),
                          Icon(Icons.people_outline, size: 14, color: secondaryTextColor),
                          const SizedBox(width: 4),
                          Text(
                            shelter.capacity,
                            style: TextStyle(color: capacityColor, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: secondaryTextColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


