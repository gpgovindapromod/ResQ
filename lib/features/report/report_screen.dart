import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/universal_header.dart';
import '../../shared/widgets/universal_nav_bar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String _selectedIncidentType = 'Flood';
  
  LatLng? _currentPosition;
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
      if (mounted) setState(() { _locationName = 'Location disabled'; _isLoadingLocation = false; });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) setState(() { _locationName = 'Permission denied'; _isLoadingLocation = false; });
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      if (mounted) setState(() { _locationName = 'Perm denied forever'; _isLoadingLocation = false; });
      return;
    } 

    try {
      Position position = await Geolocator.getCurrentPosition();
      final geocoding = Geocoding();
      List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(position.latitude, position.longitude);
      
      if (mounted) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
          if (placemarks.isNotEmpty) {
            Placemark place = placemarks.first;
            _locationName = '${place.street ?? ''}, ${place.locality ?? place.subAdministrativeArea ?? 'Unknown'}'.trim();
            if (_locationName.startsWith(',')) _locationName = _locationName.substring(1).trim();
          } else {
            _locationName = 'Unknown Location';
          }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC), // background from stitch
      appBar: const UniversalHeader(
        showBackButton: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Report an Incident',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF181C1E)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please provide details to help responders assess the situation quickly.',
                style: TextStyle(fontSize: 16, color: Color(0xFF43474E), height: 1.5),
              ),
              const SizedBox(height: 24),
              
              // Incident Type
              _buildCardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Incident Type', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF181C1E))),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildTypeChip('Flood', Icons.water_drop)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildTypeChip('Blocked Road', Icons.block)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _buildTypeChip('Person Needs\nRescue', Icons.medical_services)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildTypeChip('Fire', Icons.fire_extinguisher)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Location Preview
              _buildCardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Current Location', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF181C1E))),
                        GestureDetector(
                          onTap: () {
                            setState(() { _isLoadingLocation = true; });
                            _determinePosition();
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.my_location, size: 16, color: Color(0xFF002045)),
                              SizedBox(width: 4),
                              Text('Update', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF002045))),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 192,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFE0E3E5),
                        border: Border.all(color: const Color(0xFFC4C6CF)),
                      ),
                      clipBehavior: Clip.antiAlias, // ensure map stays inside rounded corners
                      child: _isLoadingLocation 
                        ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                        : _currentPosition == null
                          ? const Center(child: Text('Could not load map.', style: TextStyle(color: AppColors.textSecondary)))
                          : FlutterMap(
                              options: MapOptions(
                                initialCenter: _currentPosition!,
                                initialZoom: 15.0,
                                interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png?v=1',
                                  userAgentPackageName: 'com.btech.srp.resq',
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: _currentPosition!,
                                      width: 40,
                                      height: 40,
                                      child: const Icon(Icons.location_on, color: Color(0xFFB51822), size: 40),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.pin_drop_outlined, size: 18, color: Color(0xFF43474E)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _locationName,
                            style: const TextStyle(fontSize: 16, color: Color(0xFF43474E)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Attachment
              _buildCardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Attach Photo (Optional)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF181C1E))),
                    const SizedBox(height: 16),
                    Container(
                      height: 128,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFC4C6CF), style: BorderStyle.none),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(8),
                               border: Border.all(color: const Color(0xFFC4C6CF), width: 2, strokeAlign: BorderSide.strokeAlignOutside),
                             ),
                             child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo_outlined, size: 32, color: Color(0xFF43474E)),
                                  SizedBox(height: 8),
                                  Text('Tap to upload or take a photo', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF43474E))),
                                ],
                             ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Description
              _buildCardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Description', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF181C1E))),
                    const SizedBox(height: 16),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Provide additional details about the incident...',
                        hintStyle: const TextStyle(color: Color(0xFF43474E), fontSize: 16),
                        filled: true,
                        fillColor: const Color(0xFFF7FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFC4C6CF)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFC4C6CF)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFF002045)),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Submit Button
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBA1A1A), // bg-error
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                    elevation: 2,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_amber_rounded, size: 24),
                      SizedBox(width: 8),
                      Text('Submit Emergency Report', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 88), // padding for bottom nav
            ],
          ),
        ),
      ),
      bottomNavigationBar: const UniversalNavBar(currentIndex: 3),
    );
  }

  Widget _buildCardContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E3E5)),
        boxShadow: [
           BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 1))
        ]
      ),
      child: child,
    );
  }

  Widget _buildTypeChip(String label, IconData icon) {
    final isSelected = _selectedIncidentType == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIncidentType = label;
        });
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 96),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD6E3FF) : const Color(0xFFF7FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
             color: isSelected ? const Color(0xFF002045) : const Color(0xFFC4C6CF), 
             width: isSelected ? 2.0 : 1.0
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: isSelected ? const Color(0xFF2D476F) : const Color(0xFF43474E)),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? const Color(0xFF2D476F) : const Color(0xFF43474E),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
