import 'package:easy_vacation/models/activities.model.dart';
import 'package:easy_vacation/models/details.model.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/models/stays.model.dart';
import 'package:easy_vacation/models/vehicles.model.dart';
import 'package:easy_vacation/models/locations.model.dart' as loc_model;
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'package:easy_vacation/repositories/repo_factory.dart';
import 'package:flutter/material.dart';

class PostCreationService {
  Future<bool> createPost({
    required CreatePostData postData,
    required BuildContext context,
    required int userId
  }) async {
    try {
      print('🚀 Starting post creation...');
      
      final postRepo = await RepoFactory.getRepository<PostRepository>('postRepo');
      
      // Create Post object
      final post = Post(
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
      
      // Convert location
      final location = loc_model.Location.fromDetailsLocation(postData.location);
      
      // Create category-specific object
      final categoryObject = _createCategoryObject(postData);
      
      // Insert into database
      final postId = await postRepo.createCompletePost(
        post: post,
        location: location,
        imagePaths: postData.imagePaths,
        stay: categoryObject['stay'],
        activity: categoryObject['activity'],
        vehicle: categoryObject['vehicle'],
      );
      
      print('✅ Post created successfully with ID: $postId');
      return true;
      
    } catch (e, stackTrace) {
      print('❌ Error creating post: $e');
      print('❌ Stack trace: $stackTrace');
      
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