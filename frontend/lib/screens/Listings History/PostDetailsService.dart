import 'dart:typed_data';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/repositories/db_repositories/images_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/location_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'package:easy_vacation/repositories/repo_factory.dart';
import 'package:easy_vacation/services/sync/listing_sync_service.dart';
import 'package:easy_vacation/services/sync/connectivity_service.dart';

class PostDetailsService {
  Future<Map<String, dynamic>> getPostDetails(Post post) async {
    try {
      Map<String, dynamic> details = {'post': post};
      
      
      // Try to get from remote first if online (includes Cloudinary image URLs)
      final isOnline = await ConnectivityService.instance.checkConnectivity();
      
      if (isOnline) {
        final syncService = await ListingSyncService.getInstance();
        final listing = await syncService.getListingById(post.id!);
        
        
        if (listing != null) {
          
          // Use remote data with Cloudinary URLs
          details['location'] = listing.location;
          details['stay_details'] = listing.stayDetails;
          details['activity_details'] = listing.activityDetails;
          details['vehicle_details'] = listing.vehicleDetails;
          
          // Get first image URL from Cloudinary
          if (listing.images.isNotEmpty) {
            details['first_image_url'] = listing.images.first;
          }
          
          return details;
        }
      }
      
      // Fallback to local database
      return await _getLocalPostDetails(post, details);
    } catch (e) {
      return {'post': post};
    }
  }
  
  Future<Map<String, dynamic>> _getLocalPostDetails(Post post, Map<String, dynamic> details) async {
    final postRepo = await RepoFactory.getRepository<PostRepository>('postRepo');
    final locationRepo = await RepoFactory.getRepository<LocationRepository>('locationRepo');
    final imageRepo = await RepoFactory.getRepository<PostImagesRepository>('imageRepo');
    
    // Get category-specific details
    switch (post.category) {
      case 'stay':
        final stay = await postRepo.getStayByPostId(post.id!);
        details['stay_details'] = stay;
        break;
      case 'activity':
        final activity = await postRepo.getActivityByPostId(post.id!);
        details['activity_details'] = activity;
        break;
      case 'vehicle':
        final vehicle = await postRepo.getVehicleByPostId(post.id!);
        details['vehicle_details'] = vehicle;
        break;
    }
    
    // Get location
    final location = await locationRepo.getLocationById(post.locationId);
    details['location'] = location;
    
    // Get image from local storage
    await _addPostImage(details, post, imageRepo, postRepo);
    
    return details;
  }

  Future<void> _addPostImage(
    Map<String, dynamic> details,
    Post post,
    PostImagesRepository imageRepo,
    PostRepository postRepo,
  ) async {
    final imageMap = await imageRepo.getImageByPostId(post.id!);
    
    if (imageMap != null && imageMap['image'] != null) {
      details['first_image_bytes'] = _convertToUint8List(imageMap['image']);
    } else {
      final postImage = await postRepo.getPostImageByPostId(post.id!);
      if (postImage != null) {
        details['first_image_path'] = postImage.imageData;
      }
    }
  }

  Uint8List? _convertToUint8List(dynamic imageData) {
    if (imageData == null) return null;
    if (imageData is Uint8List) return imageData;
    if (imageData is List<int>) return Uint8List.fromList(imageData);
    return null;
  }
}