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
  int selectedIndex = 0;
  List searchContent = ['type', 'wilaya', 'region'];
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  int _navIdx = 0;

  List<Widget> screens = [
    Stays(),
    Vehicules(),
    Activities()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EasyVacation',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 17
          ),
          
        ),
        backgroundColor: Colors.white,
        actions: [
          Padding(padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.travel_explore_sharp),
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
            color: Colors.white
          ),
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    focusNode: _searchFocusNode,
                    controller: _searchController,
                    cursorColor: Colors.lightBlueAccent,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(40, 210, 210, 210),
                      prefixIcon: Icon(Icons.search),
                      hintText: 'search...',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          width: 1,
                          color: const Color.fromARGB(31, 72, 72, 72)
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          width: 2,
                          color: const Color.fromARGB(255, 46, 196, 255)
                        )
                      )
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for(var i=0; i<searchContent.length; i++)
                        GestureDetector(
                          onTap: () {
                            FocusScope.of(context).requestFocus(_searchFocusNode);
                            _searchController.text = '';
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 20),
                            padding: EdgeInsets.symmetric(vertical: 4),
                            width: 58,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(78, 154, 212, 251),
                              border: Border.all(
                                width: 1.5,
                                color: const Color.fromARGB(255, 40, 198, 255)
                              ),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Center(
                              child: Text(searchContent[i], style: TextStyle(color: const Color.fromARGB(255, 84, 177, 252)),),
                            ),
                          ),
                        )
                    ],
                  ),
                ),

                SizedBox(height: 20,),

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
                                color: isSelected ? Colors.black : Colors.blueGrey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 3,
                              width: 50,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.lightBlue : Colors.transparent,
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
                  color: const Color.fromARGB(109, 158, 158, 158),
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),

                SizedBox(height: 30,),

                screens[selectedIndex]
              ],
            ),
          )
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
        shape: CircleBorder(),
        backgroundColor: const Color.fromARGB(255, 46, 196, 255),
        child: Icon(Icons.add, color: const Color.fromARGB(255, 0, 0, 0), size: 30),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 5,
        selectedItemColor: const Color.fromARGB(255, 46, 196, 255),
        unselectedItemColor: Colors.blueGrey,
        currentIndex: _navIdx,
        onTap: (index) => {
          setState(() {
            _navIdx = index;
          })
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