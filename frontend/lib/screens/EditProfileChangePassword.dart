import 'package:easy_vacation/screens/LoginScreen.dart';
import 'package:easy_vacation/services/api/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/shared_styles.dart';
import 'package:easy_vacation/shared/secondary_styles.dart';
import 'package:easy_vacation/shared/ui_widgets/FormField.dart';

class ChangePasswordScreen extends StatefulWidget {
  final dynamic userId;
  const ChangePasswordScreen({super.key, this.userId});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  void handleUpdatePassword() async {
    if(!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final response = await AuthService.instance.changePassword(
        currentPassword: _currentPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
      );

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.data ?? AppLocalizations.of(context)!.passwordUpdatedSuccess),
            backgroundColor: Colors.green,
          ),
        );

        // Security best practice: login again
        Future.delayed(const Duration(seconds: 2), () {
          AuthService.instance.logout();

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        });
      } else {
        throw response.message ?? AppLocalizations.of(context)!.updatePasswordFailed;
      }
    }
    catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
    finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.changePasswordTitle,
          style: header_1.copyWith(fontSize: 22),
        )
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            space(20),

            Row(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      space(8),
                      Text(
                        loc.changePasswordSubtitle,
                        style: small_grey_text,
                      ),
                    ],
                  ),
                ),
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
              ],
            ),

            space(30),

            // Form Section
            Form(
              key: _formKey,
              child: Column(
                children: [
                  buildFormField(
                    context,
                    controller: _currentPasswordController,
                    label: loc.currentPasswordLabel,
                    icon: Icons.lock,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return loc.currentPasswordRequiredError;
                      }
                      return null;
                    },
                  ),

                  space(20),

                  buildFormField(
                    context,
                    controller: _newPasswordController,
                    label: loc.newPasswordLabel,
                    icon: Icons.lock_outline,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return loc.newPasswordRequiredError;
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
                    controller: _confirmPasswordController,
                    label: loc.confirmNewPasswordLabel,
                    icon: Icons.lock_reset,
                    obscureText: true,
                    validator: (value) {
                      if (value != _newPasswordController.text) {
                        return loc.passwordMismatchError;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            space(30),

            // Update Button (no logic yet)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: login_button_style.copyWith(
                  minimumSize: MaterialStateProperty.all(
                    const Size(0, 55),
                  ),
                ),
                onPressed: _isLoading ? null : () {
                  handleUpdatePassword();
                },
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
                        loc.updatePasswordButton,
                        style: login_text_style,
                      ),
              ),
            ),

            space(80),

            // Info Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue[700],
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                        loc.reloginHint,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                      ),
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