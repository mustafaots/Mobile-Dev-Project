import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:flutter/material.dart';

class ListingsHistoryFilter extends StatelessWidget {
  final String currentFilter;
  final Function(String) onFilterChanged;

  const ListingsHistoryFilter({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(loc.listingHistory_all, 'all', context),
            const SizedBox(width: 8),
            _buildFilterChip(loc.listingHistory_active, 'active', context),
            const SizedBox(width: 8),
            _buildFilterChip(loc.listingHistory_drafts, 'draft', context),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, BuildContext context) {
    final isSelected = currentFilter == value;
    final backgroundColor = context.scaffoldBackgroundColor;
    final secondaryTextColor = context.secondaryTextColor;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onFilterChanged(value),
      backgroundColor: backgroundColor,
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryColor : secondaryTextColor,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppTheme.primaryColor : secondaryTextColor.withOpacity(0.3),
        ),
      ),
    );
  }
}