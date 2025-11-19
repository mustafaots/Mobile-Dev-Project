import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/widgets/themed_widgets.dart';

class NotificationItem extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final String title;
  final String message;
  final String timeAgo;
  final String? imageUrl;
  final VoidCallback? onTap;
  final Widget? action;

  const NotificationItem({
    super.key,
    required this.icon,
    this.iconColor,
    this.iconBackgroundColor,
    required this.title,
    required this.message,
    required this.timeAgo,
    this.imageUrl,
    this.onTap,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final imageCache = (64 * dpr).toInt();

    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ThemedIcon(
            icon,
            color: iconColor ?? AppTheme.grey,
            decoration: ThemedIcon.circleDecoration(
              backgroundColor: iconBackgroundColor ?? AppTheme.lightGrey.withOpacity(0.2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ThemedText(
                  title,
                  style: ThemedText.bodyBold,
                ),
                if (message.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  ThemedText(
                    message,
                    style: ThemedText.body,
                  ),
                ],
                if (action != null) ...[
                  const SizedBox(height: 12),
                  action!,
                ],
                const SizedBox(height: 8),
                ThemedText(
                  timeAgo,
                  style: ThemedText.caption,
                ),
              ],
            ),
          ),
          if (imageUrl != null) ...[
            const SizedBox(width: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl!,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                cacheWidth: imageCache,
                cacheHeight: imageCache,
              ),
            ),
          ],
        ],
      ),
    );
  }
}