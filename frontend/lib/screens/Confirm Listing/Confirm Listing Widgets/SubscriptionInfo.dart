import 'package:easy_vacation/models/details.model.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:flutter/material.dart';

class SubscriptionInfo extends StatelessWidget {
  final CreatePostData postData;

  const SubscriptionInfo({required this.postData, super.key});

  @override
  Widget build(BuildContext context) {
    final cardColor = context.cardColor;
    final textColor = context.textColor;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  //loc.confirmListing_payPerPost,
                  'Pay Per Post',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Benefits list
            _buildBenefitItem(
              context,
              Icons.check_circle,
              //loc.confirmListing_oneTimePayment,
              'One-time payment for this listing'
            ),
            _buildBenefitItem(
              context,
              Icons.check_circle,
              //loc.confirmListing_noSubscriptionRequired,
              'No subscription required'
            ),
            _buildBenefitItem(
              context,
              Icons.check_circle,
              //loc.confirmListing_payOnlyForThisPost,
              'Pay only for this post'
            ),      
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(BuildContext context, IconData icon, String text) {
    final textColor = context.textColor;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppTheme.successColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: textColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}