import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/l10n/app_localizations.dart';

class EmptyDetailsState extends StatelessWidget {
  final VoidCallback? onRetry;

  const EmptyDetailsState({Key? key, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        border: Border.all(
          color: context.secondaryTextColor.withOpacity(0.1),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 48, color: context.secondaryTextColor),
          const SizedBox(height: 12),
          Text(
            loc.details_noAdditionalDetails,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: context.secondaryTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
