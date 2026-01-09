import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/logic/cubit/booked_post_cubit.dart';
import 'package:easy_vacation/logic/cubit/booked_post_state.dart';
import 'package:easy_vacation/logic/cubit/image_gallery_cubit.dart';
import 'package:easy_vacation/logic/cubit/reviews_cubit.dart';
import 'package:easy_vacation/logic/cubit/host_info_cubit.dart';
import 'package:easy_vacation/logic/cubit/details_cubit.dart';
import 'package:easy_vacation/repositories/db_repositories/booking_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/review_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/user_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/images_repository.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/utils/error_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/main.dart';
import 'Listing Details Widgets/index.dart';

class BookedPostScreen extends StatelessWidget {
  final int postId;
  final VoidCallback? onBookingCanceled;

  const BookedPostScreen({
    super.key,
    required this.postId,
    this.onBookingCanceled,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BookedPostCubit(
            bookingRepository: appRepos['bookingRepo'] as BookingRepository,
            postRepository: appRepos['postRepo'] as PostRepository,
            reviewRepository: appRepos['reviewRepo'] as ReviewRepository,
            userRepository: appRepos['userRepo'] as UserRepository,
            imagesRepository: appRepos['imageRepo'] as PostImagesRepository,
          )..loadPostDetails(postId),
        ),
        BlocProvider(
          create: (context) {
            final imagesRepository =
                appRepos['imageRepo'] as PostImagesRepository;
            return ImageGalleryCubit(imagesRepository: imagesRepository)
              ..loadImages(postId);
          },
        ),
        BlocProvider(
          create: (context) {
            final reviewRepository = appRepos['reviewRepo'] as ReviewRepository;
            final userRepository = appRepos['userRepo'] as UserRepository;
            return ReviewsCubit(
              reviewRepository: reviewRepository,
              userRepository: userRepository,
            )..loadReviews(postId);
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
            )..loadHostInfo(postId);
          },
        ),
        BlocProvider(create: (context) => DetailsCubit()),
      ],
      child: _BookedPostScreenContent(
        postId: postId,
        onBookingCanceled: onBookingCanceled,
      ),
    );
  }
}

class _BookedPostScreenContent extends StatelessWidget {
  final int postId;
  final VoidCallback? onBookingCanceled;

  const _BookedPostScreenContent({
    required this.postId,
    this.onBookingCanceled,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: App_Bar(
        context,
        AppLocalizations.of(context)!.listingDetails_title,
      ),
      backgroundColor: context.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<BookedPostCubit, BookedPostState>(
          builder: (context, state) {
            if (state is BookedPostLoading) {
              return Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              );
            }

            if (state is BookedPostError) {
              return Center(
                child: Text(
                  ErrorHelper.getLocalizedMessageFromString(
                    state.message,
                    context,
                  ),
                ),
              );
            }

            if (state is BookedPostLoaded) {
              final post = state.post;
              final host = state.host;
              final stay = state.stay;
              final vehicle = state.vehicle;
              final activity = state.activity;
              final location = state.location;
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

              return Stack(
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
                        const SizedBox(height: 10),
                        LocationMapSection(location: location),
                        ReviewsSection(
                          postId: post?.id,
                          cubit: context.read<ReviewsCubit>(),
                        ),
                        const SizedBox(height: 112),
                      ],
                    ),
                  ),
                  BookedPostBottomInfo(
                    postId: postId,
                    onBookingCanceled: onBookingCanceled,
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
