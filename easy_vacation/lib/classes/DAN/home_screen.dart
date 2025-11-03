import 'package:easy_vacation/classes/AYM/ProfilePage.dart';
import 'package:easy_vacation/classes/AYM/notification_tourist.dart';
import 'package:easy_vacation/classes/MAS/my_bookings.dart';
import 'package:easy_vacation/classes/MUS/CreateListingScreen.dart';
import 'package:flutter/material.dart';
import 'vehicules.dart';
import 'stays.dart';
import 'activities.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List staticNavigation = [
    const HomeScreen(),
    const MyBookingsScreen(),
    '',
    const NotificationsPage(),
    const ProfilePage()
  ];

  int selectedIndex = 0;
  List searchContent = ['type', 'wilaya', 'region'];
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  int _navIdx = 0;

  List<Widget> screens = [
    const Stays(),
    const Vehicules(),
    const Activities()
  ];

  // Define colors locally as fallback
  static const Color primaryColor = Colors.blueAccent;
  static const Color white = Colors.white;
  static const Color black = Colors.black87;
  static const Color grey = Color(0xFF6B7280);

  // Local input decoration method
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF6B7280), fontSize: 16),
      hintText: label,
      hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      prefixIcon: Icon(icon, color: const Color(0xFF6B7280)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EasyVacation',
          style: TextStyle(
            color: black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.travel_explore_sharp, color: primaryColor),
          )
        ],
      ),

      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        }, 
        child: Container(
          decoration: BoxDecoration(
            color: white,
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
                    cursorColor: primaryColor,
                    decoration: _inputDecoration('Search...', Icons.search),
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
                                  color: primaryColor.withOpacity(0.1),
                                  border: Border.all(
                                    width: 1.5,
                                    color: primaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  searchContent[i], 
                                  style: TextStyle(
                                    color: primaryColor,
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
                    final tabs = ['Stays', 'Vehicles', 'Activities'];
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
                                color: isSelected ? black : grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 3,
                              width: 50,
                              decoration: BoxDecoration(
                                color: isSelected ? primaryColor : Colors.transparent,
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
                  color: grey.withOpacity(0.3),
                  thickness: 1,
                ),

                const SizedBox(height: 30),

                screens[selectedIndex],
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateListing()),
          );
        },
        shape: const CircleBorder(),
        backgroundColor: primaryColor,
        child: Icon(Icons.add, color: white, size: 30),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: white,
        elevation: 8,
        selectedItemColor: primaryColor,
        unselectedItemColor: grey,
        currentIndex: _navIdx,
        onTap: (index) {
          if (index != 2) { // Skip the empty middle item
            setState(() {
              _navIdx = index;
            });
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => staticNavigation[index]),
            );
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