import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/details.model.dart';
import 'package:easy_vacation/screens/Confirm%20Listing/Confirm%20Listing%20Widgets/AgreementCheckbox.dart';
import 'package:easy_vacation/screens/Confirm%20Listing/Confirm%20Listing%20Widgets/SubscriptionInfo.dart';
import 'package:easy_vacation/screens/Confirm%20Listing/PostCreationService.dart';
import 'package:easy_vacation/screens/Home%20Screen/HomeScreen.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:flutter/material.dart';

class ConfirmListingScreen extends StatefulWidget {
  final CreatePostData postData;
  final int userId;

  const ConfirmListingScreen({required this.userId, required this.postData, super.key});

  @override
  State<ConfirmListingScreen> createState() => _ConfirmListingScreenState();
}

class _ConfirmListingScreenState extends State<ConfirmListingScreen> {
  bool _agreedCheck = false;
  bool _isCreating = false;
  final PostCreationService _postCreationService = PostCreationService();

  Future<void> _postListing() async {
    if (!_agreedCheck || _isCreating) return;

    setState(() => _isCreating = true);
    
    final success = await _postCreationService.createPost(
      userId: widget.userId,
      postData: widget.postData,
      context: context,
    );
    
    setState(() => _isCreating = false);
    
    if (success && mounted) {
      _showSuccessMessage();
      _navigateToHome();
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.confirmListing_listingPosted),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _navigateToHome() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(userId: widget.userId)),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: App_Bar(context, loc.confirmListing_title),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: _agreedCheck ? 1.0 : 0.5,
            backgroundColor: context.secondaryTextColor.withOpacity(0.2),
            color: AppTheme.primaryColor,
            minHeight: 3,
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Header
                  _buildHeader(context),
                  const SizedBox(height: 32),
                  
                  // Subscription Info for Pay-Per-Post
                  SubscriptionInfo(
                    postData: widget.postData,
                  ),
                  const SizedBox(height: 24),

                  // Agreement Checkbox
                  AgreementCheckbox(
                    agreed: _agreedCheck,
                    onChanged: (value) => setState(() => _agreedCheck = value),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Submit Button
          _buildSubmitButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final loc = AppLocalizations.of(context)!;

    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.rocket_launch,
            color: AppTheme.primaryColor,
            size: 40,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          loc.confirmListing_readyToPost,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          //loc.confirmListing_payPerPostMessage,
          'Review your listing and complete payment to publish',
          style: TextStyle(
            fontSize: 16,
            color: secondaryTextColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    final cardColor = context.cardColor;
    final secondaryTextColor = context.secondaryTextColor;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border(
          top: BorderSide(
            color: secondaryTextColor.withOpacity(0.1),
          ),
        ),
      ),
      child: ElevatedButton(
        onPressed: (_agreedCheck && !_isCreating) ? _postListing : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: (_agreedCheck && !_isCreating) 
              ? AppTheme.primaryColor 
              : secondaryTextColor.withOpacity(0.3),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isCreating
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.rocket_launch, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Post & Pay ${widget.postData.price} DA',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}