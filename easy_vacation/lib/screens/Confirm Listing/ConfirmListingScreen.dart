import 'package:easy_vacation/bloc/confirm_listing_cubit.dart';
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/details.model.dart';
import 'package:easy_vacation/screens/Confirm%20Listing/Confirm%20Listing%20Widgets/AgreementCheckbox.dart';
import 'package:easy_vacation/screens/Confirm%20Listing/Confirm%20Listing%20Widgets/SubscriptionInfo.dart';
import 'package:easy_vacation/screens/Home%20Screen/HomeScreen.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmListingScreen extends StatelessWidget {
  final CreatePostData postData;
  final int userId;

  const ConfirmListingScreen({
    required this.userId,
    required this.postData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConfirmListingCubit(),
      child: _ConfirmListingContent(
        userId: userId,
        postData: postData,
      ),
    );
  }
}

class _ConfirmListingContent extends StatelessWidget {
  final CreatePostData postData;
  final int userId;

  const _ConfirmListingContent({
    required this.userId,
    required this.postData,
  });

  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.confirmListing_listingPosted,
        ),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(userId: userId),
          ),
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

    return BlocListener<ConfirmListingCubit, ConfirmListingState>(
      listener: (context, state) {
        if (state is ConfirmListingSuccess) {
          _showSuccessMessage(context);
          _navigateToHome(context);
        } else if (state is ConfirmListingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: AppTheme.failureColor,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: App_Bar(context, loc.confirmListing_title),
        body: BlocBuilder<ConfirmListingCubit, ConfirmListingState>(
          builder: (context, state) {
            return Column(
              children: [
                // Progress indicator
                LinearProgressIndicator(
                  value: state.agreedCheck ? 1.0 : 0.5,
                  backgroundColor:
                      context.secondaryTextColor.withOpacity(0.2),
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
                          postData: postData,
                        ),
                        const SizedBox(height: 24),

                        // Agreement Checkbox
                        AgreementCheckbox(
                          agreed: state.agreedCheck,
                          onChanged: (value) {
                            context
                                .read<ConfirmListingCubit>()
                                .toggleAgreement(value);
                          },
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),

                // Submit Button
                _buildSubmitButton(context, state),
              ],
            );
          },
        ),
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

  Widget _buildSubmitButton(
    BuildContext context,
    ConfirmListingState state,
  ) {
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
        onPressed: (state.agreedCheck && !state.isCreating)
            ? () {
                context.read<ConfirmListingCubit>().createPost(
                      userId: userId,
                      postData: postData,
                      context: context,
                    );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: (state.agreedCheck && !state.isCreating)
              ? AppTheme.primaryColor
              : secondaryTextColor.withOpacity(0.3),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: state.isCreating
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
                    'Post & Pay ${postData.price} DA',
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