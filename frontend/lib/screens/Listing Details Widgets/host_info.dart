import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/shared/ui_widgets/app_progress_indicator.dart';
import 'package:easy_vacation/models/users.model.dart';
import 'package:easy_vacation/models/posts.model.dart' as post_model;
import 'package:easy_vacation/logic/cubit/host_info_cubit.dart';
import 'package:easy_vacation/logic/cubit/host_info_state.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/screens/ProfileScreen.dart';
import 'package:easy_vacation/utils/error_helper.dart';

class HostInfo extends StatelessWidget {
  final User? host;
  final post_model.Post? post;
  final int? postId;
  final HostInfoCubit? cubit;

  const HostInfo({super.key, this.host, this.post, this.postId, this.cubit});

  void _navigateToProfile(
    BuildContext context, {
    required User? hostData,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ProfileScreen(
          userName: hostData?.username ?? 'User',
          firstName: hostData?.firstName,
          lastName: hostData?.lastName,
          email: hostData?.email,
          userId: hostData?.id,
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
                child: AppProgressIndicator(),
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
                  ErrorHelper.getLocalizedMessageFromString(state.message, context),
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
    final hostName = _getHostFullName(hostData);
    final hostEmail = hostData?.email ?? 'N/A';
    final hostPhone = hostData?.phoneNumber ?? 'N/A';
    final hostInitials = _getInitials(hostData);

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
                    hostData: hostData,
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

  String _getInitials(User? user) {
    if (user == null) return '?';
    
    final firstName = user.firstName ?? '';
    final lastName = user.lastName ?? '';
    
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '${firstName[0]}${lastName[0]}'.toUpperCase();
    } else if (firstName.isNotEmpty) {
      return firstName[0].toUpperCase();
    } else if (user.username.isNotEmpty && !user.username.contains('@')) {
      return user.username[0].toUpperCase();
    } else if (user.email.isNotEmpty) {
      return user.email[0].toUpperCase();
    }
    return '?';
  }

  String _getHostFullName(User? user) {
    if (user == null) return 'Host';
    
    final firstName = user.firstName ?? '';
    final lastName = user.lastName ?? '';
    
    if (firstName.isNotEmpty || lastName.isNotEmpty) {
      return '$firstName $lastName'.trim();
    }
    
    // Fall back to username only if it's not an email
    if (user.username.isNotEmpty && !user.username.contains('@')) {
      return user.username;
    }
    
    return 'Host';
  }
}
