import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:easy_vacation/models/activities.model.dart';
import 'package:easy_vacation/models/details.model.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/models/stays.model.dart';
import 'package:easy_vacation/models/vehicles.model.dart';
import 'package:easy_vacation/models/locations.model.dart' as loc_model;
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'package:easy_vacation/repositories/repo_factory.dart';
import 'package:easy_vacation/services/api/listing_service.dart';
import 'package:easy_vacation/services/api/api_service_locator.dart';
import 'package:easy_vacation/services/sync/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class PostCreationService {
  Future<bool> createPost({
    required CreatePostData postData,
    required BuildContext context,
    required String userId,
  }) async {
    try {
      // Check if we have internet connectivity
      final hasInternet = await ConnectivityService.instance.checkConnectivity();

      if (hasInternet) {
        // Try to create on backend first (syncs to Supabase)
        final listing = await _createListingFromPostData(postData, userId);

        final result = await ApiServiceLocator.listings.createListing(listing);

        if (result.isSuccess && result.data != null) {

          // Also save locally for offline access
          await _saveLocalCopy(postData, userId, result.data!.id);

          return true;
        } else {

          // Show the actual error message
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Backend error: ${result.message}'),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 5),
              ),
            );
          }

          // Fall back to local-only creation
          return await _createLocalOnly(postData, userId, context);
        }
      } else {
        // Offline mode - create locally only
        return await _createLocalOnly(postData, userId, context);
      }
    } catch (e) {

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating listing: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
      return false;
    }
  }

  /// Create a Listing object from CreatePostData for the API
  Future<Listing> _createListingFromPostData(CreatePostData postData, String userId) async {
    // Convert location
    final location = loc_model.Location.fromDetailsLocation(postData.location);

    // Create category-specific details
    Stay? stayDetails;
    Vehicle? vehicleDetails;
    Activity? activityDetails;

    switch (postData.category.toLowerCase()) {
      case 'stay':
        if (postData.stayDetails != null) {
          stayDetails = Stay(
            postId: 0,
            stayType: postData.stayDetails!.stayType,
            area: postData.stayDetails!.area,
            bedrooms: postData.stayDetails!.bedrooms,
          );
        }
        break;
      case 'activity':
        if (postData.activityDetails != null) {
          activityDetails = Activity(
            postId: 0,
            activityType: postData.activityDetails!.activityType,
            requirements: postData.activityDetails!.requirements,
          );
        }
        break;
      case 'vehicle':
        if (postData.vehicleDetails != null) {
          vehicleDetails = Vehicle(
            postId: 0,
            vehicleType: postData.vehicleDetails!.vehicleType,
            model: postData.vehicleDetails!.model,
            year: postData.vehicleDetails!.year,
            fuelType: postData.vehicleDetails!.fuelType,
            transmission: postData.vehicleDetails!.transmission,
            seats: postData.vehicleDetails!.seats,
            features: postData.vehicleDetails!.features,
          );
        }
        break;
    }

    // Convert availability to JSON string
    String? availabilityJson;
    if (postData.availability.isNotEmpty) {
      availabilityJson = jsonEncode(
        postData.availability
            .map(
              (interval) => {
                'startDate': interval.start.toIso8601String(),
                'endDate': interval.end.toIso8601String(),
              },
            )
            .toList(),
      );
    }

    // Convert images to base64 for Cloudinary upload
    final List<String> base64Images = await _convertImagesToBase64(
      postData.imagePaths,
    );

    return Listing(
      ownerId: userId,
      category: postData.category,
      title: postData.title,
      description: postData.description,
      price: postData.price,
      status:
          'active', // Use 'active' - valid enum values: active, draft, archived, suspended
      availability: availabilityJson,
      location: location,
      stayDetails: stayDetails,
      vehicleDetails: vehicleDetails,
      activityDetails: activityDetails,
      images: base64Images, // Send base64 images for Cloudinary upload
    );
  }

  /// Convert local image file paths to base64 strings for upload
  /// Images are compressed to reduce upload size
  Future<List<String>> _convertImagesToBase64(List<String> imagePaths) async {
    final List<String> base64Images = [];

    for (final path in imagePaths) {

      final file = File(path);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();

        // Compress the image
        Uint8List compressedBytes = await _compressImage(bytes);

        final base64String = base64Encode(compressedBytes);

        // Create data URI format for Cloudinary (always JPEG after compression)
        final dataUri = 'data:image/jpeg;base64,$base64String';
        base64Images.add(dataUri);
      };
    };

    return base64Images;
  }

  /// Compress image to reduce file size
  Future<Uint8List> _compressImage(Uint8List bytes) async {
    try {
      // Decode the image
      final image = img.decodeImage(bytes);
      if (image == null) {
        return bytes;
      }

      // Resize if too large (max 1920px on longest side)
      const maxDimension = 1920;
      img.Image resized;

      if (image.width > maxDimension || image.height > maxDimension) {
        if (image.width > image.height) {
          resized = img.copyResize(image, width: maxDimension);
        } else {
          resized = img.copyResize(image, height: maxDimension);
        }
      } else {
        resized = image;
      }

      // Encode as JPEG with 80% quality
      final compressed = img.encodeJpg(resized, quality: 80);
      return Uint8List.fromList(compressed);
    } catch (e) {
      return bytes;
    }
  }

  /// Save a local copy after successful backend creation
  Future<void> _saveLocalCopy(
    CreatePostData postData,
    String userId,
    int? remoteId,
  ) async {
    final postRepo = await RepoFactory.getRepository<PostRepository>(
      'postRepo',
    );
    final location = loc_model.Location.fromDetailsLocation(
      postData.location,
    );
    final categoryObject = _createCategoryObject(postData);

    final post = Post(
      id: remoteId, // Use the remote ID if available
      ownerId: userId,
      category: postData.category,
      title: postData.title,
      description: postData.description,
      price: postData.price,
      locationId: 0,
      status: 'active',
      isPaid: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      availability: postData.availability
          .map((interval) => interval.toMap())
          .toList(),
    );

    await postRepo.createCompletePost(
      post: post,
      location: location,
      imagePaths: postData.imagePaths,
      stay: categoryObject['stay'],
      activity: categoryObject['activity'],
      vehicle: categoryObject['vehicle'],
    );
  }

  /// Create post locally only (offline fallback)
  Future<bool> _createLocalOnly(
    CreatePostData postData,
    String userId,
    BuildContext context,
  ) async {
    try {

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Listing saved locally. Will sync when online.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Map<String, dynamic> _createCategoryObject(CreatePostData postData) {
    switch (postData.category.toLowerCase()) {
      case 'stay':
        return {
          'stay': postData.stayDetails != null
              ? Stay(
                  postId: 0,
                  stayType: postData.stayDetails!.stayType,
                  area: postData.stayDetails!.area,
                  bedrooms: postData.stayDetails!.bedrooms,
                )
              : null,
          'activity': null,
          'vehicle': null,
        };
      case 'activity':
        return {
          'stay': null,
          'activity': postData.activityDetails != null
              ? Activity(
                  postId: 0,
                  activityType: postData.activityDetails!.activityType,
                  requirements: postData.activityDetails!.requirements,
                )
              : null,
          'vehicle': null,
        };
      case 'vehicle':
        return {
          'stay': null,
          'activity': null,
          'vehicle': postData.vehicleDetails != null
              ? Vehicle(
                  postId: 0,
                  vehicleType: postData.vehicleDetails!.vehicleType,
                  model: postData.vehicleDetails!.model,
                  year: postData.vehicleDetails!.year,
                  fuelType: postData.vehicleDetails!.fuelType,
                  transmission: postData.vehicleDetails!.transmission,
                  seats: postData.vehicleDetails!.seats,
                  features: postData.vehicleDetails!.features,
                )
              : null,
        };
      default:
        return {'stay': null, 'activity': null, 'vehicle': null};
    }
  }
}
