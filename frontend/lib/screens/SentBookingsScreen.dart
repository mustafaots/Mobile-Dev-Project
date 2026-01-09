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
import 'package:easy_vacation/shared/ui_widgets/app_progress_indicator.dart';
import 'package:easy_vacation/utils/error_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/main.dart';

/// Screen showing bookings the user made to reserve listings
class SentBookingsScreen extends StatelessWidget {
  final dynamic userId;
  const SentBookingsScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bookingRepository = appRepos['bookingRepo'] as BookingRepository;
        final postRepository = appRepos['postRepo'] as PostRepository;

        return BookingsCubit(
          bookingRepository: bookingRepository,
          postRepository: postRepository,
          userId: userId,
        )..loadBookings();
      },
      child: _SentBookingsScreenContent(userId: userId),
    );
  }
}

class _SentBookingsScreenContent extends StatelessWidget {
  final dynamic userId;
  const _SentBookingsScreenContent({this.userId});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: App_Bar(context, loc.bookings_sent),
      body: BlocBuilder<BookingsCubit, BookingsState>(
        builder: (context, state) {
          if (state is BookingsLoading) {
            return const Center(
              child: AppProgressIndicator(),
            );
          }

          if (state is BookingsError) {
            return Center(
              child: Text(
                ErrorHelper.getLocalizedMessageFromString(state.message, context),
              ),
            );
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
                        ? _buildEmptyState(context)
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

  Widget _buildEmptyState(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.send_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              loc.bookings_noSentBookings,
              style: AppTheme.header2.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              loc.bookings_sentEmptyMessage,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList(
    BuildContext context,
    List<Map<String, dynamic>> filteredBookings,
  ) {
    return RefreshIndicator(
      color: AppTheme.primaryColor,
      onRefresh: () async {
        context.read<BookingsCubit>().reloadBookings();
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filteredBookings.length,
        itemBuilder: (context, index) {
          final bookingData = filteredBookings[index];
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
        },
      ),
    );
  }
}
