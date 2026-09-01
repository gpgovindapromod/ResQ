import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/universal_header.dart';
import '../../shared/widgets/universal_nav_bar.dart';

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

  final List<Marker> _mockMarkers = [
    Marker(
      point: const LatLng(8.8932, 76.6141), // Flood zone
      width: 40,
      height: 40,
      child: const Icon(Icons.water_drop, color: Colors.blue, size: 40),
    ),
    Marker(
      point: const LatLng(8.8980, 76.6200), // Shelter
      width: 40,
      height: 40,
      child: const Icon(Icons.home, color: Colors.green, size: 40),
    ),
    Marker(
      point: const LatLng(8.8850, 76.6050), // Blocked road
      width: 40,
      height: 40,
      child: const Icon(Icons.remove_road, color: Colors.red, size: 40),
    ),
  ];

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

  void _centerMap() {
    if (_locationPermissionGranted) {
      _mapController.move(_currentLocation, 14.0);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission required')),
      );
      _determinePosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: const UniversalHeader(
        title: 'Map',
        showBackButton: false,
      ),
      body: Stack(
        children: [
          // Interactive Map Background
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation,
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png?v=1',
                userAgentPackageName: 'com.btech.srp.resq',
              ),
              MarkerLayer(
                markers: [
                  ..._mockMarkers,
                  if (!_isLoadingLocation && _locationPermissionGranted)
                    Marker(
                      point: _currentLocation,
                      width: 50,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.my_location, color: AppColors.primary, size: 28),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),

          // Search Bar Overlay
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for areas or coordinates...',
                hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
          ),

          // Map Action Buttons (Zoom & Center)
          Positioned(
            bottom: 120,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: 'map_center',
                  onPressed: _centerMap,
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.textPrimary,
                  child: const Icon(Icons.my_location),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'map_layers',
                  onPressed: () {},
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.textPrimary,
                  child: const Icon(Icons.layers_outlined),
                ),
              ],
            ),
          ),

          // Bottom Sheet / Legend Card
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Active Zones',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildLegendItem(Icons.water_drop, Colors.blue, 'Floods'),
                      _buildLegendItem(Icons.home, Colors.green, 'Shelters'),
                      _buildLegendItem(Icons.remove_road, Colors.red, 'Blocked'),
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

  Widget _buildLegendItem(IconData icon, Color color, String label) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
