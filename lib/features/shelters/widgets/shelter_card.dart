import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
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
    final double capacityPercent = shelter.currentCapacity / shelter.maxCapacity;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Accent Line
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
                // Title and Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        shelter.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
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
                // Distance
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${shelter.distance} away',
                      style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Capacity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Capacity', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    Text('${shelter.currentCapacity} / ${shelter.maxCapacity}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: capacityPercent,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(shelter.statusColor),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 20),
                // Amenities
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: shelter.amenities.map((amenity) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FB),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.border, width: 0.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(amenity['icon'] as IconData, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            amenity['label'] as String,
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          // Footer Action Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FB),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
              border: Border(top: BorderSide(color: AppColors.border)),
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
                  style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                  child: const Text('View Details', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.directions, size: 18),
                  label: const Text('Directions', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
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
