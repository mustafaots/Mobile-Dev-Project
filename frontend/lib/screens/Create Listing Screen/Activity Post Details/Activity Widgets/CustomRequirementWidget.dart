import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Activity%20Post%20Details/ActivityFormLogic.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/themes.dart';

class CustomRequirementWidget extends StatelessWidget {
  final ActivityFormController formController;
  final Color textColor;
  final Color secondaryTextColor;
  final Color cardColor;
  final VoidCallback onUpdate;
  
  const CustomRequirementWidget({
    Key? key,
    required this.formController,
    required this.textColor,
    required this.secondaryTextColor,
    required this.cardColor,
    required this.onUpdate,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.additional_requirements,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 12),
        
        // Existing custom requirements
        ...formController.customRequirements.asMap().entries.map((entry) {
          final index = entry.key;
          final requirement = entry.value;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: secondaryTextColor.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        requirement.key,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        requirement.value,
                        style: TextStyle(color: secondaryTextColor),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    formController.customRequirements.removeAt(index);
                    onUpdate();
                  },
                ),
              ],
            ),
          );
        }).toList(),
        
        // Add new custom requirement
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: formController.customKeyController,
                decoration: InputDecoration(
                  labelText: loc.requirement_name,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: formController.customValueController,
                decoration: InputDecoration(
                  labelText: loc.requirement_value,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.add, color: AppTheme.successColor),
              onPressed: () {
                if (formController.customKeyController.text.isNotEmpty && 
                    formController.customValueController.text.isNotEmpty) {
                  formController.customRequirements.add(MapEntry(
                    formController.customKeyController.text,
                    formController.customValueController.text,
                  ));
                  formController.customKeyController.clear();
                  formController.customValueController.clear();
                  onUpdate();
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          loc.example_text,
          style: TextStyle(
            fontSize: 12,
            color: secondaryTextColor,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}