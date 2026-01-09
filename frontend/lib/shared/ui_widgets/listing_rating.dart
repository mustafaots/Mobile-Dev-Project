import 'package:easy_vacation/services/api/review_service.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';

/// A widget that displays the average rating for a listing.
/// Fetches the rating asynchronously and shows nothing if there are no reviews.
class ListingRating extends StatefulWidget {
  final int listingId;
  final double fontSize;
  final Color? textColor;

  const ListingRating({
    super.key,
    required this.listingId,
    this.fontSize = 16,
    this.textColor,
  });

  @override
  State<ListingRating> createState() => _ListingRatingState();
}

class _ListingRatingState extends State<ListingRating> {
  double? _averageRating;
  int? _totalReviews;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRating();
  }

  Future<void> _fetchRating() async {
    try {
      final result = await ReviewService.instance.getRatingSummary(widget.listingId);
      if (mounted) {
        setState(() {
          if (result.isSuccess && result.data != null) {
            _averageRating = result.data!.averageRating;
            _totalReviews = result.data!.totalReviews;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Don't show anything while loading or if no reviews
    if (_isLoading) {
      return const SizedBox.shrink();
    }

    if (_totalReviews == null || _totalReviews == 0 || _averageRating == null) {
      return const SizedBox.shrink();
    }

    final effectiveTextColor = widget.textColor ?? Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star,
          color: AppTheme.neutralColor,
          size: widget.fontSize + 2,
        ),
        const SizedBox(width: 4),
        Text(
          _averageRating!.toStringAsFixed(1),
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.bold,
            color: effectiveTextColor,
          ),
        ),
      ],
    );
  }
}
