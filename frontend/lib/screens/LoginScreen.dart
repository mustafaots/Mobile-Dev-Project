import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/screens/ForgotPasswordScreen.dart';
import 'package:easy_vacation/screens/Home Screen/HomeScreen.dart';
import 'package:easy_vacation/shared/ui_widgets/app_progress_indicator.dart';
import 'package:easy_vacation/screens/SignUpScreen.dart';
import 'package:easy_vacation/services/sync/sync_manager.dart';
import 'package:easy_vacation/shared/secondary_styles.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/FormField.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _useridController = TextEditingController();

  bool _isLoading = false;

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
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;

                        final input = _useridController.text.trim();
                        final password = _passwordController.text;

                        setState(() => _isLoading = true);

                        try {
                          // Use AuthSyncService to login (syncs from remote and stores locally)
                          final result = await SyncManager.instance.auth.login(
                            email: input,
                            password: password,
                          );

                          if (!context.mounted) return;
                          setState(() => _isLoading = false);

                          if (result.isSuccess && result.data != null) {
                            // Login successful - navigate to home
                            final user = result.data!.user;
                            Navigator.pushAndRemoveUntil(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) =>
                                    HomeScreen(userId: user.id ?? ''),
                                transitionsBuilder: (_, animation, __, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                                transitionDuration: const Duration(
                                  milliseconds: 300,
                                ),
                              ),
                              (route) => false,
                            );
                          } else {
                            // Show error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  result.message ?? loc.loginFailed,
                                ),
                                backgroundColor: AppTheme.failureColor,
                              ),
                            );
                          }
                        } catch (e) {
                          if (!context.mounted) return;
                          setState(() => _isLoading = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                              backgroundColor: AppTheme.failureColor,
                            ),
                          );
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
                    : Text(loc.login, style: login_text_style),
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
          ],
        ),
      ),
    );
  }
}
