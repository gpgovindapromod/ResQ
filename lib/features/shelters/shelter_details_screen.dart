import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'widgets/shelter_card.dart';
import '../../shared/widgets/universal_header.dart';
import '../../shared/widgets/universal_nav_bar.dart';

class ShelterDetailsScreen extends StatelessWidget {
  final ShelterModel shelter;

  const ShelterDetailsScreen({super.key, required this.shelter});

  @override
  Widget build(BuildContext context) {
    final double capacityPercent = shelter.currentCapacity / shelter.maxCapacity;
    final int capacityPercentInt = (capacityPercent * 100).round();

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC), // background
      appBar: UniversalHeader(
        title: 'Shelter Details',
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Color(0xFF002045)),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shelter Image Placeholder
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E3E5),
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1577962917302-cd874c4e31d2?auto=format&fit=crop&w=800&q=80'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Title and Location
              Text(
                shelter.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF002045), letterSpacing: -0.01),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF43474E)),
                  const SizedBox(width: 4),
                  Text(
                    '124 Main Street, Metro City', // Hardcoded as per design or use shelter.distance
                    style: const TextStyle(fontSize: 14, color: Color(0xFF43474E)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Get Directions Button (Dark Blue)
              SizedBox(
                height: 48,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF002045), // primary
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.directions, size: 20),
                      SizedBox(width: 8),
                      Text('Get Directions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Occupancy Status Card
              _buildCardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Occupancy\nStatus', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF002045), height: 1.2)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFDEAA), // tertiary-fixed
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: const Text(
                            'Filling\nFast',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF5F4100), height: 1.2), // on-tertiary-fixed-variant
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('$capacityPercentInt%', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF002045))),
                        Text('${shelter.currentCapacity} / ${shelter.maxCapacity} beds', style: const TextStyle(fontSize: 14, color: Color(0xFF43474E))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(9999),
                      child: LinearProgressIndicator(
                        value: capacityPercent,
                        backgroundColor: const Color(0xFFE0E3E5), // surface-variant
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFBA1A1A)), // error color (red) as in design
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Available Facilities Card
              _buildCardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Available Facilities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF002045))),
                    const SizedBox(height: 16),
                    // Grid matching the Incident Type style from code.html
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.5, // Wider than tall
                      ),
                      itemCount: 6, // Hardcoded to match design (Food, Water, Medical, Restrooms, Power, Wi-Fi)
                      itemBuilder: (context, index) {
                        final items = [
                          {'icon': Icons.restaurant, 'label': 'Food'},
                          {'icon': Icons.water_drop, 'label': 'Water'},
                          {'icon': Icons.medical_services, 'label': 'Medical'},
                          {'icon': Icons.wc, 'label': 'Restrooms'},
                          {'icon': Icons.power, 'label': 'Power'},
                          {'icon': Icons.wifi, 'label': 'Wi-Fi'},
                        ];
                        return _buildFacilityBox(items[index]['label'] as String, items[index]['icon'] as IconData);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Contact Information Card
              _buildCardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Contact Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF002045))),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Icon(Icons.phone_outlined, size: 20, color: Color(0xFF43474E)),
                        SizedBox(width: 12),
                        Text('1-800-SAFE-911', style: TextStyle(fontSize: 14, color: Color(0xFF181C1E), fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.access_time, size: 20, color: Color(0xFF43474E)),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Intake: 24/7', style: TextStyle(fontSize: 14, color: Color(0xFF181C1E), fontWeight: FontWeight.w500)),
                            SizedBox(height: 4),
                            Text('Doors lock at 10 PM', style: TextStyle(fontSize: 12, color: Color(0xFF43474E))),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Critical Alert
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDAD6), // error-container
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Color(0xFF93000A), size: 20),
                        SizedBox(width: 8),
                        Text('Critical Alert', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF93000A))),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Please enter through the North Entrance only. South access is currently blocked due to debris. Have your ID ready for quick processing.',
                      style: TextStyle(fontSize: 14, color: Color(0xFF93000A), height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Map & Navigate Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E3E5)),
                  boxShadow: [
                     BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 1))
                  ]
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 120,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: AbsorbPointer( // Prevents panning/zooming gestures from catching scroll
                          child: FlutterMap(
                            options: const MapOptions(
                              initialCenter: LatLng(8.8980, 76.6200), // Match the mock marker location from MapScreen
                              initialZoom: 15.0,
                              interactionOptions: InteractionOptions(flags: InteractiveFlag.none), // Disable interaction
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png?v=1',
                                userAgentPackageName: 'com.btech.srp.resq',
                              ),
                              const MarkerLayer(
                                markers: [
                                  Marker(
                                    point: LatLng(8.8980, 76.6200),
                                    width: 40,
                                    height: 40,
                                    child: Icon(Icons.location_on, color: Color(0xFFBA1A1A), size: 40),
                                  ),
                                ],
                              ),
                            ],
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
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFBA1A1A), // error
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.navigation, size: 20),
                              SizedBox(width: 8),
                              Text('Navigate Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 88), // Bottom padding for nav bar
            ],
          ),
        ),
      ),
      bottomNavigationBar: const UniversalNavBar(currentIndex: 2),
    );
  }

  Widget _buildCardContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white, // bg-surface-container-lowest
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E3E5)), // border-surface-variant
        boxShadow: [
           BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))
        ]
      ),
      child: child,
    );
  }

  Widget _buildFacilityBox(String label, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F6), // surface-container-low
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E3E5)), // border-surface-variant
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: const Color(0xFF002045)), // primary
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF002045)),
          ),
        ],
      ),
    );
  }
}
