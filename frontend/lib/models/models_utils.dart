// Helper functions for JSON serialization
import 'dart:convert';
import 'package:easy_vacation/models/activities.model.dart';
import 'package:easy_vacation/models/details.model.dart';
import 'package:easy_vacation/models/post_images.model.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/models/stays.model.dart';
import 'package:easy_vacation/models/vehicles.model.dart';

Map<String, dynamic> parseAvailabilityJson(String jsonString) {
  try {
    return jsonDecode(jsonString);
  } catch (e) {
    return {};
  }
}

String encodeAvailabilityJson(List<Map<String, dynamic>> availability) {
  final normalized = availability
      .map(
        (interval) => interval.map(
          (key, value) => MapEntry(
            key,
            value is DateTime ? value.toIso8601String() : value,
          ),
        ),
      )
      .toList();
  return jsonEncode(normalized);
}

// Convert between your CreatePostData and database models
class PostConverter {
  static Post toPost(CreatePostData data, String ownerId) {
    return Post(
      ownerId: ownerId,
      category: data.category,
      title: data.title,
      description: data.description,
      price: data.price,
      locationId: 0, // Will be set after location is saved
      availability: data.availability.map((a) => a.toMap()).toList(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: 'draft',
    );
  }

  static Stay toStay(int postId, CreatePostData data) {
    if (data.stayDetails == null) {
      throw Exception('Stay details are required for stay posts');
    }
    return Stay.fromStayDetails(postId, data.stayDetails!);
  }

  static Activity toActivity(int postId, CreatePostData data) {
    if (data.activityDetails == null) {
      throw Exception('Activity details are required for activity posts');
    }
    return Activity.fromActivityDetails(postId, data.activityDetails!);
  }

  static Vehicle toVehicle(int postId, CreatePostData data) {
    if (data.vehicleDetails == null) {
      throw Exception('Vehicle details are required for vehicle posts');
    }
    return Vehicle.fromVehicleDetails(postId, data.vehicleDetails!);
  }

  static List<PostImage> toPostImages(int postId, List<String> imagePaths) {
    return imagePaths
        .map((path) => PostImage(postId: postId, imageData: path))
        .toList();
  }
}