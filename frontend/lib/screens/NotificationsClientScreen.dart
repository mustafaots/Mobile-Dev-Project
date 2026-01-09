import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/services/api/api_service_locator.dart';
import 'package:easy_vacation/services/sharedprefs.services.dart';

class NotificationsClientScreen extends StatefulWidget {
  const NotificationsClientScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsClientScreen> createState() => _NotificationsClientScreenState();
}

class _NotificationsClientScreenState extends State<NotificationsClientScreen> {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = SharedPrefsService.getUserId();
      if (userId == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final response = await ApiServiceLocator.notificationService.getUserNotifications(
        userId,
        page: 1,
        limit: 20,
      );

      if (response.isSuccess && response.data != null) {
        setState(() {
          _notifications = List<Map<String, dynamic>>.from(response.data!);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    final data = notification['data'] ?? {};
    final type = data['type'];

    switch (type) {
      case 'booking_request':
        // Don't navigate for booking requests - they have action buttons
        break;
      case 'booking_confirmed':
      case 'booking_rejected':
        if (data['booking_id'] != null) {
          Navigator.pushNamed(
            context,
            '/booking-details',
            arguments: data['booking_id'],
          );
        }
        break;
      case 'booking_reminder':
        // Handle booking reminder
        break;
      // Add more cases as needed
    }
  }

  String _formatTimestamp(String? timestamp) {
    if (timestamp == null) return '';

    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays} days ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hours ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minutes ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return '';
    }
  }

  Future<void> _acceptBookingRequest(String? bookingId) async {
    if (bookingId == null) return;

    try {
      final response = await ApiServiceLocator.notificationService.acceptBookingRequest(bookingId);

      if (response.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking request accepted!')),
        );
        // Refresh notifications
        _loadNotifications();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to accept booking: ${response.message}')),
        );
      }
    } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error accepting booking request')),
      );
    }
  }

  Future<void> _rejectBookingRequest(String? bookingId) async {
    if (bookingId == null) return;

    try {
      final response = await ApiServiceLocator.notificationService.rejectBookingRequest(bookingId);

      if (response.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking request rejected')),
        );
        // Refresh notifications
        _loadNotifications();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to reject booking: ${response.message}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error rejecting booking request')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No notifications yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadNotifications,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      final data = notification['data'] ?? {};
                      final type = data['type'] ?? 'general';

                      IconData icon;
                      Color color;

                      switch (type) {
                        case 'booking_request':
                          icon = Icons.event_note;
                          color = Colors.blue;
                          break;
                        case 'booking_confirmed':
                          icon = Icons.event_available;
                          color = AppTheme.primaryColor;
                          break;
                        case 'booking_rejected':
                          icon = Icons.event_busy;
                          color = Colors.red;
                          break;
                        case 'booking_reminder':
                          icon = Icons.calendar_today;
                          color = Colors.orange;
                          break;
                        default:
                          icon = Icons.notifications;
                          color = AppTheme.primaryColor;
                      }

                      return _NotificationCard(
                        icon: icon,
                        title: notification['title'] ?? 'Notification',
                        message: notification['body'] ?? '',
                        time: _formatTimestamp(notification['created_at']),
                        color: color,
                        onTap: () {
                          // Handle notification tap based on type
                          _handleNotificationTap(notification);
                        },
                        // Show action buttons for booking requests
                        showActionButtons: type == 'booking_request',
                        onAccept: type == 'booking_request' ? () => _acceptBookingRequest(data['booking_id']) : null,
                        onReject: type == 'booking_request' ? () => _rejectBookingRequest(data['booking_id']) : null,
                      );
                    },
                  ),
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
  final bool showActionButtons;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const _NotificationCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    required this.color,
    required this.onTap,
    this.showActionButtons = false,
    this.onAccept,
    this.onReject,
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
                  // Show action buttons if needed
                  if (showActionButtons) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (onAccept != null)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onAccept,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Accept',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        if (onAccept != null && onReject != null)
                          const SizedBox(width: 8),
                        if (onReject != null)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onReject,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Reject',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
