import 'package:flutter/material.dart';

class SubscriptionPlan extends StatefulWidget {
  const SubscriptionPlan({super.key});

  @override
  State<SubscriptionPlan> createState() => _SubscriptionPlanState();
}

class _SubscriptionPlanState extends State<SubscriptionPlan> {

  List<Map<String, dynamic>> subscriptions = [
    {
      'type': 'Free',
      'icon': Icon(Icons.person_outline, color: Colors.blue, size: 25),
      'cost': '0.00',
      'details': [
        'Pay-per-cost',
        'Limited photo uploads'
      ],
      'is_selected': true
    },
    {
      'type': 'Monthly',
      'icon': Icon(Icons.calendar_month_outlined, color: Colors.blue, size: 25),
      'cost': '19.99',
      'details': [
        'Unlimited listings',
        'Increased visibility'
      ],
      'is_selected': false
    },
    {
      'type': 'Yearly',
      'icon': Icon(Icons.star_outline, color: Colors.blue, size: 25),
      'cost': '199.99',
      'details': [
        'All Monthly benefits',
        'Top placement',
        'Special badges'
      ],
      'is_selected': false
    }
  ];


  Widget plan(String tp, Icon icon, String price, List details, bool selected, int idx) {
    return GestureDetector(
      onTap: () {
        for(var sub in subscriptions) {
          sub['is_selected'] = false;
        }
        subscriptions[idx]['is_selected'] = true;
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: (selected) ? 2: 1,
            color: (selected) ? const Color.fromARGB(255, 244, 185, 10): Color.fromARGB(23, 58, 57, 57),
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: icon,
              trailing: (tp == 'Yearly') ? Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 244, 185, 10)
                ),
                child: Text('Recommended', style: TextStyle(color: Colors.white, fontSize: 12),),
              ): null,
              title: Text(
                tp,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '\$$price',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var detail in details)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.check, color: Colors.blue, size: 20),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            detail,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: (selected) ? Colors.blue: Color.fromARGB(57, 93, 177, 246),
                ),
                onPressed: () {},
                child: Text(
                  'Select Plan',
                  style: TextStyle(
                    color: (selected) ? Colors.white:Color.fromARGB(255, 5, 124, 222),
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
        leading: Icon(Icons.arrow_back),
        title: Text('Choose your plan'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            spacing: 30,
            mainAxisAlignment: MainAxisAlignment.center,
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