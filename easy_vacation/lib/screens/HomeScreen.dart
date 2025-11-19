import 'package:easy_vacation/screens/ProfileScreen.dart';
import 'package:easy_vacation/screens/NotificationsScreen.dart';
import 'package:easy_vacation/screens/BookingsScreen.dart';
import 'package:easy_vacation/screens/CreateListingScreen.dart';
import 'package:easy_vacation/shared/secondary_styles.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';

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
    const _HomeContent(), // Extracted home content
    const BookingsScreen(),
    const SizedBox.shrink(), // Empty middle
    const NotificationsScreen(),
    const ProfileScreen()
  ];

  int _navIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _navIdx == 0 
          ? AppBar(
              title: Text(
                'Home',
                style: TextStyle(
                  color: AppTheme.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
              ),
              backgroundColor: AppTheme.white,
              elevation: 0,
            )
          : null,
      body: _bottomNavScreens[_navIdx],
      floatingActionButton: _navIdx == 0 
          ? FloatingActionButton(
              onPressed: () {
                ///////////////////////////////////////////////////////
                Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const CreateListing(),
                    transitionsBuilder: (_, animation, __, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                  (route) => false, // This removes all previous routes
                );
                ///////////////////////////////////////////////////////
              },
              shape: const CircleBorder(),
              backgroundColor: AppTheme.primaryColor,
              child: Icon(Icons.add, color: AppTheme.white, size: 30),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.white,
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book_online_outlined), label: 'Bookings'),
          BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

// Extracted home content to separate widget
class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => __HomeContentState();
}

class __HomeContentState extends State<_HomeContent> {
  final List<String> searchContent = const ['Type', 'Wilaya', 'Price', 'Date'];
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  
  int selectedIndex = 0;
  final List<Widget> screens = const [
    StaysScreen(),
    VehiclesScreen(),
    ActivitiesScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      }, 
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
        ),
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  focusNode: _searchFocusNode,
                  controller: _searchController,
                  cursorColor: AppTheme.primaryColor,
                  decoration: input_decor('Search...', const Icon(Icons.search)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for(var i = 0; i < searchContent.length; i++)
                        Container(
                          margin: EdgeInsets.only(
                            left: i == 0 ? 20 : 8,
                            right: i == searchContent.length - 1 ? 20 : 0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).requestFocus(_searchFocusNode);
                              _searchController.text = '';
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(3, (index) {
                  final tabs = const ['Stays', 'Vehicles', 'Activities'];
                  final bool isSelected = index == selectedIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            tabs[index],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? AppTheme.black : AppTheme.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 3,
                            width: 50,
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.primaryColor : Colors.transparent,
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
}