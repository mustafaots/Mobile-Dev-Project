import 'package:easy_vacation/screens/Create%20Listing%20Screen/Activity%20Listing%20Details/ActivityFormLogic.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Activity%20Listing%20Details/ActivityWidgets/CustomRequirementWidget.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Activity%20Listing%20Details/ActivityWidgets/EquipmentDropdown.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Activity%20Listing%20Details/ActivityWidgets/ExperienceDropdown.dart';
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
                'Requirements',
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
          const SizedBox(height: 24),
          
          // Custom Requirements
          CustomRequirementWidget(
            formController: formController,
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
            cardColor: cardColor,
            onUpdate: onUpdate,
          ),
        ],
      ),
    );
  }
  
  Widget _buildMinAgeRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: buildFormField(
            context,
            controller: formController.minAgeController,
            label: 'Minimum Age',
            icon: Icons.person,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter minimum age';
              }
              if (int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Years', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 8),
              Text('Minimum age required', 
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildDurationRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: buildFormField(
            context,
            controller: formController.durationController,
            label: 'Duration',
            icon: Icons.timer,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter duration';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hours', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 8),
              Text('Activity duration in hours', 
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildGroupSizeRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: buildFormField(
            context,
            controller: formController.groupSizeController,
            label: 'Maximum Group Size',
            icon: Icons.group,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter group size';
              }
              if (int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Persons', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 8),
              Text('Maximum participants allowed', 
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}