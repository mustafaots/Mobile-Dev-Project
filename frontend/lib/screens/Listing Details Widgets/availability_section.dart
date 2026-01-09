import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/logic/cubit/availability_cubit.dart';
import 'package:easy_vacation/logic/cubit/availability_state.dart';
import 'package:easy_vacation/utils/error_helper.dart';

class AvailabilitySection extends StatefulWidget {
  final String? availabilityJson;
  final Function(List<DateTime> selectedDates)? onDatesSelected;
  final int? postId;
  final AvailabilityCubit? cubit;

  const AvailabilitySection({
    super.key,
    this.availabilityJson,
    this.onDatesSelected,
    this.postId,
    this.cubit,
  });

  @override
  State<AvailabilitySection> createState() => _AvailabilitySectionState();
}

class _AvailabilitySectionState extends State<AvailabilitySection> {
  late DateTime _focusedDay;
  late AvailabilityCubit _availabilityCubit;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();

    // Use provided cubit or create a new one if postId is provided
    if (widget.cubit != null) {
      _availabilityCubit = widget.cubit!;
    } else if (widget.postId != null) {
      _availabilityCubit = AvailabilityCubit(postRepository: context.read());
      _availabilityCubit.loadAvailability(widget.postId!);
    } else if (widget.availabilityJson != null) {
      // Fallback to parsing the JSON string if no cubit or postId provided
      _availabilityCubit = AvailabilityCubit(postRepository: context.read());
      _parseAvailabilityJsonFallback();
    }
  }

  void _parseAvailabilityJsonFallback() {
    // This is kept for backward compatibility with the old approach
    if (widget.availabilityJson == null || widget.availabilityJson!.isEmpty) {
      return;
    }

    final decoded = jsonDecode(widget.availabilityJson!);
    List<dynamic> intervals;

    if (decoded is Map<String, dynamic> && decoded['intervals'] is List) {
      intervals = decoded['intervals'] as List<dynamic>;
    } else if (decoded is List) {
      intervals = decoded;
    } else {
      return;
    }

    final availableIntervals = intervals
        .map((interval) {
          try {
            final map = Map<String, dynamic>.from(interval as Map);
            final startValue = map['startDate'] ?? map['start'] ?? map['start_date'];
            final endValue = map['endDate'] ?? map['end'] ?? map['end_date'];

            final startDate = _parseDate(startValue);
            final endDate = _parseDate(endValue);

            if (startDate == null || endDate == null) return null;
            return DateInterval(startDate, endDate);
          } catch (_) {
            return null;
          }
        })
        .whereType<DateInterval>()
        .toList();

    if (availableIntervals.isNotEmpty) {
      // Manually emit the state if not already loaded
      if (_availabilityCubit.state is AvailabilityInitial) {
        _availabilityCubit.emit(
          AvailabilityLoaded(
            availableIntervals: availableIntervals,
            selectedDates: const {},
          ),
        );
      }
    }
  }

  DateTime? _parseDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  bool _isDateAvailable(DateTime date, List<DateInterval> intervals) {
    return _availabilityCubit.isDateAvailable(date, intervals);
  }

  bool _isDateInSelectedRange(DateTime date, Set<DateTime> selectedDates) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return selectedDates.any((selectedDate) {
      final selectedOnly = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );
      return dateOnly == selectedOnly;
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

    return BlocBuilder<AvailabilityCubit, AvailabilityState>(
      bloc: _availabilityCubit,
      builder: (context, state) {
        if (state is AvailabilityLoading) {
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
            child: Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            ),
          );
        }

        if (state is AvailabilityError) {
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
            child: Center(
              child: Text(
                ErrorHelper.getLocalizedMessageFromString(state.message, context),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (state is AvailabilityLoaded) {
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
                  selectedDayPredicate: (day) =>
                      _isDateInSelectedRange(day, state.selectedDates),
                  onDaySelected: (selectedDay, focusedDay) {
                    if (_availabilityCubit.isDateAvailable(
                      selectedDay,
                      state.availableIntervals,
                    )) {
                      _availabilityCubit.selectDate(
                        selectedDay,
                        state.availableIntervals,
                      );
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                      // Notify parent
                      if (widget.onDatesSelected != null) {
                        widget.onDatesSelected!(
                          _availabilityCubit.getSelectedDatesSorted(),
                        );
                      }
                    }
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: TextStyle(color: textColor, fontSize: 14),
                    weekendTextStyle: TextStyle(color: textColor, fontSize: 14),
                    disabledTextStyle: TextStyle(
                      color: secondaryTextColor.withOpacity(0.5),
                      fontSize: 14,
                      decoration: TextDecoration.lineThrough,
                    ),
                    disabledDecoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    defaultDecoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    weekendDecoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    todayDecoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.primaryColor,
                        width: 1.5,
                      ),
                    ),
                    todayTextStyle: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
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
                    selectedBuilder: (context, day, focusedDay) {
                      return Container(
                        margin: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },

                    defaultBuilder: (context, day, focusedDay) {
                      final isAvailable = _availabilityCubit.isDateAvailable(
                        day,
                        state.availableIntervals,
                      );

                      if (!isAvailable) {
                        return Container(
                          margin: const EdgeInsets.all(6),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                color: secondaryTextColor.withOpacity(0.5),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                        );
                      }

                      return Container(
                        margin: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(color: textColor),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Error message display
                if (state.errorMessage != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
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
                            state.errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Selected dates display
                if (state.selectedDates.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected Dates (${state.selectedDates.length})',
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
                          children: state.selectedDates.map((date) {
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
                                      _availabilityCubit.deselectDate(date);
                                      // Notify parent
                                      if (widget.onDatesSelected != null) {
                                        widget.onDatesSelected!(
                                          _availabilityCubit
                                              .getSelectedDatesSorted(),
                                        );
                                      }
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

        return const SizedBox.shrink();
      },
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

  @override
  void dispose() {
    // Only dispose if we created the cubit (not provided)
    if (widget.cubit == null && widget.postId != null) {
      _availabilityCubit.close();
    }
    super.dispose();
  }
}

/// Represents a date interval with start and end dates
class DateInterval {
  final DateTime start;
  final DateTime end;

  DateInterval(this.start, this.end);
}
