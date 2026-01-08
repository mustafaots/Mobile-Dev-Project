import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/screens/AddReviewScreen.dart';
import 'package:easy_vacation/screens/Home%20Screen/HomeScreen.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:easy_vacation/logic/cubit/add_review_cubit.dart';
import 'package:easy_vacation/main.dart';
import 'package:easy_vacation/services/api/api_service_locator.dart';
import 'package:easy_vacation/services/sharedprefs.services.dart';
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

  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  final int _limit = 20;
  bool _hasMorePages = true;

  // Theme colors (initialized in build method)
  late Color textColor;
  late Color secondaryTextColor;
  late Color cardColor;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications({bool loadMore = false}) async {
    if (loadMore && !_hasMorePages) return;

    setState(() {
      if (loadMore) {
        _isLoadingMore = true;
      } else {
        _isLoading = true;
        _currentPage = 1;
        _notifications = [];
      }
    });

    try {
      final userId = SharedPrefsService.getUserId();
      if (userId == null) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
        return;
      }

      final page = loadMore ? _currentPage + 1 : 1;
      final response = await ApiServiceLocator.notificationService.getUserNotifications(
        userId,
        page: page,
        limit: _limit,
      );

      if (response.isSuccess && response.data != null) {
        final newNotifications = List<Map<String, dynamic>>.from(response.data!);

        setState(() {
          if (loadMore) {
            _notifications.addAll(newNotifications);
            _currentPage = page;
          } else {
            _notifications = newNotifications;
          }

          _hasMorePages = newNotifications.length == _limit;
          _isLoading = false;
          _isLoadingMore = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load notifications')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
      debugPrint('Error loading notifications: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading notifications')),
      );
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    try {
      final userId = SharedPrefsService.getUserId();
      if (userId == null) return;

      final response = await ApiServiceLocator.notificationService.markAsRead(notificationId);

      if (response.isSuccess) {
        // Update local state
        setState(() {
          final index = _notifications.indexWhere((n) => n['id'] == notificationId);
          if (index != -1) {
            _notifications[index]['is_read'] = true;
          }
        });
      }
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
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
      debugPrint('Error accepting booking request: $e');
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
      debugPrint('Error rejecting booking request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error rejecting booking request')),
      );
    }
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, int index) {
    final data = notification['data'] ?? {};
    final type = data['type'] ?? 'general';
    final isRead = notification['is_read'] ?? false;

    IconData getIconForType(String type) {
      switch (type) {
        case 'booking_request':
          return Icons.event_note;
        case 'booking_confirmed':
          return Icons.event_available;
        case 'booking_rejected':
          return Icons.event_busy;
        case 'booking_reminder':
          return Icons.calendar_today;
        case 'review_request':
          return Icons.star;
        case 'promotional':
          return Icons.campaign;
        default:
          return Icons.notifications;
      }
    }

    Color getColorForType(String type) {
      switch (type) {
        case 'booking_request':
          return Colors.blue;
        case 'booking_confirmed':
          return AppTheme.primaryColor;
        case 'booking_rejected':
          return Colors.red;
        case 'booking_reminder':
          return Colors.orange;
        case 'review_request':
          return AppTheme.neutralColor;
        case 'promotional':
          return secondaryTextColor;
        default:
          return AppTheme.primaryColor;
      }
    }

    return InkWell(
      onTap: () async {
        if (!isRead) {
          await _markAsRead(notification['id']);
        }
        // Handle navigation based on notification type
        _handleNotificationTap(notification);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead ? cardColor : AppTheme.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: !isRead ? Border.all(color: AppTheme.primaryColor.withOpacity(0.2), width: 1) : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: getColorForType(type).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                getIconForType(type),
                color: getColorForType(type),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification['title'] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification['body'] ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatTimestamp(notification['created_at']),
                    style: TextStyle(
                      fontSize: 12,
                      color: secondaryTextColor.withOpacity(0.7),
                    ),
                  ),
                  // Show accept/reject buttons for booking requests
                  if (type == 'booking_request') ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _acceptBookingRequest(data['booking_id']),
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
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _rejectBookingRequest(data['booking_id']),
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
            if (data['image_url'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  data['image_url'],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  cacheWidth: 64,
                  cacheHeight: 64,
                ),
              ),
          ],
        ),
      ),
    );
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
      case 'booking_reminder':
        if (data['booking_id'] != null) {
          // Navigate to booking details
          // Navigator.pushNamed(context, '/booking-details', arguments: data['booking_id']);
        }
        break;
      case 'review_request':
        if (data['post_id'] != null) {
          // Navigate to add review
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddReviewScreen(
                postId: data['post_id'],
                reviewerId: data['reviewer_id'] ?? 1,
                addReviewCubit: AddReviewCubit(
                  reviewRepository: appRepos['reviewRepo'],
                ),
              ),
            ),
          );
        }
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

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    textColor = context.textColor;
    secondaryTextColor = context.secondaryTextColor;
    cardColor = context.cardColor;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: App_Bar(context, loc.notifications_title),
      body: SafeArea(
        child: Column(
          children: [
            // Notifications Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _notifications.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_none,
                                size: 64,
                                color: secondaryTextColor.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No notifications yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: secondaryTextColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'You\'ll see your notifications here',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: secondaryTextColor.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () => _loadNotifications(),
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _notifications.length + (_hasMorePages ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == _notifications.length) {
                                // Load more indicator
                                if (_isLoadingMore) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                } else {
                                  // Load more button
                                  return Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: ElevatedButton(
                                      onPressed: () => _loadNotifications(loadMore: true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.primaryColor,
                                        foregroundColor: AppTheme.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                      ),
                                      child: const Text('Load More'),
                                    ),
                                  );
                                }
                              }

                              return _buildNotificationCard(_notifications[index], index);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
