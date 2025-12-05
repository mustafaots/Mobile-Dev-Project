part of 'details_cubit.dart';

abstract class DetailsState {}

class DetailsInitial extends DetailsState {}

class DetailsLoading extends DetailsState {}

class DetailsLoaded extends DetailsState {
  final List<Map<String, dynamic>> stayDetails;
  final List<Map<String, dynamic>> vehicleDetails;
  final List<Map<String, dynamic>> activityDetails;
  final List<Map<String, dynamic>> allDetails;

  DetailsLoaded({
    required this.stayDetails,
    required this.vehicleDetails,
    required this.activityDetails,
    required this.allDetails,
  });
}

class DetailsError extends DetailsState {
  final String message;
  DetailsError(this.message);
}
