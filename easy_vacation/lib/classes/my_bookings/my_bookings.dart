// import 'package:flutter/material.dart';

// class MyBookingsScreen extends StatelessWidget {
//   const MyBookingsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'My Bookings',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 1,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header
//             const Text(
//               'Your Reservations',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),

//             // Booking Card 1
//             BookingCard(
//               imagePath: 'assets/images/hotel1.jpg',
//               title: 'Sea View Apartment',
//               location: 'Nice, France',
//               dateRange: 'Dec 22 - Dec 28, 2025',
//               price: '€620 total',
//             ),

//             const SizedBox(height: 16),

//             // Booking Card 2
//             BookingCard(
//               imagePath: 'assets/images/hotel2.jpg',
//               title: 'Mountain Escape Chalet',
//               location: 'Innsbruck, Austria',
//               dateRange: 'Jan 3 - Jan 8, 2026',
//               price: '€850 total',
//             ),

//             const SizedBox(height: 32),

//             // Divider
//             const Divider(thickness: 1),

//             const SizedBox(height: 32),

//             // Empty State
//             Center(
//               child: Column(
//                 children: [
//                   Image.asset(
//                     'assets/images/empty_bookings.png',
//                     height: 160,
//                     fit: BoxFit.contain,
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'No Bookings Yet',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'When you book a stay, it will appear here.',
//                     style: TextStyle(color: Colors.grey),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BookingCard extends StatelessWidget {
//   final String imagePath;
//   final String title;
//   final String location;
//   final String dateRange;
//   final String price;

//   const BookingCard({
//     super.key,
//     required this.imagePath,
//     required this.title,
//     required this.location,
//     required this.dateRange,
//     required this.price,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade300,
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//             child: Image.asset(
//               imagePath,
//               height: 180,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title,
//                     style: const TextStyle(
//                         fontSize: 16, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 4),
//                 Text(location, style: const TextStyle(color: Colors.grey)),
//                 const SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(dateRange,
//                         style: const TextStyle(color: Colors.black54)),
//                     Text(
//                       price,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }











import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            // Filter chips
            _buildFilterChips(),
            
            // Bookings list
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildBookingCard(
                      imagePath: 'assets/images/cozy_cabin.jpg',
                      status: 'Confirmed',
                      statusColor: Colors.green,
                      title: 'Cozy Cabin in the Woods',
                      price: '\7000 DZD',
                      date: '12-15 May, 2024',
                    ),
                    _buildBookingCard(
                      imagePath: 'assets/images/beachfront_villa.jpg',
                      status: 'Pending',
                      statusColor: Colors.orange,
                      title: 'Beachfront Villa',
                      price: '\25000 DZD',
                      date: '20-28 June, 2024',
                    ),
                    _buildBookingCard(
                      imagePath: 'assets/images/city_loft.jpg',
                      status: 'Canceled',
                      statusColor: Colors.red,
                      title: 'City Loft',
                      price: '\8000 DZD',
                      date: '5-7 August, 2024',
                    ),
                    
                    // Empty state
                    _buildEmptyState(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ElevatedButton(onPressed:(
            ) {
              Navigator.pop(context);
              
            }, child: Icon(
              Icons.arrow_back,
              color: Colors.black87,

            ),
            ) 
          ,
          Expanded(
            child: Text(
              'My Bookings',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 48), // Spacer for balance
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFilterChip('All', isSelected: true),
          const SizedBox(width: 8),
          _buildFilterChip('Pending', isSelected: false),
          const SizedBox(width: 8),
          _buildFilterChip('Confirmed', isSelected: false),
          const SizedBox(width: 8),
          _buildFilterChip('Canceled', isSelected: false),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF13C8EC) : const Color(0xFF13C8EC).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard({
    required String imagePath,
    required String status,
    required Color statusColor,
    required String title,
    required String price,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            price,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            date,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF13C8EC),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'View Details',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.luggage,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No Bookings Yet',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You have no upcoming or past bookings. Time to plan your next adventure!',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 150,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF13C8EC),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Explore Stays',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}