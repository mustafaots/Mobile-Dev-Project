import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/screens/AddReviewScreen.dart';
import 'package:easy_vacation/screens/Home%20Screen/HomeScreen.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:easy_vacation/logic/cubit/add_review_cubit.dart';
import 'package:easy_vacation/main.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/screens/SettingsScreen.dart';
import 'package:easy_vacation/screens/BookingsScreen.dart';

class NotificationsScreen extends StatefulWidget {
  final reviewerId;
  const NotificationsScreen({super.key, this.reviewerId});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List staticNavigation = [
    const HomeScreen(),
    const BookingsScreen(),
    '',
    const NotificationsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final imageCache = (64 * dpr).toInt();
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final cardColor = context.cardColor; // Add this
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: App_Bar(context, loc.notifications_title),
      body: SafeArea(
        child: Column(
          children: [
            // Notifications Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // New Notifications Section
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            loc.notifications_new,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor, // Changed to theme color
                            ),
                          ),
                        ],
                      ),
                    ),
                    // New Notifications Card
                    Card(
                      elevation: 2,
                      color: cardColor, // Changed to theme color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Booking Confirmed Notification
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor.withOpacity(
                                      0.1,
                                    ), // Lighter background
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.calendar_today,
                                    color: AppTheme
                                        .primaryColor, // Keep primary color for icon
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        loc.notifications_bookingConfirmed,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color:
                                              textColor, // Changed to theme color
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        loc.notifications_bookingConfirmedMessage(
                                          "Vintage VW Camper",
                                          "Aug 15-20",
                                        ),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              secondaryTextColor, // Changed to theme color
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        loc.notifications_hoursAgo(2),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              secondaryTextColor, // Changed to theme color
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCyYcTCco5b8pSsSzFeSMqRMtOpXUzWvTSrbeiPB3L_mrinvHgjpmUsJs78ZIVxOwzcGjdql-JKeLMtNdtwN-9syfIhqDb0Z0qQ0btp_S5c_BtO_rAcgl0y4QILhT5KWwGDusCnV1cIsTDV6pBGFcRqkYhJXPvfN0S0QeTWnvyZtZSDUeZY8xJjzmBFu-6hVnODJHtdqILS5WWXALcZ85PvREDxUjMCVNSrjs5wQ-Bg7iS0TUkUiy2Q-sDZkdxAZj9rzcR2d61AKho',
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.cover,
                                    cacheWidth: imageCache,
                                    cacheHeight: imageCache,
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: secondaryTextColor.withOpacity(0.3),
                            ), // Changed to theme color
                            // Review Request Notification
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.neutralColor.withOpacity(
                                      0.1,
                                    ), // Lighter background
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.star,
                                    color: AppTheme
                                        .neutralColor, // Keep neutral color for icon
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        loc.notifications_shareExperience,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color:
                                              textColor, // Changed to theme color
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        loc.notifications_reviewRequest(
                                          "Lakeside Cabin Retreat",
                                        ),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              secondaryTextColor, // Changed to theme color
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (_, __, ___) =>
                                                  AddReviewScreen(
                                                    postId: 1,
                                                    reviewerId: 1,
                                                    addReviewCubit: AddReviewCubit(
                                                      reviewRepository:
                                                          appRepos['reviewRepo'],
                                                    ),
                                                  ),
                                              transitionsBuilder:
                                                  (_, animation, __, child) {
                                                    return FadeTransition(
                                                      opacity: animation,
                                                      child: child,
                                                    );
                                                  },
                                              transitionDuration:
                                                  const Duration(
                                                    milliseconds: 300,
                                                  ),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppTheme.primaryColor,
                                          foregroundColor: AppTheme.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              24,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                        ),
                                        child: Text(
                                          loc.notifications_addReviewNow,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCwzap4neMqz4zBI4GnvZZ6CRfPG-r82fOYbN3pY9w43gvgVVWQ0vELKQtqfcDVLHMtb5mx4ogH0xsSZmcC9n1GZWRXJkvtRuPznCXqyun9P8DUaPP5cZpjMM3ixQ7B2Qf0Zslc3JzJez7iPSwi5q7C0BLVa2AdHwzsVCZS_ydJSMfzE0ifbNGR-teiaPENon9NTY9fMK_Fg18raQ8yhAkb0FiFeCiJCAwVSJNgqDlWl6skxHY9Gs3iA2rV-bAz6s_0qEY-IPIx5vA',
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.cover,
                                    cacheWidth: imageCache,
                                    cacheHeight: imageCache,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Earlier Notifications Section
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            loc.notifications_earlier,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor, // Changed to theme color
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Earlier Notifications Card
                    Card(
                      elevation: 2,
                      color: cardColor, // Changed to theme color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Rental Reminder Notification
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: secondaryTextColor.withOpacity(
                                      0.1,
                                    ), // Lighter background using theme
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.directions_car,
                                    size: 20,
                                    color:
                                        secondaryTextColor, // Changed to theme color
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        loc.notifications_rentalReminder(
                                          "Fiat 500",
                                          3,
                                        ),
                                        style: TextStyle(
                                          color: textColor,
                                        ), // Changed to theme color
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        loc.notifications_daysAgo(3),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              secondaryTextColor, // Changed to theme color
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: secondaryTextColor.withOpacity(0.3),
                            ), // Changed to theme color
                            // Promotional Notification
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: secondaryTextColor.withOpacity(
                                      0.1,
                                    ), // Lighter background using theme
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.campaign,
                                    size: 20,
                                    color:
                                        secondaryTextColor, // Changed to theme color
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        loc.notifications_newSummerDeals,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color:
                                              textColor, // Changed to theme color
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        loc.notifications_promotionalMessage,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              secondaryTextColor, // Changed to theme color
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        loc.notifications_daysAgo(5),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              secondaryTextColor, // Changed to theme color
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
