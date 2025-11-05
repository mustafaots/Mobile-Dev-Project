// notification_tourist.dart
import 'package:easy_vacation/classes/DAN/HomeScreen.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/classes/AYM/UserProfileScreen.dart';
import 'package:easy_vacation/classes/MAS/BookingsScreen.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List staticNavigation = [
    const HomeScreen(),
    const MyBookingsScreen(),
    '',
    const NotificationsPage(),
    const ProfilePage()
  ];

  int _navIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
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
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            'New',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // New Notifications Card
                    Card(
                      elevation: 2,
                      color: Colors.white,
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
                                    color: Colors.blueAccent.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.calendar_today,
                                    color: Colors.blueAccent,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Your booking is confirmed!',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'You have successfully booked \'Vintage VW Camper\' for Aug 15-20.',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        '2 hours ago',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: const DecorationImage(
                                      image: NetworkImage(
                                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCyYcTCco5b8pSsSzFeSMqRMtOpXUzWvTSrbeiPB3L_mrinvHgjpmUsJs78ZIVxOwzcGjdql-JKeLMtNdtwN-9syfIhqDb0Z0qQ0btp_S5c_BtO_rAcgl0y4QILhT5KWwGDusCnV1cIsTDV6pBGFcRqkYhJXPvfN0S0QeTWnvyZtZSDUeZY8xJjzmBFu-6hVnODJHtdqILS5WWXALcZ85PvREDxUjMCVNSrjs5wQ-Bg7iS0TUkUiy2Q-sDZkdxAZj9rzcR2d61AKho',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            // Review Request Notification
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Share your experience',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Your stay at \'Lakeside Cabin Retreat\' ended yesterday. How was it?',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppTheme.primaryColor,
                                          foregroundColor: AppTheme.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(24),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                        ),
                                        child: const Text(
                                          'Add Review Now',
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
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: const DecorationImage(
                                      image: NetworkImage(
                                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCwzap4neMqz4zBI4GnvZZ6CRfPG-r82fOYbN3pY9w43gvgVVWQ0vELKQtqfcDVLHMtb5mx4ogH0xsSZmcC9n1GZWRXJkvtRuPznCXqyun9P8DUaPP5cZpjMM3ixQ7B2Qf0Zslc3JzJez7iPSwi5q7C0BLVa2AdHwzsVCZS_ydJSMfzE0ifbNGR-teiaPENon9NTY9fMK_Fg18raQ8yhAkb0FiFeCiJCAwVSJNgqDlWl6skxHY9Gs3iA2rV-bAz6s_0qEY-IPIx5vA',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
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
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            'Earlier',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Earlier Notifications Card
                    Card(
                      elevation: 2,
                      color: Colors.white,
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
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF3F4F6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.directions_car,
                                    size: 20,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Your \'Fiat 500\' rental is starting in 3 days.',
                                        style: TextStyle(
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        '3 days ago',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            // Promotional Notification
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF3F4F6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.campaign,
                                    size: 20,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'New summer deals!',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Check out our new listings with up to 20% off.',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        '5 days ago',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF6B7280),
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