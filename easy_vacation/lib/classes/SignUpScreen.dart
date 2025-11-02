import 'package:easy_vacation/shared/colors.dart';
import 'package:easy_vacation/shared/shared_styles.dart';
import 'package:easy_vacation/styles/RegistrationStyles.dart';
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
  void dispose(){
    super.dispose();

    _passwordController.dispose();
    _password_2_Controller.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: blue,
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage('assets/palm.webp'),
                  ),
                ),
              ],
            ),

            space(25),

            // Form Section
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          decoration: input_decor('Full Name', const Icon(Icons.account_circle_outlined)),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  space(12),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _emailController,
                          decoration: input_decor('Email', const Icon(Icons.mail)),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  space(12),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          decoration: input_decor('Phone Number', const Icon(Icons.phone)),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  space(20),

                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: input_decor('Password', const Icon(Icons.lock)),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),

                  space(12),

                  TextFormField(
                    obscureText: true,
                    controller: _password_2_Controller,
                    decoration: input_decor('Confirm Password', const Icon(Icons.lock)),
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
                  minimumSize: MaterialStateProperty.all(const Size(0, 55)),
                ),
                onPressed: () => {},
                child: Text(
                  'Sign Up',
                  style: login_text_style,
                ),
              ),
            ),

            space(20),

            // Login Link
            GestureDetector(
              onTap: () {
                // Add navigation to login screen
              },
              child: Text(
                'Already have an account? Login',
                style: small_grey_text.copyWith(
                  color: blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            space(20),

            // Divider with "Or Continue With"
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: grey,
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "Or Continue With",
                    style: TextStyle(
                      fontSize: 12,
                      color: grey,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: grey,
                    thickness: 1,
                  ),
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
                    border: Border.all(color: grey.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(FontAwesomeIcons.google, color: grey, size: 20),
                ),
                const SizedBox(width: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: grey.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(FontAwesomeIcons.facebook, color: grey, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}