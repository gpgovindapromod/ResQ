import 'package:flutter/material.dart';
import '../../core/routes/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/universal_header.dart';
import '../../shared/widgets/universal_nav_bar.dart';
import 'dart:io';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'widgets/incident_type_selector.dart';
import '../../core/localization/app_localizations.dart';

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
  bool _isSubmitting = false;
  
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

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
      
      if (mounted) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
          _locationName = 'Lat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}';
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

  Future<void> _submitReport() async {
    setState(() {
      _isSubmitting = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.getSurface(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.getSuccess(context), size: 28),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context).translate('report_dispatched'),
              style: TextStyle(color: AppColors.getTextPrimary(context)),
            ),
          ],
        ),
        content: Text(
          'Emergency report for "$_selectedIncidentType" has been logged successfully.\n\nCoordinates: $_locationName\n\nNearby emergency units have been notified.',
          style: TextStyle(fontSize: 14, height: 1.4, color: AppColors.getTextPrimary(context)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _descriptionController.clear();
                _imageFile = null;
              });
            },
            child: Text(AppLocalizations.of(context).translate('close'), style: TextStyle(color: AppColors.getTextSecondary(context))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRouter.map);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.getPrimary(context),
              foregroundColor: AppColors.getOnPrimary(context),
            ),
            child: Text(AppLocalizations.of(context).translate('view_live_map')),
          ),
        ],
      ),
    );
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
    final errorColor = AppColors.getError(context);
    final onErrorColor = AppColors.getOnError(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const UniversalHeader(
        showBackButton: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context).translate('report_incident'),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: primaryTextColor),
              ),
              const SizedBox(height: 6),
              Text(
                AppLocalizations.of(context).translate('provide_details'),
                style: TextStyle(fontSize: 14, color: secondaryTextColor, height: 1.4),
              ),
              const SizedBox(height: 16),
              _buildCardContainer(
                cardBgColor: cardBgColor,
                borderColor: borderColor,
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context).translate('incident_type'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primaryTextColor)),
                    const SizedBox(height: 12),
                    IncidentTypeSelector(
                      initialValue: _selectedIncidentType,
                      isDark: isDark,
                      onChanged: (val) {
                        setState(() {
                          _selectedIncidentType = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildCardContainer(
                cardBgColor: cardBgColor,
                borderColor: borderColor,
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context).translate('current_location'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primaryTextColor)),
                        GestureDetector(
                          onTap: () {
                            setState(() { _isLoadingLocation = true; });
                            _determinePosition();
                          },
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
                      child: _isLoadingLocation 
                        ? Center(child: CircularProgressIndicator(color: primaryColor))
                        : _currentPosition == null
                          ? Center(child: Text(AppLocalizations.of(context).translate('could_not_load_map'), style: TextStyle(color: secondaryTextColor)))
                          : FlutterMap(
                              options: MapOptions(
                                initialCenter: _currentPosition!,
                                initialZoom: 15.0,
                                interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
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
                                    Marker(
                                      point: _currentPosition!,
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
                            _locationName,
                            style: TextStyle(fontSize: 14, color: secondaryTextColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildCardContainer(
                cardBgColor: cardBgColor,
                borderColor: borderColor,
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context).translate('attach_photo'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primaryTextColor)),
                    const SizedBox(height: 12),
                    Container(
                      height: 112,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: cardBgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _imageFile != null
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(_imageFile!, fit: BoxFit.cover, width: double.infinity, height: 112),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () => setState(() => _imageFile = null),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close, color: Colors.white, size: 20),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _pickImage,
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: borderColor, width: 2),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo_outlined, size: 28, color: secondaryTextColor),
                                      const SizedBox(height: 8),
                                      Text(AppLocalizations.of(context).translate('tap_upload_photo'), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: secondaryTextColor)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildCardContainer(
                cardBgColor: cardBgColor,
                borderColor: borderColor,
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context).translate('description'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primaryTextColor)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 3,
                      style: TextStyle(color: primaryTextColor),
                      decoration: InputDecoration(
                        hintText: 'Provide additional details...',
                        hintStyle: TextStyle(color: secondaryTextColor, fontSize: 14),
                        filled: true,
                        fillColor: AppColors.getSurface(context),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: errorColor,
                    foregroundColor: onErrorColor,
                    disabledBackgroundColor: errorColor.withValues(alpha: 0.6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                    elevation: 2,
                  ),
                  child: _isSubmitting
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: onErrorColor, strokeWidth: 2.5),
                            ),
                            const SizedBox(width: 12),
                            Text(AppLocalizations.of(context).translate('sending_alert'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: onErrorColor)),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.warning_amber_rounded, size: 20),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context).translate('submit_emergency_report'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const UniversalNavBar(currentIndex: 3),
    );
  }

  Widget _buildCardContainer({required Widget child, required Color cardBgColor, required Color borderColor, required bool isDark}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
        boxShadow: [
           BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05), blurRadius: 4, offset: const Offset(0, 1))
        ]
      ),
      child: child,
    );
  }


}


