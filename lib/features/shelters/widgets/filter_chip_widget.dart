import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final IconData? icon;

  const FilterChipWidget({
    super.key,
    required this.label,
    this.isSelected = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final chipBg = isSelected ? AppColors.getPrimary(context) : AppColors.getCardBackground(context);
    final textColor = isSelected ? AppColors.getOnPrimary(context) : AppColors.getTextSecondary(context);
    final borderColor = isSelected ? AppColors.getPrimary(context) : AppColors.getBorder(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: chipBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
