import 'package:flutter/material.dart';
import 'package:easy_vacation/classes/MAS/post_details/post_details.dart';
class EasyVacationWelcome extends StatelessWidget {
  const EasyVacationWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6f8f8), 
      body: SafeArea(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.travel_explore,
                    color: Color(0xFF13c8ec), 
                    size: 40,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'EasyVacation',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0d191b),
                      fontFamily: 'PlusJakartaSans',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Container(
                
                width: double.infinity,
                constraints: const BoxConstraints(
                  maxWidth: 400,

                  
                ),

                margin: const EdgeInsets.only(bottom: 24),
                child:
                  Image.asset('assets/images/homepic.png'),
              ),

              
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Welcome to EasyVacation! Your next adventure starts here.',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0d191b),
                    height: 1.2,
                    fontFamily: 'PlusJakartaSans',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),

              
              SizedBox(
                width: double.infinity,
              
                child: ElevatedButton(
                  onPressed: () {  //navigate to post_details
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PostDetailsScreen()),
                  );
},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF13c8ec), 
                    foregroundColor: const Color(0xFF0d191b),
                    minimumSize: const Size.fromHeight(48),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), 
                    ),
                  ),
                  child: const Text(
                    'Explore Now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PlusJakartaSans',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Already have an account? Sign In',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4c8d9a),
                    decoration: TextDecoration.underline,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
              ),
              const SizedBox(height: 8),
          
              GestureDetector(
                onTap: () {
                
                },
                child: const Text(
                  'New here? Sign Up',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4c8d9a),
                    decoration: TextDecoration.underline,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}