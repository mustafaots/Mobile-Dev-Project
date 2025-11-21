import 'package:easy_vacation/screens/HomeScreen.dart';
import 'package:easy_vacation/screens/LoginScreen.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/shared_styles.dart';
import 'package:easy_vacation/shared/secondary_styles.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/FormField.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password_2_Controller = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // destructor to avoid memory leaks
  @override
  void dispose() {
    super.dispose();

    _passwordController.dispose();
    _password_2_Controller.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final secondaryTextColor = context.secondaryTextColor;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            space(40),

            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create\nYour Account',
                        style: header_1.copyWith(fontSize: 28),
                      ),
                      space(8),
                      Text('Join EasyVacation today', style: small_grey_text),
                    ],
                  ),
                ),
                // Logo Section
                Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                          image: AssetImage('assets/images/ev_icon.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            space(25),

            // Form Section
            Form(
              key: _formKey,
              child: Column(
                children: [
                  buildFormField(
                    context,
                    controller: _nameController,
                    label: 'Full Name',
                    icon: Icons.account_circle_outlined,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),

                  space(12),

                  buildFormField(
                    context,
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.mail,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),

                  space(12),

                  buildFormField(
                    context,
                    controller: _phoneController,
                    label: 'Phone Number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),

                  space(20),

                  buildFormField(
                    context,
                    controller: _passwordController,
                    label: 'Password',
                    icon: Icons.lock,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),

                  space(12),

                  buildFormField(
                    context,
                    controller: _password_2_Controller,
                    label: 'Confirm Password',
                    icon: Icons.lock,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            space(25),

            // Sign Up Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: login_button_style.copyWith(
                  minimumSize: WidgetStateProperty.all(const Size(0, 55)),
                ),
                onPressed: () => {
                  if (_formKey.currentState!.validate()){

                    ///////////////////////////////////////////////////////
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const HomeScreen(),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                        transitionDuration: const Duration(milliseconds: 300),
                      ),
                      (route) => false, // This removes all previous routes
                    ),
                    ///////////////////////////////////////////////////////
                  }
                },
                child: Text('Sign Up', style: login_text_style),
              ),
            ),

            space(20),

            // Login Link
            GestureDetector(
              onTap: () {
                // Add navigation to login screen
              },
              child: GestureDetector(
                onTap: () {
                  ///////////////////////////////////////////////////////
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const LoginScreen(),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                    (route) => false, // This removes all previous routes
                  );
                  ///////////////////////////////////////////////////////
                },
                child: Text(
                  "Already have an account? Login",
                  style: small_grey_text.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            space(20),

            // Divider with "Or Continue With"
            Row(
              children: [
                Expanded(
                  child: Divider(color: secondaryTextColor, thickness: 1),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "Or Continue With",
                    style: TextStyle(fontSize: 12, color: secondaryTextColor),
                  ),
                ),
                Expanded(
                  child: Divider(color: secondaryTextColor, thickness: 1),
                ),
              ],
            ),

            space(15),

            // Social Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: secondaryTextColor.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    FontAwesomeIcons.google,
                    color: secondaryTextColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: secondaryTextColor.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    FontAwesomeIcons.facebook,
                    color: secondaryTextColor,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}