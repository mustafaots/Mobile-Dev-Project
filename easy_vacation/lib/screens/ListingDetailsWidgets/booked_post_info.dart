import 'package:flutter/material.dart';
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/repositories/db_repositories/booking_repository.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';

class BookedPostBottomInfo extends StatefulWidget {
  final Post? post;
  final int postId;
  final BookingRepository bookingRepository;
  final VoidCallback? onBookingCanceled;

  const BookedPostBottomInfo({
    super.key,
    required this.post,
    required this.postId,
    required this.bookingRepository,
    this.onBookingCanceled,
  });

  @override
  State<BookedPostBottomInfo> createState() => _BookedPostBottomInfoState();
}

class _BookedPostBottomInfoState extends State<BookedPostBottomInfo> {
  bool _isLoadingBooking = true;
  bool _isCanceling = false;
  String? _bookingDates;
  String? _bookingStatus;

  @override
  void initState() {
    super.initState();
    _loadBookingInfo();
  }

  Future<void> _loadBookingInfo() async {
    try {
      // Get the latest booking for this post
      final bookings = await widget.bookingRepository.getAllBookings();
      var booking;
      try {
        booking = bookings.lastWhere((b) => b.postId == widget.postId);
      } catch (e) {
        booking = null;
      }

      if (mounted) {
        setState(() {
          if (booking != null) {
            _bookingDates =
                '${booking.startTime.day}/${booking.startTime.month} - ${booking.endTime.day}/${booking.endTime.month}/${booking.endTime.year}';
            _bookingStatus = booking.status;
          }
          _isLoadingBooking = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingBooking = false;
        });
      }
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'confirmed':
        return AppTheme.successColor;
      case 'pending':
        return AppTheme.neutralColor;
      case 'rejected':
        return AppTheme.failureColor;
      default:
        return AppTheme.neutralColor;
    }
  }

  String _getStatusLabel(BuildContext context, String? status) {
    final loc = AppLocalizations.of(context)!;
    switch (status) {
      case 'confirmed':
        return loc.bookings_confirmed;
      case 'pending':
        return loc.bookings_pending;
      case 'rejected':
        return loc.bookings_rejected;
      default:
        return status ?? 'Unknown';
    }
  }

  Future<void> _cancelBooking() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.bookings_cancelBooking),
        content: Text(
          AppLocalizations.of(context)!.bookings_cancelConfirmation,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.common_no),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.common_yes),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isCanceling = true;
    });

    try {
      final bookings = await widget.bookingRepository.getAllBookings();
      var booking;
      try {
        booking = bookings.lastWhere((b) => b.postId == widget.postId);
      } catch (e) {
        booking = null;
      }

      if (booking != null && booking.id != null) {
        // Delete the booking from database
        await widget.bookingRepository.deleteBooking(booking.id!);

        if (mounted) {
          setState(() {
            _bookingStatus = 'rejected';
            _isCanceling = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.bookings_canceledSuccessfully,
              ),
              backgroundColor: AppTheme.successColor,
            ),
          );

          // Notify parent of cancellation to refresh bookings list
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              widget.onBookingCanceled
                  ?.call(); // This will navigate back via parent
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCanceling = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.bookings_cancelationError,
            ),
            backgroundColor: AppTheme.failureColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = context.cardColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;

    if (_isLoadingBooking) {
      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: const SizedBox(
            height: 56,
            child: Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
                strokeWidth: 2,
              ),
            ),
          ),
        ),
      );
    }

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.bookings_yourBooking,
                    style: TextStyle(
                      fontSize: 12,
                      color: secondaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _bookingDates ?? 'Loading...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(_bookingStatus).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getStatusColor(_bookingStatus).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      _getStatusLabel(context, _bookingStatus),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(_bookingStatus),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_bookingStatus != 'rejected')
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: ElevatedButton.icon(
                  onPressed: _isCanceling ? null : _cancelBooking,
                  icon: _isCanceling
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Icon(Icons.close, size: 16),
                  label: Text(AppLocalizations.of(context)!.bookings_cancel),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.failureColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
