import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';

class GreetingWidget extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final AppLocalizations loc;

  const GreetingWidget({
    super.key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.loc,
  });

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = loc.translate('good_morning');
    } else if (hour < 17) {
      greeting = loc.translate('good_afternoon');
    } else {
      greeting = loc.translate('good_evening');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: TextStyle(color: primaryColor, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: -0.5),
        ),
        const SizedBox(height: 4),
        Text(
          loc.translate('greeting_sub'),
          style: TextStyle(color: secondaryColor, fontSize: 14),
        ),
      ],
    );
  }
}
