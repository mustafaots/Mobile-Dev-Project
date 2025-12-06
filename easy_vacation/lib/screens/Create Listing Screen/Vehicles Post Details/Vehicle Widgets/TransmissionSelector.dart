import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/themes.dart';

class TransmissionSelector extends StatelessWidget {
  final bool isAutomatic;
  final ValueChanged<bool> onChanged;
  final Color textColor;
  final Color cardColor;
  
  const TransmissionSelector({
    Key? key,
    required this.isAutomatic,
    required this.onChanged,
    required this.textColor,
    required this.cardColor,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.neutralColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.settings, color: AppTheme.neutralColor, size: 20),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.transmission_label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ChoiceChip(
                label: Text(AppLocalizations.of(context)!.transmission_manual),
                selected: !isAutomatic,
                selectedColor: AppTheme.neutralColor,
                onSelected: (selected) {
                  onChanged(!selected);
                },
              ),
              ChoiceChip(
                label: Text(AppLocalizations.of(context)!.transmission_automatic),
                selected: isAutomatic,
                selectedColor: AppTheme.neutralColor,
                onSelected: (selected) {
                  onChanged(selected);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}