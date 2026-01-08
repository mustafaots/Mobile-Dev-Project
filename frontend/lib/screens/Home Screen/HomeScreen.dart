import 'package:easy_vacation/screens/Home%20Screen/SearchScreen.dart';
import 'package:easy_vacation/screens/SettingsScreen.dart';
import 'package:easy_vacation/screens/NotificationsScreen.dart';
import 'package:easy_vacation/screens/BookingsScreen.dart';
import 'package:easy_vacation/screens/Create Listing Screen/CategorySelectionScreen.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';

import 'VehiclesScreen.dart';
import 'StaysScreen.dart';
import 'ActivitiesScreen.dart';

class HomeScreen extends StatefulWidget {
  final userId;
  const HomeScreen({super.key, this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Widget> _bottomNavScreens;

  int _navIdx = 0;

  @override
  void initState() {
    super.initState();
    _bottomNavScreens = [
      _HomeContent(userId: widget.userId,),
      BookingsScreen(userId: widget.userId,),
      SizedBox.shrink(),
      NotificationsScreen(reviewerId: widget.userId,),
      SettingsScreen(userId: widget.userId),
    ];
  }

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
                    pageBuilder: (_, __, ___) => CategorySelectionScreen(userId: widget.userId),
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
  final userId;
  const _HomeContent({this.userId});

  @override
  State<_HomeContent> createState() => __HomeContentState();
}

class __HomeContentState extends State<_HomeContent> {
  int selectedIndex = 0;

  String? selectedWilaya;
  List<DateTime>? selectedDates;
  double? selectedPrice;
  String? selectedType;

  bool changedWilaya = false;
  bool changedDate = false;
  bool changedPrice = false;
  bool changedType = false;
  
  late List<Widget> screens;

  DateTime focused_Day = DateTime.now();


  @override
  void initState() {
    super.initState();
    screens = [
      StaysScreen(user_Id: widget.userId,),
      VehiclesScreen(user_Id: widget.userId,),
      ActivitiesScreen(user_Id: widget.userId),
    ];
  }

  String post_type = 'stay';

  Widget _simpleChip(String text, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final loc = AppLocalizations.of(context)!;

    final List<String> searchContent = [
      loc.filterType,
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
                            if(i == 0) _selectType();
                            if(i == 1) _selectWilaya();
                            if(i == 2) _selectDate();
                            if(i == 3) _enterPrice();
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

              const SizedBox(height: 10),

              if (selectedWilaya != null || selectedDates != null || selectedPrice != null || selectedType != null)
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (selectedWilaya != null)
                          _simpleChip(selectedWilaya!, () {
                            setState(() {
                              selectedWilaya = null;
                              changedWilaya = false;
                            });
                          }),
                        if (selectedDates != null)
                          _simpleChip(selectedDates!.toString().split(" ")[0], () {
                            setState(() {
                              selectedDates = null;
                              changedDate = false;
                            });
                          }),
                        if (selectedPrice != null)
                          _simpleChip("${selectedPrice!} DZD", () {
                            setState(() {
                              selectedPrice = null;
                              changedPrice = false;
                            });
                          }),
                        if (selectedType != null)
                          _simpleChip("${selectedType!}", () {
                            setState(() {
                              selectedType = null;
                              changedType = false;
                            });
                          }),
                      ],
                    ),
                  )
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
                    onTap: () => setState(() {
                      selectedIndex = index;
                      selectedType = null;
                      if(selectedIndex == 0) post_type = 'stay';
                      else if(selectedIndex == 1) post_type = 'vehicle';
                      else if(selectedIndex == 2) post_type = 'activity';
                    }),
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

              if(changedDate || changedPrice || changedWilaya || changedType)
                SearchScreen(
                  postCategory: post_type,
                  price: selectedPrice,
                  wilaya: selectedWilaya,
                  date: selectedDates,
                  postType: selectedType,
                  user_id: widget.userId
                )
              else screens[selectedIndex],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final softDarkSurface = const Color(0xFF1F1F1F);

    final result = await showDialog(
      context: context,
      builder: (_) => Theme(
        data: Theme.of(context).copyWith(
          dialogBackgroundColor: isDark ? softDarkSurface : Colors.white,
          colorScheme: isDark
              ? ColorScheme.dark(
                  primary: AppTheme.primaryColor,
                  onPrimary: Colors.white,
                  onSurface: Colors.white70,
                  surface: softDarkSurface,
                )
              : ColorScheme.light(
                  primary: AppTheme.primaryColor,
                  onPrimary: Colors.black87,
                  onSurface: Colors.black87,
                  surface: Colors.white,
                ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                AppLocalizations.of(context)!.choose_wilaya,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SizedBox(
                height: 450,
                width: 350,
                child: Column(
                  children: [
                    // SEARCH BAR
                    TextField(
                      controller: searchCtrl,
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.search_wilaya,
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white54 : const Color.fromARGB(255, 115, 115, 115),
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: isDark
                        ? const Color.fromARGB(255, 101, 101, 101).withOpacity(0.1)
                        : const Color.fromARGB(255, 225, 226, 226).withOpacity(0.08),
                        prefixIcon: const Icon(Icons.search),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppTheme.primaryColor,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppTheme.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          filteredWilayas = wilayas
                              .where((w) => w.toLowerCase().contains(value.toLowerCase()))
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
                            title: Text(
                              filteredWilayas[index],
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
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
        ),
      ),
    );

    if (result != null) {
      setState(() {
        selectedWilaya = result;
        changedWilaya = selectedWilaya != null;
      });
      print("Selected wilaya: $result");
    }
  }



  
  void _selectDate() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final softDarkSurface = const Color(0xFF1F1F1F);

    List<DateTime>? result = await showModalBottomSheet<List<DateTime>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? softDarkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        List<DateTime> tempSelectedDates = List.from(selectedDates ?? []);

        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.selectDate_title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: isDark ? Colors.white70 : Colors.black87),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: TableCalendar(
                      locale: AppLocalizations.of(context)!.localeName,
                      firstDay: DateTime.now(),
                      lastDay: DateTime(2030, 12, 31),
                      focusedDay: focused_Day,
                      selectedDayPredicate: (day) => tempSelectedDates.contains(day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          focused_Day = focusedDay;
                          if (tempSelectedDates.contains(selectedDay)) {
                            tempSelectedDates.remove(selectedDay);
                          } else {
                            tempSelectedDates.add(selectedDay);
                          }
                        });
                      },
                      calendarStyle: CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        weekendTextStyle: TextStyle(color: AppTheme.primaryColor),
                        defaultTextStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        leftChevronIcon: Icon(Icons.chevron_left, color: AppTheme.primaryColor),
                        rightChevronIcon: Icon(Icons.chevron_right, color: AppTheme.primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, tempSelectedDates),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.confirm_button,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedDates = result;
        changedDate = selectedDates!.isNotEmpty;
      });
      print("Selected dates: $selectedDates");
    }
  }



