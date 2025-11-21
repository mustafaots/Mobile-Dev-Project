import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:flutter/material.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  const SubscriptionPlanScreen({super.key});

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  List<Map<String, dynamic>> subscriptions = [
    {
      'type': 'Free',
      'icon': Icons.person_outline,
      'cost': '0.00',
      'details': ['Pay-per-cost', 'Limited photo uploads'],
      'is_selected': true,
    },
    {
      'type': 'Monthly',
      'icon': Icons.calendar_month_outlined,
      'cost': '19.99',
      'details': ['Unlimited listings', 'Increased visibility'],
      'is_selected': false,
    },
    {
      'type': 'Yearly',
      'icon': Icons.star_outline,
      'cost': '199.99',
      'details': ['All Monthly benefits', 'Top placement', 'Special badges'],
      'is_selected': false,
    },
  ];

  Widget plan(
    String tp,
    IconData icon,
    String price,
    List details,
    bool selected,
    int idx,
    BuildContext context,
  ) {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final cardColor = context.cardColor; // Add card color

    return GestureDetector(
      onTap: () {
        for (var sub in subscriptions) {
          sub['is_selected'] = false;
        }
        subscriptions[idx]['is_selected'] = true;
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: cardColor, // Use card color instead of background color
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: selected ? 2 : 1,
            color: selected
                ? AppTheme.primaryColor
                : secondaryTextColor.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: textColor.withOpacity(selected ? 0.1 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.primaryColor, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tp,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                if (tp == 'Yearly')
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppTheme.neutralColor,
                    ),
                    child: Text(
                      'Recommended',
                      style: TextStyle(
                        color: Colors.white, // Use white for better contrast
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '\$$price',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var detail in details)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check,
                          color: AppTheme.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            detail,
                            style: TextStyle(fontSize: 15, color: textColor),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: selected
                      ? AppTheme.primaryColor
                      : secondaryTextColor.withOpacity(0.2), // Use theme color
                  foregroundColor: selected ? Colors.white : textColor, // Use theme colors
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  selected ? 'Current Plan' : 'Select Plan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: App_Bar(context, 'Subscriptions'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < subscriptions.length; i++)
                plan(
                  subscriptions[i]['type'],
                  subscriptions[i]['icon'],
                  subscriptions[i]['cost'],
                  subscriptions[i]['details'],
                  subscriptions[i]['is_selected'],
                  i,
                  context,
                ),
            ],
          ),
        ),
      ),
    );
  }
}