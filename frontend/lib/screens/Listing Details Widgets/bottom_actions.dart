import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/details.model.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/screens/BookingsScreen.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Activity%20Post%20Details/ActivityDetailsScreen.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Stays%20Post%20Details/StayDetailsScreen.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Vehicles%20Post%20Details/VehicleDetailsScreen.dart';
import 'package:easy_vacation/screens/Listings%20History/ListingsHistoryScreen.dart';
import 'package:easy_vacation/services/api/listing_service.dart';
import 'package:easy_vacation/shared/ui_widgets/app_progress_indicator.dart';
import 'package:easy_vacation/services/sync/booking_sync_service.dart';
import 'package:easy_vacation/services/api/api_service_locator.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';

class BottomActions extends StatefulWidget {
  final int postId;
  final List<DateTime> selectedDates;
  final dynamic currentUserId;
  final dynamic ownerId;
  final VoidCallback? onDelete;
  final Post? post;

  const BottomActions({
    super.key,
    required this.postId,
    required this.selectedDates,
    this.currentUserId,
    this.ownerId,
    this.onDelete,
    this.post,
  });

  @override
  State<BottomActions> createState() => _BottomActionsState();
}

class _BottomActionsState extends State<BottomActions> {
  bool _isLoading = false;
  bool _isDeleting = false;

  bool get _isOwner {
    if (widget.currentUserId == null || widget.ownerId == null) {
      return false;
    }
    final currentId = widget.currentUserId.toString().trim();
    final ownerId = widget.ownerId.toString().trim();
    final isOwner = currentId == ownerId;
    return isOwner;
  }

