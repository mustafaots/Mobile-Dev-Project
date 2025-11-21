import 'package:easy_vacation/screens/HomeScreen.dart';
import 'package:easy_vacation/screens/ProfileScreen.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:flutter/material.dart';

class BlockUserScreen extends StatefulWidget {
  final String userName;

  const BlockUserScreen({super.key, required this.userName});

  @override
  State<BlockUserScreen> createState() => _BlockUserScreenState();
}

class _BlockUserScreenState extends State<BlockUserScreen> {
  bool _isBlocking = false;

  void _showBlockConfirmationModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        final backgroundColor = dialogContext.scaffoldBackgroundColor;
        final textColor = dialogContext.textColor;
        final secondaryTextColor = dialogContext.secondaryTextColor;

        return Dialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.failureColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.block,
                    color: AppTheme.failureColor,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  'User Blocked',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),

                // Message
                Text(
                  'You have successfully blocked ${widget.userName}. '
                  'This user will no longer be able to interact with you or view your profile.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: secondaryTextColor,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close modal
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const HomeScreen(),
                          transitionsBuilder: (_, animation, __, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 300),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Return to Home',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _blockUser() {
    setState(() {
      _isBlocking = true;
    });

    // Simulate API call delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isBlocking = false;
      });
      _showBlockConfirmationModal();
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: App_Bar(context, 'Block User'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Warning Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.failureColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.failureColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: AppTheme.failureColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Blocking is a serious action',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.failureColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              Text(
                "What happens when you block ${widget.userName}?",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: textColor, // Use theme color
                ),
              ),
              const SizedBox(height: 20),

              // Consequences List
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildConsequenceItem(
                    Icons.visibility_off,
                    'They won\'t be able to see your profile, posts, or stories',
                    context,
                  ),
                  const SizedBox(height: 12),
                  _buildConsequenceItem(
                    Icons.chat_bubble_outline,
                    'They can\'t send you comments',
                    context,
                  ),
                  const SizedBox(height: 12),
                  _buildConsequenceItem(
                    Icons.person_remove,
                    'They won\'t be able to follow you or see your updates',
                    context,
                  ),
                  const SizedBox(height: 12),
                  _buildConsequenceItem(
                    Icons.notifications_off,
                    'You won\'t receive any notifications from them',
                    context,
                  ),
                  const SizedBox(height: 12),
                  _buildConsequenceItem(
                    Icons.search_off,
                    'They won\'t appear in your search results',
                    context,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Additional Information
              Text(
                'Note:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'If you change your mind, you can unblock this user anytime from your settings. '
                'Blocking is reversible and does not notify the other user.',
                style: TextStyle(
                  fontSize: 14,
                  color: secondaryTextColor,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 50),

              // Block Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.failureColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isBlocking ? null : _blockUser,
                  child: _isBlocking
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Block User',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const ProfileScreen(),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 300),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: textColor, // Use theme color
                    side: BorderSide(color: secondaryTextColor.withOpacity(0.3)), // Use theme color
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 17, 
                      fontWeight: FontWeight.w500,
                      color: textColor, // Use theme color
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsequenceItem(IconData icon, String text, BuildContext context) {
    final textColor = context.textColor;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppTheme.failureColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: AppTheme.failureColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14, 
              color: textColor, // Use theme color
              height: 1.4
            ),
          ),
        ),
      ],
    );
  }
}