import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/main.dart';
import 'package:easy_vacation/repositories/db_repositories/db_repo.dart';
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
  late List<Map<String, dynamic>> subscriptions;

  Future<String> getUserSub() async {
    final subRepo = appRepos['subscriptionRepo'] as SubscriptionRepository;
    final p = await subRepo.getLatestSubscriptionBySubscriber(2);
    return p!['plan'];
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
          t.plan_detail_limited_uploads
        ],
        'is_selected': false,
      },
      {
        'key': "monthly",
        'type': t.plan_monthly,
        'icon': Icons.calendar_month_outlined,
        'cost': '4000',
        'details': [
          t.plan_detail_unlimited_listings,
          t.plan_detail_increased_visibility
        ],
        'is_selected': false,
      },
      {
        'key': "yearly",
        'type': t.plan_yearly,
        'icon': Icons.star_outline,
        'cost': '40000',
        'details': [
          t.plan_detail_monthly_benefits,
          t.plan_detail_top_placement,
          t.plan_detail_special_badges
        ],
        'is_selected': false,
      },
    ];
  }

  Future<bool> changePlan(int idx) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    final subRepo = appRepos['subscriptionRepo'] as SubscriptionRepository;
    final p = await getUserSub();
    if (subscriptions[idx]['key'] == p) {
      setState(() {
        loadingIndex = null;
      });
      return false;
    }

    await subRepo.insertSubscription(
      subscriberId: 2,
      plan: subscriptions[idx]['key']
    );
    return true;
  }

  int? loadingIndex;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final backgroundColor = context.scaffoldBackgroundColor;

    void showSuccessMsg() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: const Color.fromARGB(255, 2, 177, 14),
          content: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.subscription_update_success,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500  
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
      final cardColor = context.cardColor;

      return GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: cardColor,
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
                  if (tp == t.plan_yearly)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppTheme.neutralColor,
                      ),
                      child: Text(
                        t.plan_recommended_label,
                        style: const TextStyle(
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
                '$price ${t.dinars}',
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
                          Icon(Icons.check,
                              color: AppTheme.primaryColor, size: 20),
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
                        : secondaryTextColor.withOpacity(0.2),
                    foregroundColor: selected ? Colors.white : textColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if(subscriptions[idx]['is_selected']) return;
                    setState(() {
                      loadingIndex = idx;
                    });
                    final changed = await changePlan(idx);
                    setState(() { loadingIndex = null; });
                    if(changed) showSuccessMsg();
                  },
                  child: loadingIndex == idx ? 
                    SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(color: const Color.fromARGB(255, 255, 255, 255),),
                    )
                  : Text(
                    selected
                        ? t.plan_current_button
                        : t.plan_select_button,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ) 
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: App_Bar(context, t.subscriptions_title),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: FutureBuilder<String>(
            future: getUserSub(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                );
              }

              if (snapshot.hasData) {
                final p = snapshot.data;

                for(var sub in subscriptions) {
                  sub['is_selected'] = false;
                }

                if(p == 'free') {
                  subscriptions[0]['is_selected'] = true;
                } else if(p == 'monthly') {
                  subscriptions[1]['is_selected'] = true;
                } else {
                  subscriptions[2]['is_selected'] = true;
                }

                return Column(
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
                );
              } else {
                return const Text('Error in getting data!');
              }
            },
          ),
        ),
      ),
    );
  }
}