import 'dart:typed_data';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/repositories/db_repositories/images_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/location_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'package:easy_vacation/repositories/repo_factory.dart';

class PostDetailsService {
  Future<Map<String, dynamic>> getPostDetails(Post post) async {
    try {
      final postRepo = await RepoFactory.getRepository<PostRepository>('postRepo');
      final locationRepo = await RepoFactory.getRepository<LocationRepository>('locationRepo');
      final imageRepo = await RepoFactory.getRepository<PostImagesRepository>('imageRepo');
      
      Map<String, dynamic> details = {'post': post};
      
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
      
      // Get image
      await _addPostImage(details, post, imageRepo, postRepo);
      
      return details;
    } catch (e) {
      print('❌ Error getting post details: $e');
      return {'post': post};
    }
  }

  Future<void> _addPostImage(
    Map<String, dynamic> details,
    Post post,
    PostImagesRepository imageRepo,
    PostRepository postRepo,
  ) async {
    print('🔍 Looking for image for post ${post.id}');
    final imageMap = await imageRepo.getImageByPostId(post.id!);
    
    if (imageMap != null && imageMap['image'] != null) {
      print('✅ Found image in PostImagesRepository');
      details['first_image_bytes'] = _convertToUint8List(imageMap['image']);
    } else {
      print('⚠️  No image found in PostImagesRepository');
      final postImage = await postRepo.getPostImageByPostId(post.id!);
      if (postImage != null) {
        print('✅ Found image path in PostRepository: ${postImage.imageData}');
        details['first_image_path'] = postImage.imageData;
      } else {
        print('❌ No image found anywhere for post ${post.id}');
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