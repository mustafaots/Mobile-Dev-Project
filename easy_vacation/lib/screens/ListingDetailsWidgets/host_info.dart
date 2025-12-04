import 'package:flutter/material.dart';
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/users.model.dart';
import 'package:easy_vacation/models/posts.model.dart' as post_model;
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/screens/ProfileScreen.dart';

class HostInfo extends StatelessWidget {
  final User? host;
  final post_model.Post? post;

  const HostInfo({super.key, this.host, this.post});

  void _navigateToProfile(
    BuildContext context, {
    required String userName,
    required String userEmail,
    required String userImage,
    required int postsCount,
    required int reviewsCount,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ProfileScreen(
          userName: userName,
          userEmail: userEmail,
          userImage: userImage,
          postsCount: postsCount,
          reviewsCount: reviewsCount,
        ),
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

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final cardColor = context.cardColor;
    final loc = AppLocalizations.of(context)!;

    // Use model data or defaults
    final hostName = host?.username ?? 'Ali';
    final hostEmail = host?.email ?? 'ali@example.com';
    final hostImage = host?.profilePicture ?? 'assets/images/host_Ali.jpg';
    final price = post?.price ?? 6000;
    final rating = 4.9;
    final reviewCount = 127;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Host Profile Picture with Blue Ring and Gesture Detector
          GestureDetector(
            onTap: () {
              _navigateToProfile(
                context,
                userName: hostName,
                userEmail: hostEmail,
                userImage: hostImage,
                postsCount: 24,
                reviewsCount: reviewCount,
              );
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(hostImage),
                  fit: BoxFit.cover,
                ),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${loc.listingDetails_hostedBy} $hostName',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: AppTheme.neutralColor, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '$rating ($reviewCount ${loc.listingDetails_reviews})',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    loc.listingDetails_superHost,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$price DZD',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Text(
                loc.listingDetails_perNight,
                style: TextStyle(fontSize: 12, color: secondaryTextColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
