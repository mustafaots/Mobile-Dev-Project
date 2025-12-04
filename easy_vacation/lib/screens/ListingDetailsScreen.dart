import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/models/reviews.model.dart';
import 'package:easy_vacation/models/users.model.dart';
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/review_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/user_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/booking_repository.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/main.dart';
import 'ListingDetailsWidgets/index.dart';

class PostDetailsScreen extends StatefulWidget {
  final int? postId;

  const PostDetailsScreen({super.key, this.postId});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  late PostRepository _postRepository;
  late ReviewRepository _reviewRepository;
  late UserRepository _userRepository;
  late BookingRepository _bookingRepository;

  Post? _post;
  User? _host;
  List<Review> _reviews = [];
  Map<int, User> _reviewers = {};
  List<DateTime> _selectedDates = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeRepositories();
  }

  void _initializeRepositories() {
    try {
      _postRepository = appRepos['postRepo'] as PostRepository;
      _reviewRepository = appRepos['reviewRepo'] as ReviewRepository;
      _userRepository = appRepos['userRepo'] as UserRepository;
      _bookingRepository = appRepos['bookingRepo'] as BookingRepository;

      _loadPostDetails();
    } catch (e) {
      setState(() {
        _error = 'Failed to load post details: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadPostDetails() async {
    try {
      // Load post
      if (widget.postId != null) {
        _post = await _postRepository.getPostById(widget.postId!);

        if (_post != null) {
          // Load host info
          _host = await _userRepository.getUserById(_post!.ownerId);

          // Load reviews
          _reviews = await _reviewRepository.getReviewsByPostId(_post!.id!);

          // Load reviewer info for each review
          for (var review in _reviews) {
            final reviewer = await _userRepository.getUserById(
              review.reviewerId,
            );
            if (reviewer != null) {
              _reviewers[review.reviewerId] = reviewer;
            }
          }
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load post details: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;

    if (_isLoading) {
      return Scaffold(
        appBar: App_Bar(
          context,
          AppLocalizations.of(context)!.listingDetails_title,
        ),
        backgroundColor: backgroundColor,
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: App_Bar(
          context,
          AppLocalizations.of(context)!.listingDetails_title,
        ),
        backgroundColor: backgroundColor,
        body: Center(child: Text(_error!)),
      );
    }

    return Scaffold(
      appBar: App_Bar(
        context,
        AppLocalizations.of(context)!.listingDetails_title,
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ImageGallery(),
                  TitleSection(post: _post),
                  DetailsSection(post: _post),
                  HostInfo(host: _host, post: _post),
                  ReviewsSection(reviews: _reviews, reviewers: _reviewers),
                  AvailabilitySection(
                    availabilityJson: _post?.availability != null
                        ? (_post!.availability is String
                              ? _post!.availability as String
                              : null)
                        : null,
                    onDatesSelected: (dates) {
                      setState(() {
                        _selectedDates = dates;
                      });
                    },
                  ),
                  const SizedBox(height: 112),
                ],
              ),
            ),
            BottomActions(
              postId: _post?.id ?? 0,
              selectedDates: _selectedDates,
              bookingRepository: _bookingRepository,
            ),
          ],
        ),
      ),
    );
  }
}
