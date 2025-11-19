import 'package:easy_vacation/screens/HomeScreen.dart';
import 'package:easy_vacation/screens/SignUpScreen.dart';
import 'package:easy_vacation/shared/secondary_styles.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _useridController = TextEditingController();

  // destructor to avoid memory leaks
  @override
  void dispose(){
    super.dispose();

    _passwordController.dispose();
    _useridController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            
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
                const SizedBox(height: 12),
                Text('EasyVacation', style: header_2),
              ],
            ),

            const SizedBox(height: 30),

            // Welcome Section
            Column(
              children: [
                Text('Welcome Back', style: header_1),
                const SizedBox(height: 8),
                Text('Login to your account', style: small_grey_text),
              ],
            ),

            const SizedBox(height: 30),

            // Form Section
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _useridController,
                    decoration: input_decor('Phone Or Email', const Icon(Icons.account_circle_outlined)),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your phone/email';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

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
                ],
              )
            ),

            const SizedBox(height: 25),

            // Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: login_button_style.copyWith(
                  minimumSize: WidgetStateProperty.all(const Size(0, 55)),
                ),
                onPressed: () => {

                  ///////////////////////////////////////////////////////
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const HomeScreen(),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                    (route) => false, // This removes all previous routes
                  )
                  ///////////////////////////////////////////////////////

                },
                child: Text(
                  'Login', 
                  style: login_text_style
                )
              ),
            ),

            const SizedBox(height: 20),

            // Links Section
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // Add forgot password functionality
                  },
                  child: Text(
                    'Forgot Password?',
                    style: small_grey_text.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    // Add navigation to sign up screen
                  },
                  child: GestureDetector(
                    onTap: () {
                      ///////////////////////////////////////////////////////
                      Navigator.pushAndRemoveUntil(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const SignUpScreen(),
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
                    child: Text(
                      "Don't have an account? Sign Up",
                      style: small_grey_text.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Divider with "Or Continue With"
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: AppTheme.grey,
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "Or Continue With",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: AppTheme.grey,
                    thickness: 1,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),

            // Social Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.grey.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(FontAwesomeIcons.google, color: AppTheme.grey, size: 20),
                ),
                const SizedBox(width: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.grey.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(FontAwesomeIcons.facebook, color: AppTheme.grey, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}