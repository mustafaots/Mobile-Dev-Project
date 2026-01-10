import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/models/users.model.dart';
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/user_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/review_repository.dart';
import 'package:easy_vacation/services/api/profile_service.dart';
import 'host_info_state.dart';

class HostInfoCubit extends Cubit<HostInfoState> {
  final PostRepository postRepository;
  final UserRepository userRepository;
  final ReviewRepository reviewRepository;

  HostInfoCubit({
    required this.postRepository,
    required this.userRepository,
    required this.reviewRepository,
  }) : super(const HostInfoInitial());

  /// Load host info for a specific post
  Future<void> loadHostInfo(int postId) async {
    emit(const HostInfoLoading());
    try {
      // Fetch post
      final post = await postRepository.getPostById(postId);
      if (post == null) {
        emit(const HostInfoError('Post not found'));
        return;
      }

      // Fetch host/owner info - first try local DB, then fall back to API
      User? host = await userRepository.getUserById(post.ownerId);
      if (host == null) {
        // Try fetching from API if not found locally
        final apiResponse = await ProfileService.instance.getUserById(post.ownerId);
        if (apiResponse.isSuccess && apiResponse.data != null) {
          host = apiResponse.data;
          // Optionally cache the user locally for future use
          try {
            await userRepository.insertUser(host!);
          } catch (_) {
            // Ignore cache errors
          }
        } else {
          emit(const HostInfoError('Host not found'));
          return;
        }
      }

      // At this point, host is guaranteed to be non-null
      final User hostUser = host!;

      // Fetch reviews to calculate rating and count
      final reviews = await reviewRepository.getReviewsByPostId(postId);
      int reviewCount = reviews.length;
      double rating = 0.0;

      if (reviews.isNotEmpty) {
        final sum = reviews.fold<int>(0, (acc, review) => acc + review.rating);
        rating = sum / reviews.length;
      }

      double roundedRating = (rating * 10).roundToDouble() / 10;

      emit(
        HostInfoLoaded(
          host: hostUser,
          post: post,
          reviewCount: reviewCount,
          rating: roundedRating,
        ),
      );
    } catch (e) {
      emit(HostInfoError('Failed to load host info: ${e.toString()}'));
    }
  }

  /// Get host full name
  String getHostFullName(User host) {
    if (host.firstName != null && host.lastName != null) {
      return '${host.firstName} ${host.lastName}';
    }
    return host.username;
  }

  /// Get host initials for avatar
  String getHostInitials(User host) {
    final fullName = getHostFullName(host);
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].substring(0, 1).toUpperCase();
  }

  /// Check if host is verified
  bool isHostVerified(User host) {
    return host.isVerified;
  }

  /// Get host account type
  String getHostType(User host) {
    return host.userType;
  }
}
