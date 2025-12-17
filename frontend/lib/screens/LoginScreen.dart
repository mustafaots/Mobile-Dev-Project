import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/main.dart';
import 'package:easy_vacation/models/users.model.dart';
import 'package:easy_vacation/repositories/db_repositories/user_repository.dart';
import 'package:easy_vacation/screens/ForgotPasswordScreen.dart';
import 'package:easy_vacation/screens/Home Screen/HomeScreen.dart';
import 'package:easy_vacation/screens/SignUpScreen.dart';
import 'package:easy_vacation/shared/secondary_styles.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/FormField.dart';
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
  void dispose() {
    super.dispose();

    _passwordController.dispose();
    _useridController.dispose();
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
                Text(loc.appTitle, style: header_2),
              ],
            ),

            const SizedBox(height: 30),

            // Welcome Section
            Column(
              children: [
                Text(loc.welcomeBack, style: header_1),
                const SizedBox(height: 8),
                Text(loc.loginToAccount, style: small_grey_text),
              ],
            ),

            const SizedBox(height: 30),

            // Form Section
            Form(
              key: _formKey,
              child: Column(
                children: [
                  buildFormField(
                    context,
                    controller: _useridController,
                    label: loc.phoneOrEmail,
                    icon: Icons.account_circle_outlined,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return loc.pleaseEnterPhoneOrEmail;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

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
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: login_button_style.copyWith(
                  minimumSize: WidgetStateProperty.all(const Size(0, 55)),
                ),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final input = _useridController.text.trim();
                  final password = _passwordController.text.trim();
                  final userRepo = appRepos['userRepo'] as UserRepository;

                  User? user;
                  if (input.contains('@')) {
                    user = await userRepo.getUserByEmail(input);
                  }
                  user ??= await userRepo.getUserByUsername(input);
                  user ??= await userRepo.getUserByPhoneNumber(input);

                  if (user == null || user.id == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Invalid credentials. Check your email/phone and try again.'),
                        backgroundColor: AppTheme.failureColor,
                      ),
                    );
                    return;
                  }

                  // Note: password is collected but not validated against local DB (no stored hash yet)
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => HomeScreen(userId: user!.id),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                    (route) => false,
                  );
                },
                child: Text(loc.login, style: login_text_style),
              ),
            ),

            const SizedBox(height: 20),

            // Links Section
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    ///////////////////////////////////////////////////////
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => ForgotPasswordScreen(),
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
                    loc.forgotPassword,
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
                      loc.dontHaveAccount,
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
                Expanded(child: Divider(color: AppTheme.grey, thickness: 1)),
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

            const SizedBox(height: 20),

            // Single Google Sign In Button
            InkWell(
              onTap: () {

              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  border: Border.all(
                    color: context.secondaryTextColor.withOpacity(0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                    FontAwesomeIcons.google,
                    color: context.secondaryTextColor,
                    size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}