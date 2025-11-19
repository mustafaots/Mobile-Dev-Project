import 'package:easy_vacation/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/themes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _navIdx = 4; // Profile is index 4

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppTheme.black,
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        backgroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: 128,
                      height: 128,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuB8oBGBPI4UQgunUlLsbeG4LUCDyQOMJF7C52rKedX1NSZNqWTIc_lLUZgNjYD16keoTwuGfxpaqSo405BelcjMCKal_PA_rxLg1_Ebw5cFfY7t-FGo11kuFKWJmzypIC5g2e7mNvNHwNlyorCpzomh0rpWo3MMEK5Kurz-muMtXrh3LGps3M_ldfNF0Hxm3atFKU1TCfxRQ22nMiHRVvyXelgdHD0FjrVmHRk1ExmxHsazhYbgIfMNEN73JZr0JnuGPsfkjy6ZaNw',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Mohamed',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Mohamed@easyvacation.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.grey,
                      ),
                    ),
                  ],
                ),
              ),
              // ... rest of your existing profile content
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SubscriptionCard(),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.edit,
                      title: 'Edit profile',
                    ),
                    const SizedBox(height: 8),
                    _buildMenuItem(
                      icon: Icons.article,
                      title: 'View posts created',
                    ),
                    const SizedBox(height: 8),
                    _buildMenuItem(
                      icon: Icons.history,
                      title: 'View booking history',
                    ),
                    const SizedBox(height: 8),
                    _buildMenuItem(
                      icon: Icons.subscriptions,
                      title: 'Manage subscription',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const LoginScreen(),
                          transitionsBuilder: (_, animation, __, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 300),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.failureColor.withOpacity(0.1),
                      foregroundColor: AppTheme.failureColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.logout, size: 20),
                    label: const Text(
                      'Log out',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Handle menu item tap
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 56,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.black,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppTheme.grey,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Extract subscription card to separate widget
class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.neutralColor,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: const Icon(
              Icons.workspace_premium,
              color: AppTheme.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Subscription: ',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.black,
                    ),
                  ),
                  TextSpan(
                    text: 'Monthly',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.neutralColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}