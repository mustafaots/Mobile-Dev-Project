import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/repositories/db_repositories/booking_repository.dart';
import 'package:easy_vacation/logic/cubit/listing_details_cubit.dart';
import 'package:easy_vacation/logic/cubit/listing_details_state.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/main.dart';
import 'Listing Details Widgets/index.dart';

class PostDetailsScreen extends StatefulWidget {
  final int? postId;
  final int? userId;
  const PostDetailsScreen({super.key, this.postId, this.userId});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  late BookingRepository _bookingRepository;
  List<DateTime> _selectedDates = [];

  @override
  void initState() {
    super.initState();
    try {
      _bookingRepository = appRepos['bookingRepo'] as BookingRepository;
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;

    return BlocProvider(
      create: (context) {
        final postRepository = appRepos['postRepo'] as dynamic;
        final reviewRepository = appRepos['reviewRepo'] as dynamic;
        final userRepository = appRepos['userRepo'] as dynamic;

        return ListingDetailsCubit(
          postRepository: postRepository,
          reviewRepository: reviewRepository,
          userRepository: userRepository,
        )..loadPostDetails(widget.postId ?? 1);
      },
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
              final reviews = state.reviews;
              final reviewers = state.reviewers;
              final stay = state.stay;
              final vehicle = state.vehicle;
              final activity = state.activity;

              return SafeArea(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ImageGallery(),
                          TitleSection(post: post),
                          HostInfo(host: host, post: post),
                          DetailsSection(
                            post: post,
                            category: post?.category,
                            stay: stay,
                            vehicle: vehicle,
                            activity: activity,
                          ),
                          ReviewsSection(
                            reviews: reviews,
                            reviewers: reviewers,
                          ),
                          AvailabilitySection(
                            availabilityJson: post?.availability != null
                                ? (post!.availability is String
                                      ? post.availability as String
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
                      postId: post?.id ?? 0,
                      selectedDates: _selectedDates,
                      bookingRepository: _bookingRepository,
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
