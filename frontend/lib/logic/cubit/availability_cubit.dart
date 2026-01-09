import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'package:easy_vacation/screens/Listing%20Details%20Widgets/availability_section.dart';
import 'package:easy_vacation/services/api/api_service_locator.dart';
import 'availability_state.dart';

class AvailabilityCubit extends Cubit<AvailabilityState> {
  final PostRepository postRepository;

  AvailabilityCubit({required this.postRepository})
    : super(const AvailabilityInitial());

  /// Load availability intervals for a specific post
  Future<void> loadAvailability(int postId) async {
    emit(const AvailabilityLoading());
    try {
      // First try to get from local database
      final post = await postRepository.getPostById(postId);

      print('AvailabilityCubit.loadAvailability($postId)');
      print(' Post found: ${post != null}');

      List<DateInterval> availableIntervals = [];

      // Try local data first
      if (post != null && post.availability.isNotEmpty) {
        print(' Using local availability data');
        print(' Post.availability: ${post.availability}');
        availableIntervals = _parseAvailabilityJson(post.availability);
      }

      // If local is empty, try fetching from API
      if (availableIntervals.isEmpty) {
        print(' Local availability empty, trying API...');
        try {
          final apiResult = await ApiServiceLocator.listings.getListingById(
            postId,
          );
          if (apiResult.isSuccess && apiResult.data != null) {
            final listing = apiResult.data!;
            print(' API listing.availability: ${listing.availability}');
            if (listing.availability != null &&
                listing.availability!.isNotEmpty) {
              availableIntervals = _parseAvailabilityJson(listing.availability);
              print(
                ' Parsed ${availableIntervals.length} intervals from API',
              );

              // Update local database with the availability data
              if (post != null && availableIntervals.isNotEmpty) {
                final updatedPost = post.copyWith(
                  availability: availableIntervals
                      .map(
                        (interval) => {
                          'startDate': interval.start,
                          'endDate': interval.end,
                        },
                      )
                      .toList(),
                );
                await postRepository.updatePost(postId, updatedPost);
                print(' Updated local database with availability');
              }
            }
          }
        } catch (apiError) {
          print(' API fetch failed: $apiError');
        }
      }

      print(' Final intervals count: ${availableIntervals.length}');

      if (availableIntervals.isEmpty) {
        // If still no availability data, use default (next 365 days)
        print(' No intervals found, using default availability');
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
      print(' Error loading availability: $e');
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

      List<dynamic> intervals;

      if (availabilityData is List) {
        intervals = availabilityData;
      } else if (availabilityData is String) {
        final decoded = jsonDecode(availabilityData);
        if (decoded is Map<String, dynamic> && decoded['intervals'] is List) {
          intervals = decoded['intervals'] as List<dynamic>;
        } else if (decoded is List) {
          intervals = decoded;
        } else {
          return [];
        }
      } else {
        return [];
      }

      return intervals
          .map((interval) {
            try {
              final map = Map<String, dynamic>.from(interval as Map);
              final startValue =
                  map['startDate'] ?? map['start'] ?? map['start_date'];
              final endValue = map['endDate'] ?? map['end'] ?? map['end_date'];

              final startDate = _parseDate(startValue);
              final endDate = _parseDate(endValue);

              if (startDate == null || endDate == null) {
                return null;
              }

              return DateInterval(startDate, endDate);
            } catch (_) {
              return null;
            }
          })
          .whereType<DateInterval>()
          .toList();
    } catch (e) {
      return [];
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
