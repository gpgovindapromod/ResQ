import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';

class PhotoUploadCard extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onPickImage;
  final VoidCallback onClearImage;
  final bool isDark;

  const PhotoUploadCard({
    super.key,
    required this.imageFile,
    required this.onPickImage,
    required this.onClearImage,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final cardBgColor = AppColors.getCardBackground(context);
    final borderColor = AppColors.getBorder(context);
    final primaryTextColor = AppColors.getTextPrimary(context);
    final secondaryTextColor = AppColors.getTextSecondary(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05), blurRadius: 4, offset: const Offset(0, 1))
        ],
      ),
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
            child: imageFile != null
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(imageFile!, fit: BoxFit.cover, width: double.infinity, height: 112),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: onClearImage,
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
                      onTap: onPickImage,
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
    );
  }
}
