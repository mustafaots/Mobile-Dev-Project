import 'package:easy_vacation/shared/themes.dart';
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
      'details': [
        'Pay-per-cost',
        'Limited photo uploads'
      ],
      'is_selected': true
    },
    {
      'type': 'Monthly',
      'icon': Icons.calendar_month_outlined,
      'cost': '19.99',
      'details': [
        'Unlimited listings',
        'Increased visibility'
      ],
      'is_selected': false
    },
    {
      'type': 'Yearly',
      'icon': Icons.star_outline,
      'cost': '199.99',
      'details': [
        'All Monthly benefits',
        'Top placement',
        'Special badges'
      ],
      'is_selected': false
    }
  ];

  Widget plan(String tp, IconData icon, String price, List details, bool selected, int idx) {
    return GestureDetector(
      onTap: () {
        for(var sub in subscriptions) {
          sub['is_selected'] = false;
        }
        subscriptions[idx]['is_selected'] = true;
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: selected ? 2 : 1,
            color: selected ? AppTheme.primaryColor : AppTheme.grey.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(selected ? 0.1 : 0.05),
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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (tp == 'Yearly') 
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.amber
                    ),
                    child: const Text('Recommended', 
                      style: TextStyle(
                        color: Colors.white, 
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
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
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
                        Icon(Icons.check, color: AppTheme.primaryColor, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            detail,
                            style: const TextStyle(fontSize: 15),
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
                  backgroundColor: selected ? AppTheme.primaryColor : AppTheme.primaryColor.withOpacity(0.1),
                  foregroundColor: selected ? AppTheme.white : AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Select Plan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: AppTheme.black),
        ),
        title: const Text('Choose your plan'),
        centerTitle: true,
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.black,
        elevation: 0,
      ),
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
                )
            ],
          ),
        )
      ),
    );
  }
}