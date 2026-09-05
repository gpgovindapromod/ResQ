import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class IncidentTypeSelector extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  final bool isDark;

  const IncidentTypeSelector({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.isDark,
  });

  @override
  State<IncidentTypeSelector> createState() => _IncidentTypeSelectorState();
}

class _IncidentTypeSelectorState extends State<IncidentTypeSelector> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  void _updateSelection(String newValue) {
    setState(() {
      _selectedValue = newValue;
    });
    widget.onChanged(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildTypeChip('Flood', Icons.water_drop)),
            const SizedBox(width: 12),
            Expanded(child: _buildTypeChip('Blocked Road', Icons.block)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildTypeChip('Person Needs\nRescue', Icons.medical_services)),
            const SizedBox(width: 12),
            Expanded(child: _buildTypeChip('Fire', Icons.fire_extinguisher)),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeChip(String label, IconData icon) {
    final isSelected = _selectedValue == label;
    final primaryColor = AppColors.getPrimary(context);
    final chipBg = isSelected
        ? primaryColor.withValues(alpha: 0.15)
        : AppColors.getSurface(context);
    final iconTextColor = isSelected
        ? primaryColor
        : AppColors.getTextSecondary(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _updateSelection(label),
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          constraints: const BoxConstraints(minHeight: 80),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: chipBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? primaryColor : AppColors.getBorder(context),
              width: isSelected ? 2.0 : 1.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: iconTextColor),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: iconTextColor,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
