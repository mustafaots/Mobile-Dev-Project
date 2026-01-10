import 'dart:convert';
import 'package:easy_vacation/models/details.model.dart';

// extends activity details

class Activity {
  final int postId;
  final String activityType; // "tour", "workshop", "adventure", etc.
  final Map<String, dynamic> requirements;

  Activity({
    required this.postId,
    required this.activityType,
    required this.requirements,
  });

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'activity_type': activityType,
      'requirements': jsonEncode(requirements),
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> requirements = {};
    final rawRequirements = map['requirements'];
    if (rawRequirements != null) {
      if (rawRequirements is String) {
        requirements = Map<String, dynamic>.from(jsonDecode(rawRequirements));
      } else if (rawRequirements is Map) {
        requirements = Map<String, dynamic>.from(rawRequirements);
      }
    }

    return Activity(
      postId: map['post_id'] ?? 0,
      activityType: map['activity_type'] ?? '',
      requirements: requirements,
    );
  }

  // Convert from your existing ActivityDetails
  factory Activity.fromActivityDetails(int postId, ActivityDetails details) {
    return Activity(
      postId: postId,
      activityType: details.activityType,
      requirements: details.requirements,
    );
  }
}
