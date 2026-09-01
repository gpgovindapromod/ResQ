import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class UniversalHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final bool showBackButton;
  final List<Widget>? actions;

  const UniversalHeader({
    super.key,
    this.title,
    this.titleWidget,
    this.showBackButton = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    // If a custom titleWidget is provided (e.g., HomeScreen with GPS location),
    // we use the original layout.
    if (titleWidget != null) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                if (showBackButton && Navigator.canPop(context))
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                if (showBackButton && Navigator.canPop(context))
                  const SizedBox(width: 16),
                Expanded(child: titleWidget!),
                ...?actions,
              ],
            ),
          ),
        ),
      );
    }

    // Default Stitch Layout for all other pages
    return AppBar(
      backgroundColor: title != null ? Colors.white : const Color(0xFFF7FAFC),
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false, // We control the leading widget
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: const Color(0xFFC4C6CF), height: 1.0),
      ),
      leading: showBackButton && Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF002045),
              ),
              onPressed: () => Navigator.pop(context),
            )
          : IconButton(
              icon: const Icon(
                Icons.location_on,
                color: Color(0xFF002045),
                size: 28,
              ),
              onPressed: () {},
            ),
      centerTitle: true,
      title: Text(
        title ?? 'ResQ',
        style: TextStyle(
          color: const Color(0xFF002045),
          fontSize: title != null ? 18 : 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions:
          actions ??
          [
            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Color(0xFF43474E),
                size: 28,
              ),
              onPressed: () {},
            ),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0); // Reduced height
}
