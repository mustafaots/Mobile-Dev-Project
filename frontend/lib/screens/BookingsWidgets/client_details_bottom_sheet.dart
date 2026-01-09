import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/services/api/booking_service.dart';
import 'package:easy_vacation/screens/BookingsWidgets/bookings_helper.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';

/// Shows a bottom sheet with client details for a received booking
void showClientDetailsBottomSheet({
  required BuildContext context,
  required BookingWithDetails bookingWithDetails,
}) {
  final loc = AppLocalizations.of(context)!;
  final textColor = context.textColor;
  final secondaryTextColor = context.secondaryTextColor;
  final cardColor = context.cardColor;
  final booking = bookingWithDetails.booking;
  final clientName = bookingWithDetails.clientName ?? 'Unknown Client';
  final date = _formatDateRange(booking.startTime, booking.endTime);
  final price = bookingWithDetails.totalPrice != null
      ? '${bookingWithDetails.totalPrice!.toStringAsFixed(0)} DZD'
      : '';
  final status = booking.status?.toLowerCase() ?? 'pending';

  showModalBottomSheet(
    context: context,
    backgroundColor: cardColor,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: secondaryTextColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Client Info Header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        size: 35,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            clientName,
                            style: AppTheme.header2.copyWith(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: BookingsHelper.getStatusColor(
                                status,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              BookingsHelper.getStatusLabel(context, status),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: BookingsHelper.getStatusColor(status),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Client Contact Info
                Text(
                  loc.bookings_clientContactInfo,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),

                // Email
                if (bookingWithDetails.clientEmail != null &&
                    bookingWithDetails.clientEmail!.isNotEmpty)
                  _DetailRow(
                    icon: Icons.email_outlined,
                    label: loc.bookings_clientEmail,
                    value: bookingWithDetails.clientEmail!,
                    secondaryTextColor: secondaryTextColor,
                    textColor: textColor,
                  ),
                if (bookingWithDetails.clientEmail != null &&
                    bookingWithDetails.clientEmail!.isNotEmpty)
                  const SizedBox(height: 8),

                // Phone
                if (bookingWithDetails.clientPhone != null &&
                    bookingWithDetails.clientPhone!.isNotEmpty)
                  _DetailRow(
                    icon: Icons.phone_outlined,
                    label: loc.bookings_clientPhone,
                    value: bookingWithDetails.clientPhone!,
                    secondaryTextColor: secondaryTextColor,
                    textColor: textColor,
                  ),
                if (bookingWithDetails.clientPhone != null &&
                    bookingWithDetails.clientPhone!.isNotEmpty)
                  const SizedBox(height: 8),

                // No contact info available
                if ((bookingWithDetails.clientEmail == null ||
                        bookingWithDetails.clientEmail!.isEmpty) &&
                    (bookingWithDetails.clientPhone == null ||
                        bookingWithDetails.clientPhone!.isEmpty))
                  Text(
                    loc.bookings_noContactInfo,
                    style: TextStyle(
                      fontSize: 14,
                      color: secondaryTextColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                const SizedBox(height: 24),

                // Booking Details
                Text(
                  loc.bookings_bookingDetails,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),

                // Listing
                _DetailRow(
                  icon: Icons.home_outlined,
                  label: loc.bookings_listing,
                  value: bookingWithDetails.listingTitle ?? 'Unknown Listing',
                  secondaryTextColor: secondaryTextColor,
                  textColor: textColor,
                ),
                const SizedBox(height: 8),

                // Date
                _DetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: loc.bookings_dates,
                  value: date,
                  secondaryTextColor: secondaryTextColor,
                  textColor: textColor,
                ),
                const SizedBox(height: 8),

                // Price
                if (price.isNotEmpty)
                  _DetailRow(
                    icon: Icons.payments_outlined,
                    label: loc.bookings_totalPrice,
                    value: price,
                    secondaryTextColor: secondaryTextColor,
                    textColor: textColor,
                  ),
                const SizedBox(height: 16),

                // Close button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: AppTheme.primaryButtonStyle,
                    child: Text(
                      loc.close,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

String _formatDateRange(DateTime? start, DateTime? end) {
  if (start == null || end == null) return '';
  return '${start.day}-${end.day} ${BookingsHelper.getMonthName(start.month)}, ${start.year}';
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color secondaryTextColor;
  final Color textColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.secondaryTextColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: secondaryTextColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: secondaryTextColor),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