  Future<void> _navigateToEdit(BuildContext context) async {
    final post = widget.post;
    if (post == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to edit: post data not available'),
          backgroundColor: AppTheme.failureColor,
        ),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: AppProgressIndicator()),
    );

    try {
      // Fetch the full listing data from API
      final response = await ApiServiceLocator.listings.getListingById(post.id!);
      
      if (!context.mounted) return;
      Navigator.pop(context); // Close loading dialog

      if (!response.isSuccess || response.data == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load listing data'),
            backgroundColor: AppTheme.failureColor,
          ),
        );
        return;
      }

      final listing = response.data!;
      
      // Convert Listing to CreatePostData
      final existingData = _convertListingToCreatePostData(listing);
      
      final category = post.category.toLowerCase();
      Widget editScreen;

      switch (category) {
        case 'stay':
          editScreen = StayDetailsScreen(userId: widget.currentUserId, existingData: existingData);
          break;
        case 'vehicle':
          editScreen = VehicleDetailsScreen(userId: widget.currentUserId, existingData: existingData);
          break;
        case 'activity':
          editScreen = ActivityDetailsScreen(userId: widget.currentUserId, existingData: existingData);
          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Unknown category: $category'),
              backgroundColor: AppTheme.failureColor,
            ),
          );
          return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => editScreen),
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.failureColor,
          ),
        );
      }
    }
  }

  CreatePostData _convertListingToCreatePostData(Listing listing) {
    // Parse availability from JSON string
    List<AvailabilityInterval> availabilityList = [];
    if (listing.availability != null && listing.availability!.isNotEmpty) {
      final parsed = jsonDecode(listing.availability!) as List<dynamic>;
      availabilityList = parsed.map((item) {
        return AvailabilityInterval.fromMap(Map<String, dynamic>.from(item));
      }).toList();
    }
    
    // Convert Stay details
    StayDetails? stayDetails;
    if (listing.stayDetails != null) {
      stayDetails = StayDetails(
        stayType: listing.stayDetails!.stayType,
        area: listing.stayDetails!.area,
        bedrooms: listing.stayDetails!.bedrooms,
      );
    }

    // Convert Vehicle details
    VehicleDetails? vehicleDetails;
    if (listing.vehicleDetails != null) {
      vehicleDetails = VehicleDetails(
        vehicleType: listing.vehicleDetails!.vehicleType,
        model: listing.vehicleDetails!.model,
        year: listing.vehicleDetails!.year,
        fuelType: listing.vehicleDetails!.fuelType,
        transmission: listing.vehicleDetails!.transmission,
        seats: listing.vehicleDetails!.seats,
        features: listing.vehicleDetails!.features,
      );
    }

    // Convert Activity details
    ActivityDetails? activityDetails;
    if (listing.activityDetails != null) {
      activityDetails = ActivityDetails(
        activityType: listing.activityDetails!.activityType,
        requirements: listing.activityDetails!.requirements,
      );
    }

    return CreatePostData(
      id: listing.id, // Include ID for edit mode
      category: listing.category,
      title: listing.title,
      description: listing.description ?? '',
      price: listing.price,
      priceRate: 'day', // Default, as this isn't stored in listing
      location: listing.location,
      availability: availabilityList,
      stayDetails: stayDetails,
      vehicleDetails: vehicleDetails,
      activityDetails: activityDetails,
      imagePaths: listing.images,
    );
  }

  Future<void> _deleteListing(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          loc.listingHistory_deletePostTitle,
          style: const TextStyle(color: Colors.black87),
        ),
        content: Text(
          'Are you sure you want to delete this listing? This action cannot be undone.',
          style: const TextStyle(color: Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(foregroundColor: AppTheme.primaryColor),
            child: Text(loc.profile_cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text(loc.listingHistory_deletePost),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      final response = await ApiServiceLocator.listings.deleteListing(widget.postId);
      
      setState(() {
        _isDeleting = false;
      });

      if (response.isSuccess && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.listingHistory_postDeleted),
            backgroundColor: AppTheme.successColor,
          ),
        );
        widget.onDelete?.call();
        // Navigate to My Listings page
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const ListingsHistory()),
          (route) => route.isFirst,
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'Failed to delete listing'),
            backgroundColor: AppTheme.failureColor,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isDeleting = false;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.failureColor,
          ),
        );
      }
    }
  }

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

    // Require an authenticated user id
    if (widget.currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please log in to book.'),
          backgroundColor: AppTheme.failureColor,
        ),
      );
      return;
    }

    // Prevent owners from booking their own listing
    if (widget.ownerId != null && widget.ownerId == widget.currentUserId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You cannot book your own listing.'),
          backgroundColor: AppTheme.failureColor,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final syncService = await BookingSyncService.getInstance();
    final myBookings = await syncService.getMyBookings();

    final hasExistingBooking = myBookings.any((bookingDetails) {
      final booking = bookingDetails.booking;
      // Check if booking is for the same listing and has an active status
      return booking.postId == widget.postId &&
          (booking.status == 'pending' || booking.status == 'confirmed');
    });

    if (hasExistingBooking) {
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'You already have an active booking for this listing.',
            ),
            backgroundColor: AppTheme.failureColor,
          ),
        );
      }
      return;
    }


    try {
      // Sort selected dates
      final sortedDates = List<DateTime>.from(widget.selectedDates)..sort();
      final startDate = sortedDates.first;
      final endDate = sortedDates.last;

      // Use BookingSyncService to create booking (pushes to Supabase)
      final syncService = await BookingSyncService.getInstance();
      final result = await syncService.createBooking(
        listingId: widget.postId,
        clientId: widget.currentUserId.toString(),
        startDate: startDate,
        endDate: endDate,
      );

      setState(() {
        _isLoading = false;
      });

      if (!result.isSuccess) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message ?? 'Failed to create booking'),
              backgroundColor: AppTheme.failureColor,
            ),
          );
        }
        return;
      }

      // Show success and navigate
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.listingDetails_bookingPending,
            ),
            backgroundColor: AppTheme.successColor,
          ),
        );

        // Navigate to bookings screen
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                BookingsScreen(userId: widget.currentUserId),
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
    final loc = AppLocalizations.of(context)!;
    
    // Debug: check ownership status
    final isOwnerCheck = _isOwner;

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
        child: isOwnerCheck ? _buildOwnerActions(context, loc) : _buildGuestActions(context, loc),
      ),
    );
  }

  Widget _buildOwnerActions(BuildContext context, AppLocalizations loc) {
    return Row(
      children: [
        // Edit Button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _navigateToEdit(context),
            icon: const Icon(Icons.edit),
            label: Text(loc.listingHistory_editPost),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Delete Button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isDeleting ? null : () => _deleteListing(context),
            icon: _isDeleting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: AppProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.delete),
            label: Text(loc.listingHistory_deletePost),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.failureColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuestActions(BuildContext context, AppLocalizations loc) {
    return Row(
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
                    child: AppProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    loc.listingDetails_reserveNow,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
