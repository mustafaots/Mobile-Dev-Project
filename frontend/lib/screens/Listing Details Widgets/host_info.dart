import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/users.model.dart';
import 'package:easy_vacation/models/posts.model.dart' as post_model;
import 'package:easy_vacation/logic/cubit/host_info_cubit.dart';
import 'package:easy_vacation/logic/cubit/host_info_state.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/screens/ProfileScreen.dart';

class HostInfo extends StatelessWidget {
  final User? host;
  final post_model.Post? post;
  final int? postId;
  final HostInfoCubit? cubit;

  const HostInfo({super.key, this.host, this.post, this.postId, this.cubit});

  void _navigateToProfile(
    BuildContext context, {
    required String userName,
    required String userEmail,
    required int postsCount,
    required int reviewsCount,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ProfileScreen(
          userName: userName,
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

    // If cubit is provided, use BlocBuilder to listen to state changes
    if (cubit != null) {
      return BlocBuilder<HostInfoCubit, HostInfoState>(
        bloc: cubit,
        builder: (context, state) {
          if (state is HostInfoLoading) {
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
              child: Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              ),
            );
          }

          if (state is HostInfoError) {
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
              child: Center(
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (state is HostInfoLoaded) {
            return _buildHostInfoCard(
              context,
              state.host,
              state.post,
              state.rating,
              state.reviewCount,
              cardColor,
              textColor,
              secondaryTextColor,
              loc,
            );
          }

          return const SizedBox.shrink();
        },
      );
    }

    // Fallback: Use provided host and post data
    return _buildHostInfoCard(
      context,
      host,
      post,
      4.9,
      127,
      cardColor,
      textColor,
      secondaryTextColor,
      loc,
    );
  }

  Widget _buildHostInfoCard(
    BuildContext context,
    User? hostData,
    post_model.Post? postData,
    double rating,
    int reviewCount,
    Color cardColor,
    Color textColor,
    Color secondaryTextColor,
    AppLocalizations loc,
  ) {
    final hostName = hostData?.username ?? 'Ali';
    final hostEmail = hostData?.email ?? 'ali@example.com';
    final hostPhone = hostData?.phoneNumber ?? 'N/A';
    final price = postData?.price ?? 6000;
    final hostInitials = _getInitials(hostName);

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Host Profile Picture with Initials Avatar
              GestureDetector(
                onTap: () {
                  _navigateToProfile(
                    context,
                    userName: hostName,
                    userEmail: hostEmail,
                    postsCount: 24,
                    reviewsCount: reviewCount,
                  );
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      width: 2,
                    ),
                    color: AppTheme.primaryColor.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Text(
                      hostInitials,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                        fontSize: 18,
                      ),
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
                        Icon(
                          Icons.star,
                          color: AppTheme.neutralColor,
                          size: 16,
                        ),
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
             
            ],
          ),
          const SizedBox(height: 16),
          // Host Details
          if (hostData != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: secondaryTextColor.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                    Icons.email,
                    'Email',
                    hostEmail,
                    secondaryTextColor,
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    Icons.phone,
                    'Phone',
                    hostPhone,
                    secondaryTextColor,
                  ),
                  if (hostData.isVerified) ...[
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      Icons.verified,
                      'Verification',
                      'Verified',
                      Colors.green,
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].substring(0, 1).toUpperCase();
  }
}
