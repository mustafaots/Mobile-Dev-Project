import 'dart:convert';

import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/logic/cubit/image_gallery_cubit.dart';
import 'package:easy_vacation/logic/cubit/image_gallery_state.dart';
import 'package:easy_vacation/services/api/booking_service.dart';
import 'package:easy_vacation/screens/BookingsWidgets/bookings_helper.dart';
import 'package:easy_vacation/screens/BookingsWidgets/client_details_bottom_sheet.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Card widget for displaying a received booking with accept/reject buttons
/// Uses the same style as BookingCard from BookingsWidgets
class ReceivedBookingCard extends StatelessWidget {
  final BookingWithDetails bookingWithDetails;
  final bool isLoading;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onRefresh;
  final VoidCallback onViewDetails;

  const ReceivedBookingCard({
    super.key,
    required this.bookingWithDetails,
    required this.isLoading,
    required this.onAccept,
    required this.onReject,
    required this.onRefresh,
    required this.onViewDetails,
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

    // Format date
    final date = BookingsHelper.formatDateRange(
      booking.startTime,
      booking.endTime,
    );
    final price = bookingWithDetails.totalPrice != null
        ? '${bookingWithDetails.totalPrice!.toStringAsFixed(0)} DZD'
        : '';
    final title = bookingWithDetails.listingTitle ?? 'Listing';
    const imagePath = 'assets/images/placeholder.jpg';

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
      child: Column(
        children: [
          // Image section with BlocBuilder for loading images
          BlocBuilder<ImageGalleryCubit, ImageGalleryState>(
            builder: (context, state) {
              if (state is ImageGalleryLoading) {
                return Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    color: Colors.grey[300],
                  ),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              if (state is ImageGalleryLoaded && state.hasImages) {
                ImageProvider imageProvider;

                // First try remote URLs (Cloudinary)
                if (state.imageUrls.isNotEmpty) {
                  imageProvider = NetworkImage(state.imageUrls.first);
                }
                // Then try local base64 images
                else if (state.images.isNotEmpty) {
                  final image = state.images.first;
                  try {
                    if (image.imageData.isEmpty) {
                      imageProvider = const AssetImage(imagePath);
                    } else {
                      final decodedBytes = base64Decode(image.imageData);
                      imageProvider = MemoryImage(decodedBytes);
                    }
                  } catch (e) {
                    imageProvider = const AssetImage(imagePath);
                  }
                } else {
                  imageProvider = const AssetImage(imagePath);
                }

                return Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }

              // Fallback to asset image
              return Container(
                height: 150,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),

          // Content section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status
                Text(
                  BookingsHelper.getStatusLabel(context, status),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: BookingsHelper.getStatusColor(status),
                  ),
                ),
                const SizedBox(height: 8),

                // Title
                Text(
                  title,
                  style: AppTheme.header2.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),

                // Client name (unique to received bookings)
                if (bookingWithDetails.clientName != null) ...[
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
                  const SizedBox(height: 8),
                ],

                // Price and Date row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (price.isNotEmpty)
                            Text(
                              price,
                              style: TextStyle(
                                fontSize: 16,
                                color: secondaryTextColor,
                              ),
                            ),
                          Text(
                            date,
                            style: TextStyle(
                              fontSize: 16,
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // View Client Details button (only for non-pending)
                    if (!isPending)
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            showClientDetailsBottomSheet(
                              context: context,
                              bookingWithDetails: bookingWithDetails,
                            );
                          },
                          style: AppTheme.primaryButtonStyle.copyWith(
                            minimumSize: WidgetStateProperty.all(
                              const Size(0, 36),
                            ),
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                          child: Text(
                            loc.bookings_viewDetails,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                // Accept/Reject buttons (only for pending bookings)
                if (isPending) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          onPressed: onViewDetails,
                          style: AppTheme.primaryButtonStyle.copyWith(
                            minimumSize: WidgetStateProperty.all(
                              const Size(0, 36),
                            ),
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                          child: Text(
                            loc.bookings_viewDetails,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isLoading ? null : onReject,
                          icon: isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
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
                      const SizedBox(width: 8),
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
        ],
      ),
    );
  }
}
