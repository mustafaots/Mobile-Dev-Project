import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'package:easy_vacation/screens/Listing%20Details%20Widgets/availability_section.dart';
import 'availability_state.dart';

class AvailabilityCubit extends Cubit<AvailabilityState> {
  final PostRepository postRepository;

  AvailabilityCubit({required this.postRepository})
    : super(const AvailabilityInitial());

  /// Load availability intervals for a specific post
  Future<void> loadAvailability(int postId) async {
    emit(const AvailabilityLoading());
    try {
      // Fetch post from repository
      final post = await postRepository.getPostById(postId);

      if (post == null) {
        // Fallback to default availability (next 365 days)
        _emitDefaultAvailability();
        return;
      }

      // Parse availability JSON from post
      List<DateInterval> availableIntervals = _parseAvailabilityJson(
        post.availability,
      );

      if (availableIntervals.isEmpty) {
        // If no availability data, use default (next 365 days)
        availableIntervals = [
          DateInterval(
            DateTime.now(),
            DateTime.now().add(const Duration(days: 365)),
          ),
        ];
      }

      emit(
        AvailabilityLoaded(
          availableIntervals: availableIntervals,
          selectedDates: const {},
        ),
      );
    } catch (e) {
      // Fallback to default availability on error
      _emitDefaultAvailability();
    }
  }

  /// Parse availability JSON into DateInterval objects
  List<DateInterval> _parseAvailabilityJson(dynamic availabilityData) {
    try {
      if (availabilityData == null) {
        return [];
      }

      // If it's already a list, convert it directly
      if (availabilityData is List) {
        return availabilityData.map((interval) {
          final startDate = DateTime.parse(interval['start'] as String);
          final endDate = DateTime.parse(interval['end'] as String);
          return DateInterval(startDate, endDate);
        }).toList();
      }

      // If it's a JSON string, decode it first
      if (availabilityData is String) {
        final Map<String, dynamic> data = jsonDecode(availabilityData);
        final List<dynamic> intervals = data['intervals'] ?? [];

        return intervals.map((interval) {
          final startDate = DateTime.parse(interval['start'] as String);
          final endDate = DateTime.parse(interval['end'] as String);
          return DateInterval(startDate, endDate);
        }).toList();
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  /// Emit default availability (all dates for next year)
  void _emitDefaultAvailability() {
    emit(
      AvailabilityLoaded(
        availableIntervals: [
          DateInterval(
            DateTime.now(),
            DateTime.now().add(const Duration(days: 365)),
          ),
        ],
        selectedDates: const {},
      ),
    );
  }

  /// Check if a specific date is available
  bool isDateAvailable(DateTime date, List<DateInterval> intervals) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return intervals.any((interval) {
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

  /// Add a date to selected dates
  void selectDate(DateTime date, List<DateInterval> intervals) {
    if (state is! AvailabilityLoaded) return;

    final currentState = state as AvailabilityLoaded;

    // Check if date is available
    if (!isDateAvailable(date, intervals)) {
      emit(currentState.copyWith(errorMessage: 'This date is not available'));
      return;
    }

    final dateOnly = DateTime(date.year, date.month, date.day);
    final newSelectedDates = Set<DateTime>.from(currentState.selectedDates);

    // Toggle selection
    if (newSelectedDates.any((d) => _isSameDay(d, dateOnly))) {
      newSelectedDates.removeWhere((d) => _isSameDay(d, dateOnly));
    } else {
      newSelectedDates.add(dateOnly);
    }

    emit(
      currentState.copyWith(
        selectedDates: newSelectedDates,
        errorMessage: null,
      ),
    );
  }

  /// Remove a date from selected dates
  void deselectDate(DateTime date) {
    if (state is! AvailabilityLoaded) return;

    final currentState = state as AvailabilityLoaded;
    final dateOnly = DateTime(date.year, date.month, date.day);
    final newSelectedDates = Set<DateTime>.from(currentState.selectedDates);

    newSelectedDates.removeWhere((d) => _isSameDay(d, dateOnly));

    emit(currentState.copyWith(selectedDates: newSelectedDates));
  }

  /// Clear all selected dates
  void clearSelectedDates() {
    if (state is! AvailabilityLoaded) return;

    final currentState = state as AvailabilityLoaded;
    emit(currentState.copyWith(selectedDates: const {}, errorMessage: null));
  }

  /// Helper function to compare dates
  bool _isSameDay(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) return false;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Get list of selected dates sorted
  List<DateTime> getSelectedDatesSorted() {
    if (state is! AvailabilityLoaded) return [];
    final currentState = state as AvailabilityLoaded;
    final sortedDates = currentState.selectedDates.toList();
    sortedDates.sort();
    return sortedDates;
  }
}
