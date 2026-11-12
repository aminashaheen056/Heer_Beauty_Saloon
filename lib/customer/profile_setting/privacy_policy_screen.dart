
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const Color cream = Color(0xFFFFF8F0);
  static const Color blushPink = Color(0xFFE8A6B7);
  static const Color mocha = Color(0xFF6F4E37);
  static const Color softBeige = Color(0xFFE8DCCB);

  Widget policySection({
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: softBeige),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: mocha,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: mocha,
            ),
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
        title: const Text(
          'Privacy Policy',
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
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: softBeige,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.privacy_tip_outlined,
                    size: 55,
                    color: mocha,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Your Privacy Matters',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: mocha,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'We respect your privacy and are committed to protecting your personal information.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: mocha,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Privacy Policy',
              style: TextStyle(
                color: mocha,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Last Updated: November 2026',
              style: TextStyle(
                color: mocha,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 18),

            policySection(
              title: '1. Information We Collect',
              description:
              'HEER Beauty Salon may collect customer information such as name, email address, phone number, and appointment details when you use our application.',
            ),

            policySection(
              title: '2. How We Use Your Information',
              description:
              'Your information may be used to manage appointments, process bookings, provide salon services, communicate with customers, and improve the application.',
            ),

            policySection(
              title: '3. Information Protection',
              description:
              'We aim to protect customer information from unauthorized access, misuse, alteration, or disclosure through appropriate security measures.',
            ),

            policySection(
              title: '4. Payment Information',
              description:
              'Payment information is used only for handling transactions. Sensitive payment details should be processed through secure payment services.',
            ),

            policySection(
              title: '5. Information Sharing',
              description:
              'Customer information should not be sold to third parties. Information may only be shared when necessary to provide services or when legally required.',
            ),

            policySection(
              title: '6. Data Retention',
              description:
              'Customer information may be retained as long as necessary to manage appointments, maintain records, and meet applicable legal requirements.',
            ),

            policySection(
              title: '7. Customer Rights',
              description:
              'Customers may request access to, correction of, or deletion of their personal information, subject to applicable legal requirements.',
            ),

            policySection(
              title: '8. Policy Updates',
              description:
              'HEER Beauty Salon may update this Privacy Policy when necessary. Customers should review this page periodically for changes.',
            ),

            policySection(
              title: '9. Contact Us',
              description:
              'If you have questions about this Privacy Policy or your personal information, please contact HEER Beauty Salon through the Contact Us section.',
            ),

            const SizedBox(height: 15),

            Center(
              child: Text(
                'HEER Beauty Salon',
                style: TextStyle(
                  color: mocha,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 5),

            const Center(
              child: Text(
                'Thank you for trusting us!',
                style: TextStyle(
                  color: mocha,
                  fontSize: 13,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
