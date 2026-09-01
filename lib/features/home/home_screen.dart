import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_router.dart';
import '../../shared/widgets/universal_nav_bar.dart';
import '../../shared/widgets/universal_header.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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
  final Color capacityColor;

  const Shelter({
    required this.name,
    required this.distance,
    required this.capacity,
    required this.icon,
    this.capacityColor = AppColors.textPrimary,
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
      capacityColor: Color(0xFF1E293B),
    ),
    Shelter(
      name: 'Govt. Higher Sec. School',
      distance: '2.5 km',
      capacity: '90% Capacity',
      icon: Icons.school_outlined,
      capacityColor: Color(0xFFDC2626),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: UniversalHeader(
        titleWidget: Row(
          children: [
            const Icon(Icons.location_on, color: AppColors.primary, size: 28),
            const SizedBox(width: 8),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Current Location',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      _locationName,
                      style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: AppColors.primary, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  await _determinePosition();
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGreeting(),
                      const SizedBox(height: 24),
                      FloodRiskCard(risk: currentRisk),
                      const SizedBox(height: 24),
                      _buildActionGrid(),
                      const SizedBox(height: 32),
                      _buildSectionHeader('Latest Alerts', 'View All'),
                      const SizedBox(height: 16),
                      ...alerts.map((alert) => AlertCard(alert: alert)),
                      const SizedBox(height: 32),
                      _buildSectionHeader('Nearby Shelters', ''),
                      const SizedBox(height: 16),
                      ...shelters.map((shelter) => ShelterCard(shelter: shelter)),
                      const SizedBox(height: 24),
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

  Widget _buildGreeting() {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good morning.';
    } else if (hour < 17) {
      greeting = 'Good afternoon.';
    } else {
      greeting = 'Good evening.';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: const TextStyle(color: AppColors.primary, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5),
        ),
        const SizedBox(height: 4),
        const Text(
          'Here is the latest status for your area.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildActionGrid() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              ActionGridItem(
                title: 'View Risk Map',
                icon: Icons.map_outlined,
                backgroundColor: AppColors.primary,
                textColor: Colors.white,
                iconColor: Colors.white,
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRouter.map);
                },
              ),
              const SizedBox(height: 16),
              ActionGridItem(
                title: 'Report Incident',
                icon: Icons.cell_tower, // Using cell_tower as an approximation
                backgroundColor: const Color(0xFFB91C1C),
                textColor: Colors.white,
                iconColor: Colors.white,
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRouter.report);
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              ActionGridItem(
                title: 'Find Shelter',
                icon: Icons.location_on_outlined,
                backgroundColor: Colors.white,
                textColor: AppColors.primary,
                iconColor: AppColors.primary,
                hasBorder: true,
                onTap: () {},
              ),
              const SizedBox(height: 16),
              ActionGridItem(
                title: 'Emergency Contacts',
                icon: Icons.contact_phone_outlined,
                backgroundColor: Colors.white,
                textColor: AppColors.primary,
                iconColor: AppColors.primary,
                hasBorder: true,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (actionText.isNotEmpty)
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
            decoration: const BoxDecoration(
              color: Color(0xFFF59E0B),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CURRENT FLOOD RISK',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      risk.status,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF59E0B),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            risk.tag,
                            style: const TextStyle(color: Color(0xFFB45309), fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  risk.description,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
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
  final VoidCallback onTap;

  const ActionGridItem({
    super.key,
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    this.hasBorder = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130, // Increased to prevent overflow when text wraps
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: hasBorder ? Border.all(color: AppColors.border) : null,
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
    );
  }
}

class AlertCard extends StatelessWidget {
  final AlertItem alert;

  const AlertCard({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
              decoration: const BoxDecoration(
                color: Color(0xFFDC2626),
                borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.type,
                      style: const TextStyle(color: Color(0xFFDC2626), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      alert.description,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(shelter.icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shelter.name,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.directions_walk, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      shelter.distance,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    const Text('•', style: TextStyle(color: AppColors.border, fontSize: 12)),
                    const SizedBox(width: 8),
                    const Icon(Icons.people_outline, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      shelter.capacity,
                      style: TextStyle(color: shelter.capacityColor, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
