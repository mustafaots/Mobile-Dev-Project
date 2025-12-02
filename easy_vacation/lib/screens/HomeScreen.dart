import 'package:easy_vacation/screens/SettingsScreen.dart';
import 'package:easy_vacation/screens/NotificationsScreen.dart';
import 'package:easy_vacation/screens/BookingsScreen.dart';
import 'package:easy_vacation/screens/CreateListingScreen.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/l10n/app_localizations.dart';

import 'VehiclesScreen.dart';
import 'StaysScreen.dart';
import 'ActivitiesScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _bottomNavScreens = [
    const _HomeContent(),
    const BookingsScreen(),
    const SizedBox.shrink(),
    const NotificationsScreen(),
    const SettingsScreen(),
  ];

  int _navIdx = 0;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: _navIdx == 0 ? App_Bar(context, loc.home) : null,
      body: _bottomNavScreens[_navIdx],
      floatingActionButton: _navIdx == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const CreateListing(),
                    transitionsBuilder: (_, animation, __, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                );
              },
              shape: const CircleBorder(),
              backgroundColor: AppTheme.primaryColor,
              child: Icon(Icons.add, color: AppTheme.white, size: 30),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: backgroundColor,
        elevation: 8,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.grey,
        currentIndex: _navIdx,
        onTap: (index) {
          if (index != 2) {
            setState(() {
              _navIdx = index;
            });
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: loc.bottomNav_home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online_outlined),
            label: loc.bottomNav_bookings,
          ),
          const BottomNavigationBarItem(
            icon: SizedBox.shrink(),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: loc.bottomNav_notifications,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: loc.bottomNav_settings,
          ),
        ],
      ),
    );
  }
}


class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => __HomeContentState();
}

class __HomeContentState extends State<_HomeContent> {
  int selectedIndex = 0;

  String? selectedWilaya;
  DateTime? selectedDate;
  String? selectedPrice;

  final List<Widget> screens = const [
    StaysScreen(),
    VehiclesScreen(),
    ActivitiesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final loc = AppLocalizations.of(context)!;

    final List<String> searchContent = [
      loc.filterWilaya,
      loc.filterDate,
      loc.filterPrice,
    ];

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: BoxDecoration(color: backgroundColor),
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              Container(
                margin: const EdgeInsets.only(top: 10),
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(searchContent.length, (i) {
                      return Container(
                        margin: EdgeInsetsDirectional.only(
                          start: i == 0 ? 20 : 8,
                          end: i == searchContent.length - 1 ? 20 : 0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            if (i == 0) _selectWilaya();
                            if (i == 1) _selectDate();
                            if (i == 2) _enterPrice();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              border: Border.all(
                                width: 1.5,
                                color: AppTheme.primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              searchContent[i],
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              const SizedBox(height: 20),


              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(3, (index) {
                  final tabs = [
                    loc.tabStays,
                    loc.tabVehicles,
                    loc.tabActivities
                  ];
                  final bool isSelected = index == selectedIndex;

                  return GestureDetector(
                    onTap: () => setState(() => selectedIndex = index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            tabs[index],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color:
                                  isSelected ? textColor : AppTheme.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 3,
                            width: 50,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),

              Divider(
                height: 0,
                color: AppTheme.grey.withOpacity(0.3),
                thickness: 1,
              ),

              const SizedBox(height: 30),

              screens[selectedIndex],
            ],
          ),
        ),
      ),
    );
  }


  void _selectWilaya() async {
    final List<String> wilayas = [
      "Adrar", "Chlef", "Laghouat", "Oum El Bouaghi", "Batna", "Bejaia", "Biskra",
      "Bechar", "Blida", "Bouira", "Tamanrasset", "Tebessa", "Tlemcen",
      "Tiaret", "Tizi Ouzou", "Algiers", "Djelfa", "Jijel", "Setif",
      "Saida", "Skikda", "Sidi Bel Abbes", "Annaba", "Guelma", "Constantine",
      "Medea", "Mostaganem", "MSila", "Mascara", "Ouargla", "Oran",
      "El Bayadh", "Illizi", "Bordj Bou Arreridj", "Boumerdes", "El Tarf",
      "Tindouf", "Tissemsilt", "El Oued", "Khenchela", "Souk Ahras",
      "Tipaza", "Mila", "Ain Defla", "Naama", "Ain Timouchent",
      "Ghardaia", "Relizane"
    ];

    TextEditingController searchCtrl = TextEditingController();
    List<String> filteredWilayas = List.from(wilayas);

    final result = await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.choose_wilaya),
              content: SizedBox(
                height: 450,
                width: 350,
                child: Column(
                  children: [
                    // SEARCH BAR
                    TextField(
                      controller: searchCtrl,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.search_wilaya,
                        filled: true,
                        fillColor: AppTheme.primaryColor.withOpacity(0.08),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: AppTheme.primaryColor,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: AppTheme.primaryColor,
                            width: 2,
                          ),
                        ),
                        prefixIcon: const Icon(Icons.search),
                      ),

                      // UPDATE SEARCH RESULTS
                      onChanged: (value) {
                        setState(() {
                          filteredWilayas = wilayas
                              .where((w) =>
                                  w.toLowerCase().contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    // WILAYA LIST
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredWilayas.length,
                        itemBuilder: (_, index) {
                          return ListTile(
                            title: Text(filteredWilayas[index]),
                            onTap: () =>
                                Navigator.pop(context, filteredWilayas[index]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      print("Selected wilaya: $result");
    }
  }


  
  void _selectDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() => selectedDate = date);
      print("Selected date: $date");
    }
  }

  void _enterPrice() async {
    TextEditingController priceCtrl = TextEditingController();

    final result = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.enter_price, style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: priceCtrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.enter_max_price,
            hintStyle: const TextStyle(
              color: Color.fromARGB(255, 115, 115, 115),
              fontSize: 16,
            ),
            filled: true,
            fillColor: AppTheme.primaryColor.withOpacity(0.08),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: AppTheme.primaryColor,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: AppTheme.primaryColor,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.profile_cancel, style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, priceCtrl.text),
            child: Text(AppLocalizations.of(context)!.enter),
          ),
        ],
      ),
    );

    if (result != null && result.trim().isNotEmpty) {
      setState(() => selectedPrice = result);
      print("Entered price: $result");
    }
  }
}
