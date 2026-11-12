
import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const Color cream = Color(0xFFFFF8F0);
  static const Color blushPink = Color(0xFFE8A6B7);
  static const Color mocha = Color(0xFF6F4E37);
  static const Color softBeige = Color(0xFFE8DCCB);

  Widget faqItem({
    required String question,
    required String answer,
  }) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        iconColor: mocha,
        collapsedIconColor: mocha,
        title: Text(
          question,
          style: const TextStyle(
            color: mocha,
            fontWeight: FontWeight.w600,
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: const TextStyle(
                color: mocha,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget supportOption({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: mocha),
        title: Text(
          title,
          style: const TextStyle(
            color: mocha,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,

      appBar: AppBar(
        title: const Text(
          'Help & Support',
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
              child: Column(
                children: const [
                  Icon(
                    Icons.support_agent,
                    size: 55,
                    color: mocha,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'How Can We Help You?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: mocha,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Find answers to common questions about our salon services.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: mocha,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // FAQ Section
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                color: mocha,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            faqItem(
              question: 'How can I book an appointment?',
              answer:
              'Open the Book Appointment section, select your desired service, choose a date and time, and confirm your booking.',
            ),

            faqItem(
              question: 'Can I cancel my appointment?',
              answer:
              'You can view your appointments in the My Appointments section. Cancellation depends on the salon cancellation policy.',
            ),

            faqItem(
              question: 'What payment methods are available?',
              answer:
              'Available payment methods are displayed on the Payment screen when you proceed with your booking.',
            ),

            faqItem(
              question: 'Can I view salon services and prices?',
              answer:
              'Yes. Visit the Services section to explore available beauty treatments and their prices.',
            ),

            faqItem(
              question: 'How can I contact the salon?',
              answer:
              'Open Contact Us from Settings to find the salon contact information.',
            ),

            const SizedBox(height: 20),

            // Support Options
            const Text(
              'Need More Help?',
              style: TextStyle(
                color: mocha,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            supportOption(
              icon: Icons.calendar_month_outlined,
              title: 'Booking Support',
              subtitle: 'Get assistance with your appointments',
            ),

            supportOption(
              icon: Icons.payment_outlined,
              title: 'Payment Support',
              subtitle: 'Get help with payment-related issues',
            ),

            supportOption(
              icon: Icons.spa_outlined,
              title: 'Service Information',
              subtitle: 'Learn more about our salon services',
            ),

            const SizedBox(height: 20),

            // Footer
            Center(
              child: Column(
                children: const [
                  Text(
                    'HEER Beauty Salon',
                    style: TextStyle(
                      color: mocha,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'We are always happy to assist you!',
                    style: TextStyle(
                      color: mocha,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
