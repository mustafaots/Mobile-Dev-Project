import 'package:flutter/material.dart';
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/bookings.model.dart';
import 'package:easy_vacation/screens/BookingsScreen.dart';
import 'package:easy_vacation/repositories/db_repositories/booking_repository.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';

class BottomActions extends StatefulWidget {
  final int postId;
  final List<DateTime> selectedDates;
  final BookingRepository bookingRepository;

  const BottomActions({
    super.key,
    required this.postId,
    required this.selectedDates,
    required this.bookingRepository,
  });

  @override
  State<BottomActions> createState() => _BottomActionsState();
}

class _BottomActionsState extends State<BottomActions> {
  bool _isLoading = false;

  Future<void> _createBooking(BuildContext context) async {
    // Validate dates are selected
    if (widget.selectedDates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.listingDetails_selectDatesFirst,
          ),
          backgroundColor: AppTheme.failureColor,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Sort selected dates
      final sortedDates = List<DateTime>.from(widget.selectedDates)..sort();
      final startDate = sortedDates.first;
      final endDate = sortedDates.last;

      // Create booking with hardcoded clientId=1 (in production, get from auth)
      final booking = Booking(
        postId: widget.postId,
        clientId: 1, // TODO: Get from auth/user context
        status: 'pending',
        bookedAt: DateTime.now(),
        startTime: startDate,
        endTime: endDate,
      );

      // Save to database
      await widget.bookingRepository.insertBooking(booking);

      setState(() {
        _isLoading = false;
      });

      // Show success and navigate
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.listingDetails_bookingConfirmed,
            ),
            backgroundColor: AppTheme.successColor,
          ),
        );

        // Navigate to bookings screen
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const BookingsScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.fastOutSlowIn,
                      ),
                    ),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating booking: $e'),
            backgroundColor: AppTheme.failureColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = context.cardColor;

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
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _createBooking(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        AppLocalizations.of(context)!.listingDetails_reserveNow,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
