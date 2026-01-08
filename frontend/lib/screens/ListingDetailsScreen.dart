import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/logic/cubit/add_review_cubit.dart';
import 'package:easy_vacation/repositories/db_repositories/images_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/review_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/user_repository.dart';
import 'package:easy_vacation/logic/cubit/listing_details_cubit.dart';
import 'package:easy_vacation/logic/cubit/listing_details_state.dart';
import 'package:easy_vacation/logic/cubit/availability_cubit.dart';
import 'package:easy_vacation/logic/cubit/reviews_cubit.dart';
import 'package:easy_vacation/logic/cubit/host_info_cubit.dart';
import 'package:easy_vacation/logic/cubit/image_gallery_cubit.dart';
import 'package:easy_vacation/logic/cubit/details_cubit.dart';
import 'package:easy_vacation/screens/AddReviewScreen.dart';
import 'package:easy_vacation/services/api/review_service.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/main.dart';
import 'Listing Details Widgets/index.dart';

class PostDetailsScreen extends StatefulWidget {
  final int? postId;
  final dynamic userId;
  const PostDetailsScreen({super.key, this.postId, this.userId});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  List<DateTime> _selectedDates = [];

  bool _canReview = false;
  bool _checkingReviewPermission = true;

  @override
  void initState() {
    super.initState();

    // Check if user can review this post
    _checkReviewPermission();
  }

  Future<void> _checkReviewPermission() async {
    final postId = widget.postId ?? 1;
    final result = await ReviewService.instance.canReviewPost(postId);
    setState(() {
      _canReview = result.isSuccess && result.data == true;
      _checkingReviewPermission = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final postRepository = appRepos['postRepo'] as dynamic;
            final reviewRepository = appRepos['reviewRepo'] as dynamic;
            final userRepository = appRepos['userRepo'] as dynamic;
            final imagesRepository =
                appRepos['imageRepo'] as PostImagesRepository;

            return ListingDetailsCubit(
              postRepository: postRepository,
              reviewRepository: reviewRepository,
              userRepository: userRepository,
              imagesRepository: imagesRepository,
            )..loadPostDetails(widget.postId ?? 1);
          },
        ),
        BlocProvider(
          create: (context) {
            final postRepository = appRepos['postRepo'] as PostRepository;
            return AvailabilityCubit(postRepository: postRepository)
              ..loadAvailability(widget.postId ?? 1);
          },
        ),
        BlocProvider(
          create: (context) {
            final reviewRepository = appRepos['reviewRepo'] as ReviewRepository;
            final userRepository = appRepos['userRepo'] as UserRepository;
            return ReviewsCubit(
              reviewRepository: reviewRepository,
              userRepository: userRepository,
            )..loadReviews(widget.postId ?? 1);
          },
        ),
        BlocProvider(
          create: (context) {
            final postRepository = appRepos['postRepo'] as PostRepository;
            final userRepository = appRepos['userRepo'] as UserRepository;
            final reviewRepository = appRepos['reviewRepo'] as ReviewRepository;
            return HostInfoCubit(
              postRepository: postRepository,
              userRepository: userRepository,
              reviewRepository: reviewRepository,
            )..loadHostInfo(widget.postId ?? 1);
          },
        ),
        BlocProvider(
          create: (context) {
            final imagesRepository =
                appRepos['imageRepo'] as PostImagesRepository;
            return ImageGalleryCubit(imagesRepository: imagesRepository)
              ..loadImages(widget.postId ?? 1);
          },
        ),
        BlocProvider(create: (context) => DetailsCubit()),
      ],
      child: Scaffold(
        appBar: App_Bar(
          context,
          AppLocalizations.of(context)!.listingDetails_title,
        ),
        backgroundColor: backgroundColor,
        body: BlocBuilder<ListingDetailsCubit, ListingDetailsState>(
          builder: (context, state) {
            if (state is ListingDetailsLoading) {
              return Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              );
            }

            if (state is ListingDetailsError) {
              return Center(child: Text(state.message));
            }

            if (state is ListingDetailsLoaded) {
              final post = state.post;
              final host = state.host;
              final stay = state.stay;
              final vehicle = state.vehicle;
              final activity = state.activity;
              final loc = AppLocalizations.of(context)!;

              // Load details data into the cubit
              Future.microtask(() {
                context.read<DetailsCubit>().loadDetails(
                  post: post,
                  category: post?.category,
                  stay: stay,
                  vehicle: vehicle,
                  activity: activity,
                  loc: loc,
                );
              });

              return SafeArea(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ImageGallery(
                            postId: post?.id,
                            cubit: context.read<ImageGalleryCubit>(),
                          ),
                          TitleSection(post: post),
                          HostInfo(
                            postId: post?.id,
                            host: host,
                            post: post,
                            cubit: context.read<HostInfoCubit>(),
                          ),
                          DetailsSection(
                            post: post,
                            category: post?.category,
                            stay: stay,
                            vehicle: vehicle,
                            activity: activity,
                            cubit: context.read<DetailsCubit>(),
                          ),
                          SizedBox(height: 10),
                          if (!_checkingReviewPermission && _canReview)
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          AddReviewScreen(
                                            postId: widget.postId ?? 1,
                                            reviewerId: widget.userId,
                                            addReviewCubit: AddReviewCubit(
                                              reviewRepository:
                                                  appRepos['reviewRepo'],
                                            ),
                                          ),
                                      transitionsBuilder:
                                          (_, animation, __, child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                      transitionDuration: const Duration(
                                        milliseconds: 300,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 56),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                                child: Text(
                                  loc.notifications_addReviewNow,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ReviewsSection(
                            currentUserID: widget.userId,
                            postId: post?.id,
                            cubit: context.read<ReviewsCubit>(),
                          ),
                          AvailabilitySection(
                            postId: post?.id,
                            cubit: context.read<AvailabilityCubit>(),
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
                      postId: post?.id ?? 0,
                      selectedDates: _selectedDates,
                      currentUserId: widget.userId,
                      ownerId: post?.ownerId,
                    ),
                  ],
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          },
        ),
      ),
    );
  }
}
