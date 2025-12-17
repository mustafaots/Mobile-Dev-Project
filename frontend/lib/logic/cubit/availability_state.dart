import 'package:easy_vacation/screens/Listing%20Details%20Widgets/availability_section.dart';

abstract class AvailabilityState {
  const AvailabilityState();
}

class AvailabilityInitial extends AvailabilityState {
  const AvailabilityInitial();
}

class AvailabilityLoading extends AvailabilityState {
  const AvailabilityLoading();
}

class AvailabilityLoaded extends AvailabilityState {
  final List<DateInterval> availableIntervals;
  final Set<DateTime> selectedDates;
  final String? errorMessage;

  const AvailabilityLoaded({
    required this.availableIntervals,
    this.selectedDates = const {},
    this.errorMessage,
  });

  AvailabilityLoaded copyWith({
    List<DateInterval>? availableIntervals,
    Set<DateTime>? selectedDates,
    String? errorMessage,
  }) {
    return AvailabilityLoaded(
      availableIntervals: availableIntervals ?? this.availableIntervals,
      selectedDates: selectedDates ?? this.selectedDates,
      errorMessage: errorMessage,
    );
  }
}

class AvailabilityError extends AvailabilityState {
  final String message;

  const AvailabilityError(this.message);
}
