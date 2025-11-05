import 'package:easy_vacation/classes/MUS/SignUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/classes/MAS/PostDetailsScreen.dart';
import 'package:easy_vacation/shared/themes.dart';

class EasyVacationWelcome extends StatelessWidget {
  const EasyVacationWelcome({super.key});

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
                      color: Color(0xFF0d191b),
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
                child: Image.asset('assets/images/homepic.png'),
              ),

              // Welcome Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Welcome to EasyVacation! Your next adventure starts here.',
                  style: AppTheme.header1.copyWith(
                    color: AppTheme.black,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),

              // Explore Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  style: AppTheme.primaryButtonStyle.copyWith(
                    minimumSize: MaterialStateProperty.all(const Size(0, 48)),
                  ),
                  child: Text(
                    'Explore Now',
                    style: AppTheme.loginTextStyle,
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