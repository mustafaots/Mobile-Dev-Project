import 'dart:math';
import 'package:easy_vacation/screens/SignUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/themes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  _getRandomImage(){
    const base_path = 'assets/images/';
    final random = Random();
    final images = [
      base_path+'beach.jpg',
      base_path+'desert.jpg',
      base_path+'ruins.jpg',
    ];
    return images[random.nextInt(images.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo and App Name
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 8),
                  Text(
                    'EasyVacation',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Hero Image
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 400),
                margin: const EdgeInsets.only(bottom: 24),
                child: Center(
                  child: Container(
                    width: 300, // adjust size
                    height: 300, // same as width to make it a perfect circle
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.primaryColor,
                        width: 12, // ring thickness
                      ),
                      image: DecorationImage(
                        image: AssetImage(_getRandomImage()),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),


              // Welcome Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Welcome, Traveler.',
                  style: AppTheme.header1.copyWith(
                    color: AppTheme.black,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: 200, // <-- adjust this to make it smaller
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  style: AppTheme.primaryButtonStyle.copyWith(
                    minimumSize: MaterialStateProperty.all(const Size.fromHeight(55)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    elevation: MaterialStateProperty.all(6),
                    shadowColor: MaterialStateProperty.all(AppTheme.black.withOpacity(0.3)),
                  ),
                  child: Text(
                    'Explore Now',
                    style: AppTheme.loginTextStyle.copyWith(
                      color: AppTheme.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),



              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}