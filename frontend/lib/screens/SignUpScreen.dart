import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/screens/Home Screen/HomeScreen.dart';
import 'package:easy_vacation/screens/LoginScreen.dart';
import 'package:easy_vacation/shared/ui_widgets/app_progress_indicator.dart';
import 'package:easy_vacation/services/sync/sync_manager.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/shared_styles.dart';
import 'package:easy_vacation/shared/secondary_styles.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/FormField.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password_2_Controller = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  bool _isLoading = false;

  // destructor to avoid memory leaks
  @override
  void dispose() {
    super.dispose();

    _passwordController.dispose();
    _password_2_Controller.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final secondaryTextColor = context.secondaryTextColor;
    final loc = AppLocalizations.of(context)!;

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
                        loc.createAccountTitle,
                        style: header_1.copyWith(fontSize: 28),
                      ),
                      space(8),
                      Text(loc.joinMessage, style: small_grey_text),
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
                  // First Name and Last Name in a Row
                  Row(
                    children: [
                      Expanded(
                        child: buildFormField(
                          context,
                          controller: _firstNameController,
                          label: loc.firstName,
                          icon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return loc.pleaseEnterFirstName;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: buildFormField(
                          context,
                          controller: _lastNameController,
                          label: loc.lastName,
                          icon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return loc.pleaseEnterLastName;
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  space(12),

                  buildFormField(
                    context,
                    controller: _emailController,
                    label: loc.email,
                    icon: Icons.mail,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return loc.pleaseEnterEmail;
                      }
                      return null;
                    },
                  ),

                  space(12),

                  buildFormField(
                    context,
                    controller: _phoneController,
                    label: loc.phoneNumber,
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return loc.pleaseEnterPhoneNumber;
                      }
                      
                      final phone = value.trim();
                      // Format: 07, 05, or 06 followed by 8 digits (total 10 digits)
                      if (!RegExp(r'^(07|05|06)\d{8}$').hasMatch(phone)) {
                        return loc.invalidPhoneFormat;
                      }
                      return null;
                    },
                  ),

                  space(20),

                  buildFormField(
                    context,
                    controller: _passwordController,
                    label: loc.password,
                    icon: Icons.lock,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return loc.pleaseEnterPassword;
                      }
                      return null;
                    },
                  ),

                  space(12),

                  buildFormField(
                    context,
                    controller: _password_2_Controller,
                    label: loc.confirmPassword,
                    icon: Icons.lock,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return loc.passwordsDoNotMatch;
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
                onPressed: _isLoading ? null : () async {
                  if (_formKey.currentState!.validate()){
                    // Check if passwords match
                    if (_passwordController.text != _password_2_Controller.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(loc.passwordsDoNotMatch),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    setState(() => _isLoading = true);

                    try {
                      // Use AuthSyncService to register (syncs to remote and local)
                      final result = await SyncManager.instance.auth.register(
                        email: _emailController.text.trim(),
                        password: _passwordController.text,
                        firstName: _firstNameController.text.trim(),
                        lastName: _lastNameController.text.trim(),
                        phone: _phoneController.text.trim(),
                      );

                      if (!context.mounted) return;
                      setState(() => _isLoading = false);

                      if (result.isSuccess && result.data != null) {
                        // Registration successful - navigate to home
                        final user = result.data!.user;
                        Navigator.pushAndRemoveUntil(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => HomeScreen(userId: user.id ?? ''),
                            transitionsBuilder: (_, animation, __, child) {
                              return FadeTransition(opacity: animation, child: child);
                            },
                            transitionDuration: const Duration(milliseconds: 300),
                          ),
                          (route) => false,
                        );
                      } else {
                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result.message ?? loc.registrationFailed),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      if (!context.mounted) return;
                      setState(() => _isLoading = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: AppProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(loc.signUp, style: login_text_style),
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
                  loc.alreadyHaveAccount,
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
                    loc.orContinueWith,
                    style: TextStyle(fontSize: 12, color: secondaryTextColor),
                  ),
                ),
                Expanded(
                  child: Divider(color: secondaryTextColor, thickness: 1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}