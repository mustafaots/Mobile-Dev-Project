import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill with current user data (in real app, this would come from your user model)
    _nameController.text = 'Mohamed Ali';
    _emailController.text = 'mohamed@easyvacation.com';
    _bioController.text =
        'Travel enthusiast exploring the world one destination at a time. Sharing my experiences and tips!';
    _locationController.text = 'Casablanca, Morocco';
    _phoneController.text = '+213 123 456 789';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    // Handle save logic here
    //final newName = _nameController.text;
    //final newEmail = _emailController.text;
    //final newBio = _bioController.text;
    //final newLocation = _locationController.text;
    //final newPhone = _phoneController.text;

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.successColor,
        content: const Text('Profile updated successfully!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    // Navigate back after a short delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pop(context);
    });
  }

  Future<void> _changeProfilePicture() async {
    // Simple implementation - in real app, you'd use image_picker
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Profile Picture'),
        content: const Text('Choose an option'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle camera
            },
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle gallery
            },
            child: const Text('Gallery'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: App_Bar(context,'Edit Profile'),
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
                          border: Border.all(
                            color: AppTheme.primaryColor,
                            width: 3,
                          ),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuB8oBGBPI4UQgunUlLsbeG4LUCDyQOMJF7C52rKedX1NSZNqWTIc_lLUZgNjYD16keoTwuGfxpaqSo405BelcjMCKal_PA_rxLg1_Ebw5cFfY7t-FGo11kuFKWJmzypIC5g2e7mNvNHwNlyorCpzomh0rpWo3MMEK5Kurz-muMtXrh3LGps3M_ldfNF0Hxm3atFKU1TCfxRQ22nMiHRVvyXelgdHD0FjrVmHRk1ExmxHsazhYbgIfMNEN73JZr0JnuGPsfkjy6ZaNw',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _changeProfilePicture,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.white,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: AppTheme.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _changeProfilePicture,
                    child: Text(
                      'Change Photo',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Form Fields
              Column(
                children: [
                  _buildFormField(
                    context: context,
                    controller: _nameController,
                    label: 'Full Name',
                    icon: Icons.person,
                    isRequired: true,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    context: context,
                    controller: _emailController,
                    label: 'Email Address',
                    icon: Icons.email,
                    isRequired: true,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    context: context,
                    controller: _phoneController,
                    label: 'Phone Number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    context: context,
                    controller: _locationController,
                    label: 'Location',
                    icon: Icons.location_on,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    context: context,
                    controller: _bioController,
                    label: 'Bio',
                    icon: Icons.description,
                    maxLines: 3,
                  ),
                ],
              ),

              const SizedBox(height: 32),

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
                      title: 'Change Password',
                      onTap: () {
                        // Navigate to change password screen
                      },
                    ),
                    _buildOptionTile(
                      context: context,
                      icon: Icons.notifications,
                      title: 'Notification Settings',
                      onTap: () {
                        // Navigate to notification settings
                      },
                    ),
                    _buildOptionTile(
                      context: context,
                      icon: Icons.privacy_tip,
                      title: 'Privacy Settings',
                      onTap: () {
                        // Navigate to privacy settings
                      },
                    ),
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
                  child: const Text(
                    'Delete Account',
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
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    final cardColor = context.cardColor;
    final textColor = context.textColor;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
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
        decoration: InputDecoration(
          labelText: '$label${isRequired ? ' *' : ''}',
          prefixIcon: Icon(icon, color: AppTheme.primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: cardColor,
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
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle account deletion
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.failureColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
