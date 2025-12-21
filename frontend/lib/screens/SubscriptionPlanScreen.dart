import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/main.dart';
import 'package:easy_vacation/models/subscriptions.model.dart';
import 'package:easy_vacation/repositories/db_repositories/subscription_repository.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:flutter/material.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  final dynamic userId;
  const SubscriptionPlanScreen({super.key, this.userId});

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class PlanCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String price;
  final List details;
  final bool isSelected;
  final bool isLoading;
  final bool isRecommended;
  final VoidCallback onSelect;

  const PlanCard({
    super.key,
    required this.title,
    required this.icon,
    required this.price,
    required this.details,
    required this.isSelected,
    required this.isLoading,
    required this.onSelect,
    this.isRecommended = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final cardColor = context.cardColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: isSelected ? 2 : 1,
          color: isSelected
              ? AppTheme.primaryColor
              : secondaryTextColor.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: textColor.withOpacity(isSelected ? 0.1 : 0.05),
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
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              if(isRecommended)
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.neutralColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.plan_recommended_label,
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
            price,
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
                    children: [
                      const Icon(Icons.check, color: AppTheme.primaryColor, size: 20),
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
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppTheme.primaryColor.withOpacity(0.6),
                disabledForegroundColor: Colors.white70,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: isSelected ? null: onSelect,
              child: isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      isSelected ? 
                      AppLocalizations.of(context)!.plan_current_button
                      : AppLocalizations.of(context)!.plan_select_button,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }
}


class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  late List<Map<String, dynamic>> subscriptions;
  int? loadingIndex;

  Future<String> getUserSub() async {
    final subRepo = appRepos['subscriptionRepo'] as SubscriptionRepository;
    final p = await subRepo.getLatestSubscriptionBySubscriber(widget.userId ?? 1);
    return p?.plan ?? "free";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final t = AppLocalizations.of(context)!;

    subscriptions = [
      {
        'key': "free",
        'type': t.plan_free,
        'icon': Icons.person_outline,
        'cost': '0',
        'details': [
          t.plan_detail_pay_per_cost,
          t.plan_detail_limited_uploads,
        ],
      },
      {
        'key': "monthly",
        'type': t.plan_monthly,
        'icon': Icons.calendar_month_outlined,
        'cost': '4000',
        'details': [
          t.plan_detail_unlimited_listings,
          t.plan_detail_increased_visibility,
        ],
      },
      {
        'key': "yearly",
        'type': t.plan_yearly,
        'icon': Icons.star_outline,
        'cost': '40000',
        'details': [
          t.plan_detail_monthly_benefits,
          t.plan_detail_top_placement,
          t.plan_detail_special_badges,
        ],
      },
    ];
  }

  Future<bool> changePlan(int idx) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    final subRepo = appRepos['subscriptionRepo'] as SubscriptionRepository;
    final current = await getUserSub();

    if (subscriptions[idx]['key'] == current) return false;

    final newSub = Subscription(
      subscriberId: widget.userId ?? 1,
      plan: subscriptions[idx]['key'],
      createdAt: DateTime.now(),
    );

    await subRepo.insertSubscription(newSub);
    return true;
  }

  void showSuccessMsg() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        backgroundColor: const Color.fromARGB(255, 2, 177, 14),
        content: Row(
          children: const [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "Your subscription has been updated successfully",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      appBar: App_Bar(context, t.subscriptions_title),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<String>(
          future: getUserSub(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              );
            }

            final current = snapshot.data;

            return SingleChildScrollView(
              child: Column(
                children: [
                  for (var i = 0; i < subscriptions.length; i++)
                    PlanCard(
                      title: subscriptions[i]['type'],
                      icon: subscriptions[i]['icon'],
                      price: "${subscriptions[i]['cost']} ${t.dinars}",
                      details: subscriptions[i]['details'],
                      isSelected: subscriptions[i]['key'] == current,
                      isLoading: loadingIndex == i,
                      isRecommended: subscriptions[i]['key'] == "yearly",
                      onSelect: () async {
                        setState(() => loadingIndex = i);

                        final changed = await changePlan(i);

                        setState(() => loadingIndex = null);

                        if (changed) showSuccessMsg();
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}