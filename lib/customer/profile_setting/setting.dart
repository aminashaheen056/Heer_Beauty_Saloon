
import 'package:flutter/material.dart';

import 'my_profile.dart';
import 'account_security.dart';
import 'contact_us.dart';
import 'about_screen.dart';
import 'help_support_screen.dart';
import 'privacy_policy_screen.dart';
import '../authentication/welcome_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final Color cream = const Color(0xFFFFF8F0);
  final Color blushPink = const Color(0xFFE8A6B7);
  final Color mocha = const Color(0xFF6F4E37);
  final Color softBeige = const Color(0xFFE8DCCB);

  bool notificationsEnabled = true;

  Widget settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        leading: Icon(icon, color: mocha),
        title: Text(
          title,
          style: TextStyle(
            color: mocha,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: mocha,
        ),
        onTap: onTap,
      ),
    );
  }

  void showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cream,
        title: Text(
          'Logout',
          style: TextStyle(color: mocha),
        ),
        content: const Text(
          'Are you sure you want to logout?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: mocha)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: mocha,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                this.context,
                MaterialPageRoute(
                  builder: (context) => const WelcomeScreen(),
                ),
                    (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,

      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: mocha,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: blushPink,
        foregroundColor: mocha,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Section
            Text(
              'ACCOUNT',
              style: TextStyle(
                color: mocha,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 12),

            settingTile(
              icon: Icons.person_outline,
              title: 'My Profile',
              subtitle: 'View and edit your personal information',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyProfileScreen(),
                  ),
                );
              },
            ),

            settingTile(
              icon: Icons.lock_outline,
              title: 'Account Security',
              subtitle: 'Change your password',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountSecurityScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 18),

            // Preferences Section
            Text(
              'PREFERENCES',
              style: TextStyle(
                color: mocha,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 12),

            Card(
              color: Colors.white,
              elevation: 1,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                secondary: Icon(
                  Icons.notifications_outlined,
                  color: mocha,
                ),
                title: Text(
                  'Notifications',
                  style: TextStyle(
                    color: mocha,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text('Enable or disable notifications'),
                activeThumbColor: mocha,
                value: notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    notificationsEnabled = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 18),

            // Support Section
            Text(
              'SUPPORT & INFORMATION',
              style: TextStyle(
                color: mocha,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 12),

            settingTile(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help with your account and bookings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpSupportScreen(),
                  ),
                );
              },
            ),

            settingTile(
              icon: Icons.phone_outlined,
              title: 'Contact Us',
              subtitle: 'Get in touch with our salon',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactUsScreen(),
                  ),
                );
              },
            ),

            settingTile(
              icon: Icons.info_outline,
              title: 'About Us',
              subtitle: 'Learn more about HEER Beauty Salon',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutScreen(),
                  ),
                );
              },
            ),

            settingTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Logout
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: showLogoutDialog,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                  side: BorderSide(color: Colors.red.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                'HEER Beauty Salon',
                style: TextStyle(
                  color: mocha,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 5),

            Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: mocha.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