  void _enterPrice() async {
    TextEditingController priceCtrl = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Soft dark surface for dark mode
    final softDarkSurface = const Color(0xFF1F1F1F);

    final result = await showDialog(
      context: context,
      builder: (_) => Theme(
        data: Theme.of(context).copyWith(
          dialogBackgroundColor: isDark ? softDarkSurface : Colors.white,
          colorScheme: isDark
              ? ColorScheme.dark(
                  primary: AppTheme.primaryColor,       // border & highlights
                  onPrimary: Colors.white,              // title text
                  onSurface: Colors.white70,            // input text
                  surface: softDarkSurface,             // dialog background
                )
              : ColorScheme.light(
                  primary: AppTheme.primaryColor,
                  onPrimary: Colors.white,
                  onSurface: Colors.black87,
                  surface: Colors.white,
                ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        child: AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.enter_price,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          content: TextField(
            controller: priceCtrl,
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.enter_max_price,
              hintStyle: TextStyle(
                color: isDark ? Colors.white54 : const Color.fromARGB(255, 115, 115, 115),
                fontSize: 16,
              ),
              filled: true,
              fillColor: isDark
                  ? const Color.fromARGB(255, 101, 101, 101).withOpacity(0.1)
                  : const Color.fromARGB(255, 225, 226, 226).withOpacity(0.08),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppTheme.primaryColor,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppTheme.primaryColor,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppLocalizations.of(context)!.profile_cancel,
                style: const TextStyle(color: AppTheme.primaryColor),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, priceCtrl.text),
              child: Text(AppLocalizations.of(context)!.enter),
            ),
          ],
        ),
      ),
    );

    if (result != null && result.trim().isNotEmpty) {
      setState(() {
        selectedPrice = double.parse(result);
        changedPrice = selectedPrice != null;
      });
      print("Entered price: $result");
    }
  }



  List<String> _getTypesForPostType() {
    switch (post_type) {
      case 'vehicle':
        return ['motorcycle', 'car', 'bicycle', 'boat', 'scooter', 'other'];
      case 'stay':
        return ['apartment', 'villa', 'house', 'room', 'chalet', 'other'];
      case 'activity':
        return ['cultural', 'sport', 'entertainment', 'educational', 'adventure', 'other'];
      default:
        return [];
    }
  }

  void _selectType() async {
    /*if (post_type == 'activity') {
      return;
    }*/

    final types = _getTypesForPostType();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final softDarkSurface = const Color(0xFF1F1F1F);

    final result = await showDialog<String>(
      context: context,
      builder: (_) => Theme(
        data: Theme.of(context).copyWith(
          dialogBackgroundColor: isDark ? softDarkSurface : Colors.white,
          colorScheme: isDark
              ? ColorScheme.dark(
                  primary: AppTheme.primaryColor,
                  onPrimary: Colors.white,
                  onSurface: Colors.white70,
                  surface: softDarkSurface,
                )
              : ColorScheme.light(
                  primary: AppTheme.primaryColor,
                  onPrimary: Colors.black87,
                  onSurface: Colors.black87,
                  surface: Colors.white,
                ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            AppLocalizations.of(context)!.home_screen_choose_type,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: types.length,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(
                    types[index],
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  onTap: () => Navigator.pop(context, types[index]),
                );
              },
            ),
          ),
        ),
      ),
    );

    if (result != null) {
      setState(() {
        selectedType = result;
        changedType = selectedType != null;
      });
      print("Selected type: $result");
    }
  }

}
