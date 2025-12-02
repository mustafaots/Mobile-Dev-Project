import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';

class AvailabilitySection extends StatefulWidget {
  final String? availabilityJson;
  final Function(List<DateTime> selectedDates)? onDatesSelected;

  const AvailabilitySection({
    super.key,
    this.availabilityJson,
    this.onDatesSelected,
  });

  @override
  State<AvailabilitySection> createState() => _AvailabilitySectionState();
}

class _AvailabilitySectionState extends State<AvailabilitySection> {
  late DateTime _focusedDay;
  Set<DateTime> _selectedDates = {};
  String? _errorMessage;
  List<DateInterval> _availableIntervals = [];

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _parseAvailabilityJson();
  }

  void _parseAvailabilityJson() {
    if (widget.availabilityJson == null || widget.availabilityJson!.isEmpty) {
      // Default: all dates are available
      _availableIntervals = [
        DateInterval(
          DateTime.now(),
          DateTime.now().add(const Duration(days: 4)),
        ),
      ];
      return;
    }

    try {
      final Map<String, dynamic> data = jsonDecode(widget.availabilityJson!);
      final List<dynamic> intervals = data['intervals'] ?? [];

      _availableIntervals = intervals.map((interval) {
        final startDate = DateTime.parse(interval['start'] as String);
        final endDate = DateTime.parse(interval['end'] as String);
        return DateInterval(startDate, endDate);
      }).toList();
    } catch (e) {
      debugPrint('Error parsing availability JSON: $e');
      // Default fallback
      _availableIntervals = [
        DateInterval(
          DateTime.now(),
          DateTime.now().add(const Duration(days: 365)),
        ),
      ];
    }
  }

  bool _isDateAvailable(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return _availableIntervals.any((interval) {
      final start = DateTime(
        interval.start.year,
        interval.start.month,
        interval.start.day,
      );
      final end = DateTime(
        interval.end.year,
        interval.end.month,
        interval.end.day,
      );
      return !dateOnly.isBefore(start) && !dateOnly.isAfter(end);
    });
  }

  bool _isDateInSelectedRange(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return _selectedDates.any((selectedDate) {
      final selectedOnly = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );
      return dateOnly == selectedOnly;
    });
  }

  bool _isRangeFullyAvailable(DateTime start, DateTime end) {
    final startOnly = DateTime(start.year, start.month, start.day);
    final endOnly = DateTime(end.year, end.month, end.day);

    for (var i = 0; i <= endOnly.difference(startOnly).inDays; i++) {
      final checkDate = startOnly.add(Duration(days: i));
      if (!_isDateAvailable(checkDate)) {
        return false;
      }
    }
    return true;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _errorMessage = null;

      // Only allow selection of available dates
      if (!_isDateAvailable(selectedDay)) {
        _errorMessage = 'This date is not available';
        return;
      }

      final selectedDayOnly = DateTime(
        selectedDay.year,
        selectedDay.month,
        selectedDay.day,
      );

      // Toggle selection: if date is already selected, remove it; otherwise add it
      if (_selectedDates.any((date) => _isSameDay(date, selectedDayOnly))) {
        _selectedDates.removeWhere((date) => _isSameDay(date, selectedDayOnly));
      } else {
        _selectedDates.add(selectedDayOnly);
      }

      _focusedDay = focusedDay;

      // Notify parent widget if callback is provided
      if (widget.onDatesSelected != null) {
        widget.onDatesSelected!(_selectedDates.toList()..sort());
      }
    });
  }

  bool _isSameDay(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) return false;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final cardColor = context.cardColor;
    final secondaryTextColor = context.secondaryTextColor;

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
          // Calendar widget
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => _isDateInSelectedRange(day),
            onDaySelected: (selectedDay, focusedDay) {
              // Only allow selection if the date is available
              if (_isDateAvailable(selectedDay)) {
                _onDaySelected(selectedDay, focusedDay);
              } else {
                // Show error for unavailable dates
                setState(() {
                  _errorMessage = 'This date is not available';
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: CalendarStyle(
              // Available dates styling - highlight them
              defaultTextStyle: TextStyle(color: textColor, fontSize: 14),
              weekendTextStyle: TextStyle(color: textColor, fontSize: 14),
              // Unavailable dates styling - greyed out and unclickable
              disabledTextStyle: TextStyle(
                color: secondaryTextColor.withOpacity(0.5),
                fontSize: 14,
                decoration: TextDecoration.lineThrough,
              ),
              disabledDecoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              // Highlight available dates with light background
              defaultDecoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              weekendDecoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              // Selected day styling
              selectedDecoration: BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              // Today styling
              todayDecoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primaryColor, width: 1.5),
              ),
              todayTextStyle: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
              // Outside month styling - not clickable
              outsideTextStyle: TextStyle(
                color: secondaryTextColor.withOpacity(0.3),
                fontSize: 14,
              ),
              cellMargin: const EdgeInsets.all(6),
              cellPadding: const EdgeInsets.all(8),
              rowDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: secondaryTextColor,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: secondaryTextColor,
              ),
              headerPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: secondaryTextColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              weekendStyle: TextStyle(
                color: secondaryTextColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                // Check if date is available
                final isAvailable = _isDateAvailable(day);
                final isSelected = _isDateInSelectedRange(day);

                if (!isAvailable) {
                  // Show unavailable dates as disabled
                  return Container(
                    margin: const EdgeInsets.all(6),
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: secondaryTextColor.withOpacity(0.5),
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                  );
                }

                // For available dates, return null to use the default styling
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          // Error message display
          if (_errorMessage != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          // Selected dates display
          if (_selectedDates.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Dates (${_selectedDates.length})',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selectedDates.map((date) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatDate(date),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedDates.removeWhere(
                                    (d) => _isSameDay(d, date),
                                  );
                                  if (widget.onDatesSelected != null) {
                                    widget.onDatesSelected!(
                                      _selectedDates.toList()..sort(),
                                    );
                                  }
                                });
                              },
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class DateInterval {
  final DateTime start;
  final DateTime end;

  DateInterval(this.start, this.end);
}
