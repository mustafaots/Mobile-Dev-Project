import 'package:flutter/material.dart';
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';

class AvailabilitySection extends StatefulWidget {
  const AvailabilitySection({super.key});

  @override
  State<AvailabilitySection> createState() => _AvailabilitySectionState();
}

class _AvailabilitySectionState extends State<AvailabilitySection> {
  late DateTime _currentMonth;
  late DateTime _selectedStartDate;
  late DateTime _selectedEndDate;

  // Define unavailable dates
  static final List<DateTime> _unavailableDates = [
    DateTime(2024, 5, 13),
    DateTime(2024, 5, 14),
    DateTime(2024, 5, 23),
    DateTime(2024, 5, 24),
  ];

  static const List<String> _weekDays = [
    'Su',
    'Mo',
    'Tu',
    'We',
    'Th',
    'Fr',
    'Sa',
  ];

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(2024, 5, 1);
    _selectedStartDate = DateTime(2024, 5, 7);
    _selectedEndDate = DateTime(2024, 5, 10);
  }

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final cardColor = context.cardColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.listingDetails_availability,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCalendarGrid(context),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(BuildContext context) {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;

    return Column(
      children: [
        // Month selector
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _previousMonth,
                icon: Icon(Icons.chevron_left, color: secondaryTextColor),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Text(
                _formatMonth(_currentMonth),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              IconButton(
                onPressed: _nextMonth,
                icon: Icon(Icons.chevron_right, color: secondaryTextColor),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Week days header
        Row(
          children: _weekDays
              .map(
                (day) => Expanded(
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: secondaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),

        // Calendar days
        ..._buildCalendarDays(context, textColor, secondaryTextColor),
      ],
    );
  }

  List<Widget> _buildCalendarDays(
    BuildContext context,
    Color textColor,
    Color secondaryTextColor,
  ) {
    final days = <DateTime>[];
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final previousMonth = DateTime(_currentMonth.year, _currentMonth.month, 0);

    // Add previous month's days
    for (int i = firstDay.weekday - 1; i > 0; i--) {
      days.add(previousMonth.subtract(Duration(days: i - 1)));
    }

    // Add current month's days
    for (int i = 1; i <= lastDay.day; i++) {
      days.add(DateTime(_currentMonth.year, _currentMonth.month, i));
    }

    // Add next month's days
    final remainingDays = 42 - days.length;
    for (int i = 1; i <= remainingDays; i++) {
      days.add(DateTime(_currentMonth.year, _currentMonth.month + 1, i));
    }

    // Split into weeks
    final weeks = <List<DateTime>>[];
    for (int i = 0; i < days.length; i += 7) {
      weeks.add(days.sublist(i, i + 7));
    }

    return weeks
        .map(
          (week) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: week
                  .map(
                    (day) => _buildDayCell(
                      context,
                      day,
                      textColor,
                      secondaryTextColor,
                    ),
                  )
                  .toList(),
            ),
          ),
        )
        .toList();
  }

  Widget _buildDayCell(
    BuildContext context,
    DateTime day,
    Color textColor,
    Color secondaryTextColor,
  ) {
    final isCurrentMonth = day.month == _currentMonth.month;
    final isUnavailable = _unavailableDates.any(
      (d) => d.year == day.year && d.month == day.month && d.day == day.day,
    );
    final isInRange = _isDateInRange(day);
    final isStartDate = _isSameDay(day, _selectedStartDate);
    final isEndDate = _isSameDay(day, _selectedEndDate);

    return Expanded(
      child: GestureDetector(
        onTap: isCurrentMonth && !isUnavailable ? () => _selectDate(day) : null,
        child: Container(
          height: 36,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: isInRange && !isStartDate && !isEndDate
                ? AppTheme.primaryColor.withOpacity(0.15)
                : (isStartDate || isEndDate
                      ? AppTheme.primaryColor
                      : Colors.transparent),
            borderRadius: BorderRadius.circular(8),
            border: (isStartDate || isEndDate)
                ? Border.all(color: AppTheme.primaryColor, width: 1.5)
                : null,
          ),
          child: Center(
            child: Text(
              day.day.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: (isStartDate || isEndDate)
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: isUnavailable
                    ? secondaryTextColor.withOpacity(0.5)
                    : (isCurrentMonth
                          ? textColor
                          : secondaryTextColor.withOpacity(0.5)),
                decoration: isUnavailable ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _isDateInRange(DateTime date) {
    if (_isSameDay(_selectedStartDate, _selectedEndDate)) {
      return _isSameDay(date, _selectedStartDate);
    }
    return date.isAfter(_selectedStartDate) &&
            date.isBefore(_selectedEndDate) ||
        _isSameDay(date, _selectedStartDate) ||
        _isSameDay(date, _selectedEndDate);
  }

  void _selectDate(DateTime date) {
    setState(() {
      // If clicking on same as start, clear selection
      if (_isSameDay(date, _selectedStartDate) &&
          _isSameDay(date, _selectedEndDate)) {
        _selectedStartDate = date;
        _selectedEndDate = date;
        return;
      }

      // If date is before start date, set as new start
      if (date.isBefore(_selectedStartDate)) {
        _selectedStartDate = date;
        return;
      }

      // If we have a range and click before end, replace start
      if (!_isSameDay(_selectedStartDate, _selectedEndDate) &&
          date.isBefore(_selectedEndDate)) {
        _selectedStartDate = date;
        return;
      }

      // Otherwise set as end date
      _selectedEndDate = date;
    });
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  String _formatMonth(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
