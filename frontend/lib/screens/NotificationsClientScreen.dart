import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/themes.dart';

class NotificationsClientScreen extends StatelessWidget {
  const NotificationsClientScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Booking Confirmed
          _NotificationCard(
            icon: Icons.event_available,
            title: "Booking Confirmed",
            message: "Your booking for Seaside Villa is confirmed",
            time: "2 hours ago",
            color: AppTheme.primaryColor,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/booking-details',
                arguments: 12,
              );
            },
          ),

          const SizedBox(height: 16),

          // Reminder
          _NotificationCard(
            icon: Icons.calendar_today,
            title: "Booking Reminder",
            message: "Your booking starts tomorrow",
            time: "1 day ago",
            color: Colors.orange,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String time;
  final Color color;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(message),
                  const SizedBox(height: 8),
                  Text(time,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
