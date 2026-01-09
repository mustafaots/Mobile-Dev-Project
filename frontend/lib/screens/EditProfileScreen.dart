import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/users.model.dart';
import 'package:easy_vacation/repositories/db_repositories/db_repo.dart';
import 'package:easy_vacation/shared/ui_widgets/app_progress_indicator.dart';
import 'package:easy_vacation/main.dart';
import 'package:easy_vacation/screens/EditProfileChangePassword.dart';
import 'package:easy_vacation/services/api/auth_service.dart';
import 'package:easy_vacation/services/api/profile_service.dart';
import 'package:easy_vacation/services/sync/connectivity_service.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final dynamic userId;
  const EditProfileScreen({super.key, this.userId});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  User? _user;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _emailVerified = false;
  bool _isSendingVerification = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadEmailStatus();
  }

  Future<void> _loadEmailStatus() async {
    final result = await AuthService.instance.getEmailVerificationStatus();
    if (mounted && result.isSuccess && result.data != null) {
      setState(() {
        _emailVerified = result.data!.emailVerified;
      });
    }
  }

  Future<void> _loadUser() async {
    if (widget.userId != null) {
      final userRepo = appRepos['userRepo'] as UserRepository;
      final user = await userRepo.getUserById(widget.userId.toString());
      if (mounted && user != null) {
        setState(() {
          _user = user;
          _firstNameController.text = user.firstName ?? '';
          _lastNameController.text = user.lastName ?? '';
          _emailController.text = user.email;
          _phoneController.text = user.phoneNumber ?? '';
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getInitials() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '${firstName[0]}${lastName[0]}'.toUpperCase();
    } else if (firstName.isNotEmpty) {
      return firstName[0].toUpperCase();
    } else if (_emailController.text.isNotEmpty) {
      return _emailController.text[0].toUpperCase();
    }
    return '?';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    final loc = AppLocalizations.of(context)!;
    
    // Validate required fields
    if (_firstNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.failureColor,
          content: Text('First name is required'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (_lastNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.failureColor,
          content: Text('Last name is required'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Check connectivity
      final isOnline = await ConnectivityService.instance.checkConnectivity();
      
      if (isOnline) {
        // Update on backend
        final result = await ProfileService.instance.updateMyProfile(
          UpdateProfileRequest(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            phone: _phoneController.text.trim().isNotEmpty 
                ? _phoneController.text.trim() 
                : null,
          ),
        );

        if (!mounted) return;

        if (result.isSuccess) {
          // Update local database
          if (_user != null && _user!.id != null) {
            final userRepo = appRepos['userRepo'] as UserRepository;
            final updatedUser = User(
              id: _user!.id,
              username: _user!.username,
              email: _user!.email,
              phoneNumber: _phoneController.text.trim().isNotEmpty 
                  ? _phoneController.text.trim() 
                  : _user!.phoneNumber,
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              createdAt: _user!.createdAt,
              isVerified: _user!.isVerified,
              userType: _user!.userType,
              isSuspended: _user!.isSuspended,
            );
            await userRepo.updateUser(_user!.id!, updatedUser);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppTheme.successColor,
              content: Text(loc.editProfile_profileUpdated),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );

          // Navigate back after a short delay
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (mounted) Navigator.pop(context, true); // Return true to indicate update
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppTheme.failureColor,
              content: Text(result.message ?? 'Failed to update profile'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.failureColor,
            content: Text('No internet connection'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.failureColor,
          content: Text('Error: $e'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final loc = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: App_Bar(context, loc.editProfile_title),
        body: const Center(child: AppProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: App_Bar(context, loc.editProfile_title),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Picture Section
              Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          border: Border.all(
                            color: AppTheme.primaryColor,
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _getInitials(),
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),

              const SizedBox(height: 24),

              // Form Fields
              Column(
                children: [
                  _buildFormField(
                    context: context,
                    controller: _firstNameController,
                    label: loc.firstName,
                    icon: Icons.person,
                    isRequired: true,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    context: context,
                    controller: _lastNameController,
                    label: loc.lastName,
                    icon: Icons.person_outline,
                    isRequired: true,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    context: context,
                    controller: _emailController,
                    label: loc.editProfile_emailAddress,
                    icon: Icons.email,
                    isRequired: true,
                    enabled: false, // Email cannot be changed
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    context: context,
                    controller: _phoneController,
                    label: loc.editProfile_phoneNumber,
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  // Email verification status/button
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Icon(
                          _emailVerified ? Icons.verified : Icons.warning_amber_rounded,
                          size: 18,
                          color: _emailVerified ? AppTheme.successColor : AppTheme.neutralColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _emailVerified ? 'Email verified' : 'Email not verified',
                            style: TextStyle(
                              fontSize: 13,
                              color: _emailVerified ? AppTheme.successColor : AppTheme.neutralColor,
                            ),
                          ),
                        ),
                        if (!_emailVerified)
                          TextButton(
                            onPressed: _isSendingVerification ? null : () async {
                              setState(() => _isSendingVerification = true);
                              
                              final result = await AuthService.instance.sendEmailVerification();
                              
                              if (!mounted) return;
                              setState(() => _isSendingVerification = false);
                              
                              if (result.isSuccess && result.data != null) {
                                if (result.data!.alreadyVerified) {
                                  setState(() => _emailVerified = true);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('Email is already verified!'),
                                      backgroundColor: AppTheme.successColor,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Verification email sent to ${_emailController.text}'),
                                      backgroundColor: AppTheme.successColor,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result.message ?? 'Failed to send verification email'),
                                    backgroundColor: AppTheme.failureColor,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.primaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            ),
                            child: _isSendingVerification
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: AppProgressIndicator(strokeWidth: 2),
                                  )
                                : const Text('Verify Now'),
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: AppProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          loc.save,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // Additional Options
              Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: context.textColor.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildOptionTile(
                      context: context,
                      icon: Icons.lock,
                      title: loc.editProfile_changePassword,
                      onTap: () {
                        // Navigate to change password screen
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => ChangePasswordScreen(userId: widget.userId,),
                            transitionsBuilder: (_, animation, __, child) =>
                                FadeTransition(opacity: animation, child: child),
                            transitionDuration: const Duration(milliseconds: 300),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Delete Account Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Show delete account confirmation
                    _showDeleteAccountDialog();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.failureColor,
                    side: BorderSide(color: AppTheme.failureColor),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    loc.editProfile_deleteAccount,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isRequired = false,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    final cardColor = context.cardColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;

    return Container(
      decoration: BoxDecoration(
        color: enabled ? cardColor : cardColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: textColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        enabled: enabled,
        style: TextStyle(
          color: enabled ? textColor : secondaryTextColor,
        ),
        decoration: InputDecoration(
          labelText: '$label${isRequired ? ' *' : ''}',
          prefixIcon: Icon(icon, color: enabled ? AppTheme.primaryColor : AppTheme.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: enabled ? cardColor : cardColor.withOpacity(0.6),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, color: AppTheme.primaryColor, size: 20),
      ),
      title: Text(title, style: TextStyle(fontSize: 16, color: textColor)),
      trailing: Icon(Icons.chevron_right, color: secondaryTextColor),
      onTap: onTap,
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.editProfile_deleteAccountTitle),
        content: Text(
          AppLocalizations.of(context)!.editProfile_deleteAccountMessage,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.profile_cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.failureColor),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount() async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            AppProgressIndicator(),
            const SizedBox(width: 20),
            const Text('Deleting account...'),
          ],
        ),
      ),
    );

    try {
      final result = await ProfileService.instance.deleteAccount();
      
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      if (result.isSuccess) {
        // Clear local auth data
        AuthService.instance.logout();
        
        if (!mounted) return;
        
        // Navigate to welcome screen and clear navigation stack
        Navigator.pushNamedAndRemoveUntil(
          context, 
          '/', 
          (route) => false,
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message ?? 'Failed to delete account'),
            backgroundColor: AppTheme.failureColor,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppTheme.failureColor,
        ),
      );
    }
  }
}
