
import 'package:flutter/material.dart';

class ContactColors {
  static const Color cream = Color(0xFFFFF8F0);
  static const Color blushPink = Color(0xFFE8A6B7);
  static const Color white = Color(0xFFFFFFFF);
  static const Color mocha = Color(0xFF6F4E37);
  static const Color golden = Color(0xFFD4AF37);
  static const Color softBeige = Color(0xFFE8DCCB);
}

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void sendMessage() {
    if (formKey.currentState!.validate()) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your message has been submitted successfully!',
          ),
          backgroundColor: ContactColors.mocha,
        ),
      );

      nameController.clear();
      emailController.clear();
      messageController.clear();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Widget contactInfo({
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: ContactColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ContactColors.softBeige,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: const TextStyle(
              color: ContactColors.golden,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            value,
            style: const TextStyle(
              color: ContactColors.mocha,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget inputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          label,
          style: const TextStyle(
            color: ContactColors.mocha,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,

          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),

            filled: true,
            fillColor: ContactColors.white,

            contentPadding: const EdgeInsets.all(14),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: ContactColors.softBeige,
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: ContactColors.softBeige,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: ContactColors.blushPink,
                width: 2,
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ContactColors.cream,

      appBar: AppBar(
        title: const Text(
          'Contact Us',
          style: TextStyle(
            color: ContactColors.mocha,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
        backgroundColor: ContactColors.cream,
        elevation: 0,

        iconTheme: const IconThemeData(
          color: ContactColors.mocha,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // Contact Banner
            ClipRRect(
              borderRadius: BorderRadius.circular(15),

              child: Image.asset(
                'assets/images/salon.png',
                width: double.infinity,
                height: 170,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Get in Touch',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: ContactColors.mocha,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'We would love to hear from you. '
                  'Contact us for appointments, questions, '
                  'or any beauty-related assistance.',
              style: TextStyle(
                color: ContactColors.mocha,
                fontSize: 14,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 22),

            // Contact Information
            const Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: ContactColors.mocha,
              ),
            ),

            const SizedBox(height: 14),

            contactInfo(
              title: 'Phone Number',
              value: 'Add your salon phone number',
            ),

            contactInfo(
              title: 'Email Address',
              value: 'Add your salon email address',
            ),

            contactInfo(
              title: 'Salon Address',
              value: 'Add your salon location',
            ),

            const SizedBox(height: 12),

            // Opening Hours
            const Text(
              'Opening Hours',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: ContactColors.mocha,
              ),
            ),

            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: ContactColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ContactColors.softBeige,
                ),
              ),

              child: const Column(
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Monday - Saturday'),
                      Text(
                        '10 AM - 8 PM',
                        style: TextStyle(
                          color: ContactColors.mocha,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Divider(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sunday'),
                      Text(
                        'Closed',
                        style: TextStyle(
                          color: ContactColors.blushPink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Message Form
            const Text(
              'Send Us a Message',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: ContactColors.mocha,
              ),
            ),

            const SizedBox(height: 16),

            Form(
              key: formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  inputField(
                    label: 'Your Name',
                    hint: 'Enter your name',
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),

                  inputField(
                    label: 'Email Address',
                    hint: 'Enter your email',
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }

                      final emailPattern =
                      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

                      if (!emailPattern.hasMatch(value.trim())) {
                        return 'Please enter a valid email';
                      }

                      return null;
                    },
                  ),

                  inputField(
                    label: 'Your Message',
                    hint: 'Write your message here...',
                    controller: messageController,
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your message';
                      }
                      return null;
                    },
                  ),

                  // Send Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,

                    child: ElevatedButton(
                      onPressed: sendMessage,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: ContactColors.blushPink,
                        foregroundColor: ContactColors.white,
                        elevation: 0,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      child: const Text(
                        'Send Message',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Center(
              child: Text(
                'HEER BEAUTY SALON',
                style: TextStyle(
                  color: ContactColors.mocha,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),

            const SizedBox(height: 8),

            const Center(
              child: Text(
                'Your Beauty, Our Passion',
                style: TextStyle(
                  color: ContactColors.golden,
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
