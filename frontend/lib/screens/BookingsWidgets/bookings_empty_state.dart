import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/screens/Home Screen/HomeScreen.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';

/// Empty state widget for bookings
class BookingsEmptyState extends StatelessWidget {
  final String selectedFilter;
  final int? userId;

  const BookingsEmptyState({super.key, required this.selectedFilter, this.userId});

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final cardColor = context.cardColor;
    final loc = AppLocalizations.of(context)!;

    final message = selectedFilter == 'all'
        ? loc.bookings_emptyMessage
        : 'No ${selectedFilter} bookings yet';

    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(48),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.luggage, size: 64, color: secondaryTextColor),
            const SizedBox(height: 16),
            Text(
              loc.bookings_noBookingsYet,
              style: AppTheme.header2.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: secondaryTextColor),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () => {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => HomeScreen(userId: userId),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  ),
                },
                style: AppTheme.primaryButtonStyle,
                child: Text(
                  loc.bookings_exploreStays,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
