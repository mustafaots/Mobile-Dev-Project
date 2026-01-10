import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Activity%20Post%20Details/ActivityFormLogic.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Activity%20Post%20Details/Activity%20Widgets/EquipmentDropdown.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Activity%20Post%20Details/Activity%20Widgets/ExperienceDropdown.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/ui_widgets/FormField.dart';

class RequirementSection extends StatelessWidget {
  final ActivityFormController formController;
  final Color textColor;
  final Color secondaryTextColor;
  final Color cardColor;
  final VoidCallback onUpdate;

  const RequirementSection({
    Key? key,
    required this.formController,
    required this.textColor,
    required this.secondaryTextColor,
    required this.cardColor,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: secondaryTextColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.checklist, color: AppTheme.successColor, size: 20),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.requirements_title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Minimum Age Row
          _buildMinAgeRow(context),
          const SizedBox(height: 16),

          // Equipment Dropdown
          EquipmentDropdown(
            controller: formController.equipmentController,
            options: formController.equipmentOptions,
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
            cardColor: cardColor,
            onChanged: (value) {
              formController.equipmentController.text = value!;
              onUpdate();
            },
          ),
          const SizedBox(height: 16),

          // Experience Dropdown
          ExperienceDropdown(
            controller: formController.experienceController,
            options: formController.experienceOptions,
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
            cardColor: cardColor,
            onChanged: (value) {
              formController.experienceController.text = value!;
              onUpdate();
            },
          ),
          const SizedBox(height: 16),

          // Duration Row
          _buildDurationRow(context),
          const SizedBox(height: 16),

          // Group Size Row
          _buildGroupSizeRow(context),
        ],
      ),
    );
  }

  Widget _buildMinAgeRow(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: buildFormField(
            context,
            controller: formController.minAgeController,
            label: loc.minimum_age,
            icon: Icons.person,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return loc.minimum_age_error;
              }
              if (int.tryParse(value) == null) {
                return loc.valid_number_error;
              }
              return null;
            },
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.year_label, style: TextStyle(color: Colors.grey)),
              SizedBox(height: 8),
              Text(
                loc.minimum_age_required,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDurationRow(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: buildFormField(
            context,
            controller: formController.durationController,
            label: loc.duration_label,
            icon: Icons.timer,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return loc.duration_error;
              }
              if (double.tryParse(value) == null) {
                return loc.valid_number_error;
              }
              return null;
            },
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.hours_label, style: TextStyle(color: Colors.grey)),
              SizedBox(height: 8),
              Text(
                loc.duration_description,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGroupSizeRow(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: buildFormField(
            context,
            controller: formController.groupSizeController,
            label: loc.group_size_label,
            icon: Icons.group,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return loc.group_size_error;
              }
              if (int.tryParse(value) == null) {
                return loc.valid_number_error;
              }
              return null;
            },
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.persons_label, style: TextStyle(color: Colors.grey)),
              SizedBox(height: 8),
              Text(
                loc.max_participants,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
