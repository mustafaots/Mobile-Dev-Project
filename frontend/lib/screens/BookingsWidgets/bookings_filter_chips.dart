import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/logic/cubit/bookings_cubit.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Filter chips widget for booking status filtering
class BookingsFilterChips extends StatelessWidget {
  final String selectedFilter;

  const BookingsFilterChips({super.key, required this.selectedFilter});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final loc = AppLocalizations.of(context)!;

    final filterOptions = [
      {'key': 'all', 'label': loc.bookings_all},
      {'key': 'pending', 'label': loc.bookings_pending},
      {'key': 'confirmed', 'label': loc.bookings_confirmed},
      {'key': 'rejected', 'label': loc.bookings_rejected},
    ];

    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: filterOptions.asMap().entries.map((entry) {
          final index = entry.key;
          final filter = entry.value;
          final isSelected = selectedFilter == filter['key'];

          return Padding(
            padding: EdgeInsets.only(
              right: index < filterOptions.length - 1 ? 8 : 0,
            ),
            child: FilterChip(
              label: Text(filter['label']!),
              selected: isSelected,
              checkmarkColor: backgroundColor,
              selectedShadowColor: backgroundColor,
              onSelected: (_) {
                context.read<BookingsCubit>().setFilter(filter['key']!);
              },
              backgroundColor: backgroundColor,
              selectedColor: AppTheme.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? backgroundColor : textColor,
                fontWeight: FontWeight.w500,
              ),
              shape: StadiumBorder(
                side: BorderSide(color: secondaryTextColor.withOpacity(0.3)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
