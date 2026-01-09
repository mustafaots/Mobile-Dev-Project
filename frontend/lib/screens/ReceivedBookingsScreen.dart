import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/logic/cubit/received_bookings_cubit.dart';
import 'package:easy_vacation/logic/cubit/received_bookings_state.dart';
import 'package:easy_vacation/logic/cubit/image_gallery_cubit.dart';
import 'package:easy_vacation/repositories/db_repositories/images_repository.dart';
import 'package:easy_vacation/services/api/booking_service.dart';
import 'package:easy_vacation/screens/BookingsWidgets/index.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/main.dart';

/// Screen showing bookings received from clients for the user's listings
class ReceivedBookingsScreen extends StatelessWidget {
  const ReceivedBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReceivedBookingsCubit()..loadReceivedBookings(),
      child: const _ReceivedBookingsScreenContent(),
    );
  }
}

class _ReceivedBookingsScreenContent extends StatelessWidget {
  const _ReceivedBookingsScreenContent();

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: App_Bar(context, loc.bookings_received),
      body: BlocBuilder<ReceivedBookingsCubit, ReceivedBookingsState>(
        builder: (context, state) {
          if (state is ReceivedBookingsLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          if (state is ReceivedBookingsError) {
            return Center(child: Text(state.message));
          }

          if (state is ReceivedBookingsLoaded ||
              state is ReceivedBookingsActionInProgress) {
            final bookings = state is ReceivedBookingsLoaded
                ? state.bookings
                : (state as ReceivedBookingsActionInProgress).bookings;
            final selectedFilter = state is ReceivedBookingsLoaded
                ? state.selectedFilter
                : 'all';
            final actionInProgress = state is ReceivedBookingsActionInProgress
                ? state.bookingId
                : null;

            final filteredBookings = _filterBookings(bookings, selectedFilter);

            return SafeArea(
              child: Column(
                children: [
                  // Filter chips
                  ReceivedBookingsFilterChips(selectedFilter: selectedFilter),

                  // Bookings list
                  Expanded(
                    child: filteredBookings.isEmpty
                        ? _buildEmptyState(context)
                        : _buildBookingsList(
                            context,
                            filteredBookings,
                            actionInProgress,
                          ),
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

  List<BookingWithDetails> _filterBookings(
    List<BookingWithDetails> bookings,
    String filter,
  ) {
    if (filter == 'all') return bookings;
    return bookings.where((b) {
      final status = b.booking.status?.toLowerCase() ?? '';
      return status == filter;
    }).toList();
  }

  Widget _buildEmptyState(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              loc.bookings_noReceivedBookings,
              style: AppTheme.header2.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              loc.bookings_receivedEmptyMessage,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList(
    BuildContext context,
    List<BookingWithDetails> bookings,
    int? actionInProgress,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ReceivedBookingsCubit>().reloadBookings();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: bookings.map((bookingWithDetails) {
            final postId = bookingWithDetails.booking.postId;
            final isLoading = actionInProgress == bookingWithDetails.booking.id;

            return BlocProvider(
              create: (context) {
                final imagesRepository =
                    appRepos['imageRepo'] as PostImagesRepository;
                return ImageGalleryCubit(imagesRepository: imagesRepository)
                  ..loadImages(postId);
              },
              child: ReceivedBookingCard(
                bookingWithDetails: bookingWithDetails,
                isLoading: isLoading,
                onAccept: () async {
                  final success = await context
                      .read<ReceivedBookingsCubit>()
                      .acceptBooking(bookingWithDetails.booking.id!);
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.bookings_acceptSuccess,
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                onReject: () async {
                  final success = await context
                      .read<ReceivedBookingsCubit>()
                      .rejectBooking(bookingWithDetails.booking.id!);
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.bookings_rejectSuccess,
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                onRefresh: () {
                  context.read<ReceivedBookingsCubit>().reloadBookings();
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
