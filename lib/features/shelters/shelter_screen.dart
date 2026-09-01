import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/universal_header.dart';
import '../../shared/widgets/universal_nav_bar.dart';
import 'widgets/shelter_card.dart';

class ShelterScreen extends StatefulWidget {
  const ShelterScreen({super.key});

  @override
  State<ShelterScreen> createState() => _ShelterScreenState();
}

class _ShelterScreenState extends State<ShelterScreen> {
  final List<ShelterModel> mockShelters = [
    ShelterModel(
      name: 'City Hall Safe Zone',
      status: 'OPEN',
      statusColor: const Color(0xFF10B981), // Green
      distance: '1.2 km',
      currentCapacity: 74,
      maxCapacity: 100,
      amenities: [
        {'icon': Icons.medical_services_outlined, 'label': 'First Aid'},
        {'icon': Icons.water_drop_outlined, 'label': 'Water'},
      ],
    ),
    ShelterModel(
      name: 'Community Center West',
      status: 'NEAR CAPACITY',
      statusColor: const Color(0xFFF59E0B), // Orange/Amber
      distance: '2.5 km',
      currentCapacity: 240,
      maxCapacity: 250,
      amenities: [
        {'icon': Icons.pets_outlined, 'label': 'Pets Allowed'},
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: const UniversalHeader(
        title: 'ResQ',
        showBackButton: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Shelter Locator',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.map_outlined, size: 16),
                        label: const Text('Map View', style: TextStyle(fontWeight: FontWeight.w600)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search Bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for shelters by name or location...',
                      hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('Nearest', isSelected: true),
                        const SizedBox(width: 8),
                        _buildFilterChip('Available'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Medical', icon: Icons.medical_services_outlined),
                        const SizedBox(width: 8),
                        _buildFilterChip('Pets', icon: Icons.pets_outlined),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  itemCount: mockShelters.length,
                  itemBuilder: (context, index) {
                    return ShelterCard(shelter: mockShelters[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const UniversalNavBar(currentIndex: 2),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: isSelected ? Colors.white : AppColors.textSecondary),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
