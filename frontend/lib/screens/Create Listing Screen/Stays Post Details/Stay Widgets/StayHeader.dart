import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/themes.dart';

class StayHeader extends StatelessWidget {
  final Color textColor;
  final Color secondaryTextColor;
  
  const StayHeader({
    Key? key,
    required this.textColor,
    required this.secondaryTextColor,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.house_outlined,
              color: AppTheme.primaryColor,
              size: 30,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.stay_details_title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context)!.stay_details_subtitle,
            style: TextStyle(
              fontSize: 16,
              color: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}