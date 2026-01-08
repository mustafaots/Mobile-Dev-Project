import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/logic/cubit/received_bookings_cubit.dart';
import 'package:easy_vacation/logic/cubit/received_bookings_state.dart';
import 'package:easy_vacation/services/api/booking_service.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:intl/intl.dart';

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
                  _buildFilterChips(context, selectedFilter),

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

  Widget _buildFilterChips(BuildContext context, String selectedFilter) {
    final loc = AppLocalizations.of(context)!;
    final filters = [
      {'key': 'all', 'label': loc.bookings_all},
      {'key': 'pending', 'label': loc.bookings_pending},
      {'key': 'confirmed', 'label': loc.bookings_confirmed},
      {'key': 'cancelled', 'label': loc.bookings_rejected},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: filters.map((filter) {
            final isSelected = selectedFilter == filter['key'];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter['label']!),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    context
                        .read<ReceivedBookingsCubit>()
                        .setFilter(filter['key']!);
                  }
                },
                selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                checkmarkColor: AppTheme.primaryColor,
                labelStyle: TextStyle(
                  color: isSelected ? AppTheme.primaryColor : null,
                  fontWeight: isSelected ? FontWeight.bold : null,
                ),
              ),
            );
          }).toList(),
        ),
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
              Icons.inbox_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              loc.bookings_noReceivedBookings,
              style: AppTheme.header2.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              loc.bookings_receivedEmptyMessage,
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
    List<BookingWithDetails> bookings,
    int? actionInProgress,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ReceivedBookingsCubit>().reloadBookings();
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final bookingWithDetails = bookings[index];
          final isLoading =
              actionInProgress == bookingWithDetails.booking.id;

          return ReceivedBookingCard(
            bookingWithDetails: bookingWithDetails,
            isLoading: isLoading,
            onAccept: () async {
              final success = await context
                  .read<ReceivedBookingsCubit>()
                  .acceptBooking(bookingWithDetails.booking.id!);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.bookings_acceptSuccess),
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
                    content: Text(AppLocalizations.of(context)!.bookings_rejectSuccess),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

/// Card widget for displaying a received booking with accept/reject buttons
class ReceivedBookingCard extends StatelessWidget {
  final BookingWithDetails bookingWithDetails;
  final bool isLoading;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const ReceivedBookingCard({
    super.key,
    required this.bookingWithDetails,
    required this.isLoading,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final cardColor = context.cardColor;

    final booking = bookingWithDetails.booking;
    final status = booking.status?.toLowerCase() ?? 'pending';
    final isPending = status == 'pending';

    // Format dates
    final dateFormat = DateFormat('MMM dd, yyyy');
    String dateRange = '';
    if (booking.startTime != null && booking.endTime != null) {
      dateRange =
          '${dateFormat.format(booking.startTime!)} - ${dateFormat.format(booking.endTime!)}';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusLabel(context, status),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(status),
                    ),
                  ),
                ),
                if (booking.id != null)
                  Text(
                    '#${booking.id}',
                    style: TextStyle(
                      fontSize: 12,
                      color: secondaryTextColor,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Listing title
            Text(
              bookingWithDetails.listingTitle ?? 'Listing',
              style: AppTheme.header2.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),

            // Client name
            if (bookingWithDetails.clientName != null)
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 18,
                    color: secondaryTextColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    loc.bookings_clientName(bookingWithDetails.clientName!),
                    style: TextStyle(
                      fontSize: 14,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 4),

            // Date range
            if (dateRange.isNotEmpty)
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: secondaryTextColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    dateRange,
                    style: TextStyle(
                      fontSize: 14,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),

            // Price
            if (bookingWithDetails.totalPrice != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.attach_money,
                    size: 18,
                    color: secondaryTextColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '\$${bookingWithDetails.totalPrice!.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ],

            // Accept/Reject buttons (only for pending bookings)
            if (isPending) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isLoading ? null : onReject,
                      icon: isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.close, size: 18),
                      label: Text(loc.bookings_reject),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : onAccept,
                      icon: isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check, size: 18),
                      label: Text(loc.bookings_accept),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(BuildContext context, String status) {
    final loc = AppLocalizations.of(context)!;
    switch (status.toLowerCase()) {
      case 'pending':
        return loc.bookings_pending;
      case 'confirmed':
        return loc.bookings_confirmed;
      case 'cancelled':
      case 'rejected':
        return loc.bookings_rejected;
      default:
        return status;
    }
  }
}
