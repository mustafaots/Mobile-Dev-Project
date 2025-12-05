import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/models/stays.model.dart';
import 'package:easy_vacation/models/vehicles.model.dart';
import 'package:easy_vacation/models/activities.model.dart';
import 'package:easy_vacation/l10n/app_localizations.dart';

part 'details_state.dart';

class DetailsCubit extends Cubit<DetailsState> {
  DetailsCubit() : super(DetailsInitial());

  Future<void> loadDetails({
    required Post? post,
    required String? category,
    required Stay? stay,
    required Vehicle? vehicle,
    required Activity? activity,
    required AppLocalizations loc,
  }) async {
    emit(DetailsLoading());
    try {
      if (post == null) {
        emit(
          DetailsLoaded(
            stayDetails: [],
            vehicleDetails: [],
            activityDetails: [],
            allDetails: [],
          ),
        );
        return;
      }

      final stayDetails = _getStayDetails(stay, loc);
      final vehicleDetails = _getVehicleDetails(vehicle, loc);
      final activityDetails = _getActivityDetails(activity, loc);

      final allDetails = _buildAllDetails(
        post: post,
        category: category,
        stayDetails: stayDetails,
        vehicleDetails: vehicleDetails,
        activityDetails: activityDetails,
        loc: loc,
      );

      emit(
        DetailsLoaded(
          stayDetails: stayDetails,
          vehicleDetails: vehicleDetails,
          activityDetails: activityDetails,
          allDetails: allDetails,
        ),
      );
    } catch (e) {
      emit(DetailsError('Failed to load details: ${e.toString()}'));
    }
  }

  List<Map<String, dynamic>> _buildAllDetails({
    required Post post,
    required String? category,
    required List<Map<String, dynamic>> stayDetails,
    required List<Map<String, dynamic>> vehicleDetails,
    required List<Map<String, dynamic>> activityDetails,
    required AppLocalizations loc,
  }) {
    final details = <Map<String, dynamic>>[];

    // Add description if available
    if (post.description != null && post.description!.isNotEmpty) {
      details.add({
        'icon': 'description',
        'label': loc.details_description,
        'value': post.description!,
      });
    }

    // Get the category from parameter or post
    final cat = (category ?? post.category).toLowerCase();

    // Add category-specific details based on category
    if (cat == 'stay') {
      details.addAll(stayDetails);
    } else if (cat == 'vehicle') {
      details.addAll(vehicleDetails);
    } else if (cat == 'activity') {
      details.addAll(activityDetails);
    }

    return details;
  }

  List<Map<String, dynamic>> _getStayDetails(Stay? stay, AppLocalizations loc) {
    if (stay == null) return [];

    return [
      {
        'icon': 'home',
        'label': loc.details_stayType,
        'value': stay.stayType.replaceFirst(
          stay.stayType[0],
          stay.stayType[0].toUpperCase(),
        ),
      },
      {
        'icon': 'bed',
        'label': loc.details_bedrooms,
        'value': '${stay.bedrooms}',
      },
      {
        'icon': 'square_foot',
        'label': loc.details_area,
        'value': '${stay.area} m²',
      },
    ];
  }

  List<Map<String, dynamic>> _getVehicleDetails(
    Vehicle? vehicle,
    AppLocalizations loc,
  ) {
    if (vehicle == null) return [];

    final details = <Map<String, dynamic>>[
      {
        'icon': 'directions_car',
        'label': loc.details_vehicleType,
        'value': vehicle.vehicleType.replaceFirst(
          vehicle.vehicleType[0],
          vehicle.vehicleType[0].toUpperCase(),
        ),
      },
      {
        'icon': 'card_travel',
        'label': loc.details_model,
        'value': vehicle.model,
      },
      {
        'icon': 'calendar_today',
        'label': loc.details_year,
        'value': '${vehicle.year}',
      },
      {
        'icon': 'local_gas_station',
        'label': loc.details_fuelType,
        'value': vehicle.fuelType.replaceFirst(
          vehicle.fuelType[0],
          vehicle.fuelType[0].toUpperCase(),
        ),
      },
      {
        'icon': 'car_rental',
        'label': loc.details_transmission,
        'value': vehicle.transmission
            ? loc.details_automatic
            : loc.details_manual,
      },
      {
        'icon': 'people',
        'label': loc.details_seats,
        'value': '${vehicle.seats}',
      },
    ];

    // Add features if available
    if (vehicle.features != null && vehicle.features!.isNotEmpty) {
      details.add({
        'icon': 'sensors',
        'label': loc.details_features,
        'value': vehicle.features!.entries
            .map((e) => '${e.key}: ${e.value}')
            .join(', '),
      });
    }

    return details;
  }

  List<Map<String, dynamic>> _getActivityDetails(
    Activity? activity,
    AppLocalizations loc,
  ) {
    if (activity == null) return [];

    final details = <Map<String, dynamic>>[
      {
        'icon': 'info',
        'label': loc.details_activityType,
        'value': activity.activityType.replaceFirst(
          activity.activityType[0],
          activity.activityType[0].toUpperCase(),
        ),
      },
    ];

    // Add requirements if available
    if (activity.requirements.isNotEmpty) {
      for (var entry in activity.requirements.entries) {
        details.add({
          'icon': 'check_circle',
          'label': _formatRequirementLabel(entry.key),
          'value': entry.value.toString(),
        });
      }
    }

    return details;
  }

  String _formatRequirementLabel(String key) {
    return key
        .replaceAll(RegExp(r'_'), ' ')
        .replaceAll(RegExp(r'([A-Z])'), ' \$1')
        .trim()
        .split(' ')
        .map(
          (word) =>
              word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1),
        )
        .join(' ');
  }

  String getPriceUnit(String? category, AppLocalizations loc) {
    final cat = (category ?? '').toLowerCase();
    switch (cat) {
      case 'stay':
        return loc.details_pricePerNight;
      case 'vehicle':
        return loc.details_pricePerDay;
      case 'activity':
        return loc.details_pricePerPerson;
      default:
        return loc.details_pricePerUnit;
    }
  }
}
