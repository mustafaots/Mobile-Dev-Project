import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/logic/cubit/bookings_cubit.dart';
import 'package:easy_vacation/logic/cubit/bookings_state.dart';
import 'package:easy_vacation/logic/cubit/image_gallery_cubit.dart';
import 'package:easy_vacation/models/bookings.model.dart';
import 'package:easy_vacation/repositories/db_repositories/booking_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/images_repository.dart';
import 'package:easy_vacation/screens/BookingsWidgets/index.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/main.dart';

class BookingsScreen extends StatelessWidget {
  final int? userId;
  const BookingsScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bookingRepository = appRepos['bookingRepo'] as BookingRepository;
        final postRepository = appRepos['postRepo'] as PostRepository;

        return BookingsCubit(
          bookingRepository: bookingRepository,
          postRepository: postRepository,
        )..loadBookings();
      },
      child: const _BookingsScreenContent(),
    );
  }
}

class _BookingsScreenContent extends StatelessWidget {
  const _BookingsScreenContent();

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: App_Bar(context, loc.bookings_title),
      body: BlocBuilder<BookingsCubit, BookingsState>(
        builder: (context, state) {
          if (state is BookingsLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          if (state is BookingsError) {
            return Center(child: Text(state.message));
          }

          if (state is BookingsLoaded) {
            final filteredBookings = BookingsHelper.getFilteredBookings(
              state.allBookings,
              state.allPosts,
              state.selectedFilter,
            );

            return SafeArea(
              child: Column(
                children: [
                  // Filter chips
                  BookingsFilterChips(selectedFilter: state.selectedFilter),

                  // Bookings list
                  Expanded(
                    child: filteredBookings.isEmpty
                        ? BookingsEmptyState(
                            selectedFilter: state.selectedFilter,
                          )
                        : _buildBookingsList(context, filteredBookings),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBookingsList(
    BuildContext context,
    List<Map<String, dynamic>> filteredBookings,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: filteredBookings.map((bookingData) {
          final postId = (bookingData['booking'] as Booking).postId;

          return BlocProvider(
            create: (context) {
              final imagesRepository =
                  appRepos['imageRepo'] as PostImagesRepository;
              return ImageGalleryCubit(imagesRepository: imagesRepository)
                ..loadImages(postId);
            },
            child: BookingCard(
              imagePath: bookingData['imagePath'],
              booking: bookingData['booking'],
              status: BookingsHelper.getStatusLabel(
                context,
                bookingData['status'],
              ),
              statusColor: BookingsHelper.getStatusColor(bookingData['status']),
              title: bookingData['title'],
              price: bookingData['price'],
              date: bookingData['date'],
              postId: postId,
              onRefresh: () {
                context.read<BookingsCubit>().reloadBookings();
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
