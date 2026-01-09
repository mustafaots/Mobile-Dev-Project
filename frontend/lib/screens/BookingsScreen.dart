import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/screens/SentBookingsScreen.dart';
import 'package:easy_vacation/screens/ReceivedBookingsScreen.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/themes.dart';

class BookingsScreen extends StatelessWidget {
  final dynamic userId;
  const BookingsScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final loc = AppLocalizations.of(context)!;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final cardColor = context.cardColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: App_Bar(context, loc.bookings_title),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // Sent Bookings Card
              _BookingNavigationCard(
                icon: Icons.send_outlined,
                title: loc.bookings_sent,
                subtitle: loc.bookings_sentSubtitle,
                color: AppTheme.primaryColor,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
                cardColor: cardColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SentBookingsScreen(userId: userId),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Received Bookings Card
              _BookingNavigationCard(
                icon: Icons.inbox_outlined,
                title: loc.bookings_received,
                subtitle: loc.bookings_receivedSubtitle,
                color: Colors.green,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
                cardColor: cardColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReceivedBookingsScreen(),
                    ),
                  );
                },
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingNavigationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color textColor;
  final Color secondaryTextColor;
  final Color cardColor;
  final VoidCallback onTap;

  const _BookingNavigationCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.textColor,
    required this.secondaryTextColor,
    required this.cardColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: color,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.header2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: secondaryTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
