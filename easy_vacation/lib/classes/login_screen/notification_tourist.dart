import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyVacation',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF13C8EC),
          background: Colors.white,
          onBackground: const Color(0xFF0D191B),
          surface: Colors.white,
          onSurface: const Color(0xFF0D191B),
          secondary: const Color(0xFF4C8D9A),
        ),
        fontFamily: 'PlusJakartaSans',
      ),
      home: const NotificationsPage(),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF0D191B)),
                  ),
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D191B),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_horiz, color: Color(0xFF0D191B)),
                  ),
                ],
              ),
            ),
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
                              color: Color(0xFF0D191B),
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
                                    color: const Color(0xFF13C8EC).withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.calendar_today,
                                    color: Color(0xFF13C8EC),
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
                                          color: Color(0xFF0D191B),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'You have successfully booked \'Vintage VW Camper\' for Aug 15-20.',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF4C8D9A),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        '2 hours ago',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF4C8D9A),
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
                                    color: Colors.yellow.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
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
                                          color: Color(0xFF0D191B),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Your stay at \'Lakeside Cabin Retreat\' ended yesterday. How was it?',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF4C8D9A),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF13C8EC),
                                          foregroundColor: Colors.white,
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
                              color: Color(0xFF0D191B),
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
                            // Host Reply Notification
                            const Divider(),
                            // Rental Reminder Notification
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE7F1F3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.directions_car,
                                    size: 20,
                                    color: Color(0xFF4C8D9A),
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
                                          color: Color(0xFF0D191B),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        '3 days ago',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF4C8D9A),
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
                                    color: Color(0xFFE7F1F3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.campaign,
                                    size: 20,
                                    color: Color(0xFF4C8D9A),
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
                                          color: Color(0xFF0D191B),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Check out our new listings with up to 20% off.',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF4C8D9A),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        '5 days ago',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF4C8D9A),
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
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home
              const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.home_outlined,
                    color: Color(0xFF4C8D9A),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4C8D9A),
                    ),
                  ),
                ],
              ),
              // Wishlist
              const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite_border,
                    color: Color(0xFF4C8D9A),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Wishlist',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4C8D9A),
                    ),
                  ),
                ],
              ),
              // Messages
              // Notifications (Active)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      const Icon(
                        Icons.notifications,
                        color: Color(0xFF13C8EC),
                      ),
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Color(0xFF13C8EC),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              '2',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF13C8EC),
                    ),
                  ),
                ],
              ),
              // Profile
              const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person_outline,
                    color: Color(0xFF4C8D9A),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4C8D9A),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}