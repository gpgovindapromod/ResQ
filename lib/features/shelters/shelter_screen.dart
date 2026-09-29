import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_router.dart';
import '../../shared/widgets/universal_header.dart';
import '../../shared/widgets/universal_nav_bar.dart';
import 'widgets/shelter_card.dart';
import 'widgets/filter_chip_widget.dart';
import '../../core/localization/app_localizations.dart';

class ShelterScreen extends StatefulWidget {
  const ShelterScreen({super.key});

  @override
  State<ShelterScreen> createState() => _ShelterScreenState();
}

class _ShelterScreenState extends State<ShelterScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardBgColor = AppColors.getCardBackground(context);
    final primaryTextColor = AppColors.getTextPrimary(context);
    final secondaryTextColor = AppColors.getTextSecondary(context);
    final borderColor = AppColors.getBorder(context);
    final primaryColor = AppColors.getPrimary(context);
    final successColor = AppColors.getSuccess(context);
    final warningColor = AppColors.getWarning(context);

    final mockShelters = [
      ShelterModel(
        name: 'City Hall Safe Zone',
        status: 'OPEN',
        statusColor: successColor,
        distance: '1.2 km',
        currentCapacity: 74,
        maxCapacity: 100,
        amenities: [
          {'icon': Icons.medical_services_outlined, 'label': AppLocalizations.of(context).translate('first_aid')},
          {'icon': Icons.water_drop_outlined, 'label': AppLocalizations.of(context).translate('water')},
        ],
      ),
      ShelterModel(
        name: 'Community Center West',
        status: 'NEAR CAPACITY',
        statusColor: warningColor,
        distance: '2.5 km',
        currentCapacity: 240,
        maxCapacity: 250,
        amenities: [
          {'icon': Icons.pets_outlined, 'label': AppLocalizations.of(context).translate('pets_allowed')},
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context).translate('shelter_locator'),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, AppRouter.map);
                        },
                        icon: Icon(Icons.map_outlined, size: 16, color: primaryColor),
                        label: Text(AppLocalizations.of(context).translate('map_view'), style: TextStyle(fontWeight: FontWeight.w600, color: primaryColor)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: borderColor),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    style: TextStyle(color: primaryTextColor),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).translate('search_shelters'),
                      hintStyle: TextStyle(color: secondaryTextColor, fontSize: 13),
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
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChipWidget(label: AppLocalizations.of(context).translate('nearest'), isSelected: true),
                        const SizedBox(width: 8),
                        FilterChipWidget(label: AppLocalizations.of(context).translate('available')),
                        const SizedBox(width: 8),
                        FilterChipWidget(label: AppLocalizations.of(context).translate('medical'), icon: Icons.medical_services_outlined),
                        const SizedBox(width: 8),
                        FilterChipWidget(label: AppLocalizations.of(context).translate('pets'), icon: Icons.pets_outlined),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: primaryColor,
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


}


