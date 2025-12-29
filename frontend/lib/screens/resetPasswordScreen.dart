import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/shared_styles.dart';
import 'package:easy_vacation/shared/secondary_styles.dart';
import 'package:easy_vacation/shared/ui_widgets/FormField.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/services/api/auth_service.dart';
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/screens/LoginScreen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String token;
  const ResetPasswordScreen({super.key, required this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _isLoading = false;

  void _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await AuthService.instance.resetPassword(
        token: widget.token,
        newPassword: _passwordController.text.trim(),
      );

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.data ?? AppLocalizations.of(context)!.passwordUpdatedSuccess),
            backgroundColor: Colors.green,
          ),
        );

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const LoginScreen(),
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
              transitionDuration: const Duration(milliseconds: 300),
            ),
            (route) => false,
          );
        });
      } else {
        throw response.message ?? AppLocalizations.of(context)!.resetPasswordFailed;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            space(40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.resetPasswordTitle,
                        style: header_1.copyWith(fontSize: 28),
                      ),
                      space(8),
                      Text(
                        loc.resetPasswordSubtitle,
                        style: small_grey_text,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 90,
                  height: 90,
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

            space(40),

            // Icon Illustration
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline,
                size: 60,
                color: AppTheme.primaryColor,
              ),
            ),

            space(30),

            // Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  buildFormField(
                    context,
                    controller: _passwordController,
                    label: loc.newPasswordLabel,
                    icon: Icons.lock,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return loc.passwordEmptyError;
                      }
                      if (value.length < 6) {
                        return loc.passwordLengthError;
                      }
                      return null;
                    },
                  ),

                  space(20),

                  buildFormField(
                    context,
                    controller: _confirmController,
                    label: loc.confirmPasswordLabel,
                    icon: Icons.lock_reset,
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return loc.passwordMismatchError;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            space(30),

            // Reset Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: login_button_style.copyWith(
                  minimumSize: MaterialStateProperty.all(const Size(0, 55)),
                ),
                onPressed: _isLoading ? null : _handleResetPassword,
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        loc.resetPasswordTitle,
                        style: login_text_style,
                      ),
              ),
            ),

            space(30),

            // Security Hint
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.security, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      loc.securityRedirectHint,
                      style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}