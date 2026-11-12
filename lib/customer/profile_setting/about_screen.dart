
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const Color cream = Color(0xFFFFF8F0);
  static const Color blushPink = Color(0xFFE8A6B7);
  static const Color mocha = Color(0xFF6F4E37);
  static const Color golden = Color(0xFFD4AF37);
  static const Color softBeige = Color(0xFFE8DCCB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,

      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          'About Us',
          style: TextStyle(
            color: mocha,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),

        iconTheme: const IconThemeData(
          color: mocha,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [

            const SizedBox(height: 10),

            // Salon Image / Logo

            ClipRRect(
              borderRadius: BorderRadius.circular(18),

              child: Image.asset(
                'assets/images/salon.jpg',
                height: 190,
                width: double.infinity,
                fit: BoxFit.cover,

                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 190,
                    width: double.infinity,
                    color: softBeige,
                    alignment: Alignment.center,
                    child: const Text(
                      'Add Your Salon Image',
                      style: TextStyle(
                        color: mocha,
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            // Salon Name

            const Text(
              'HEER',
              style: TextStyle(
                color: mocha,
                fontSize: 34,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'BEAUTY SALON',
              style: TextStyle(
                color: golden,
                fontSize: 15,
                letterSpacing: 4,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 15),

            Container(
              width: 75,
              height: 2,
              color: golden,
            ),

            const SizedBox(height: 25),

            // About Description

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Who We Are',
                style: TextStyle(
                  color: mocha,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'HEER Beauty Salon is dedicated to enhancing your '
                  'natural beauty and providing a relaxing beauty '
                  'experience. We aim to make every customer feel '
                  'confident, beautiful, and special.',

              style: TextStyle(
                color: mocha,
                fontSize: 14,
                height: 1.7,
              ),

              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 25),

            // Our Mission

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: softBeige),
              ),

              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(
                    'Our Mission',
                    style: TextStyle(
                      color: mocha,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    'Our mission is to provide quality beauty '
                        'services in a comfortable and welcoming '
                        'environment while ensuring customer '
                        'satisfaction.',

                    style: TextStyle(
                      color: mocha,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Our Vision

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: softBeige),
              ),

              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(
                    'Our Vision',
                    style: TextStyle(
                      color: mocha,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    'Our vision is to become a trusted beauty '
                        'destination known for professional services, '
                        'creativity, and a memorable customer experience.',

                    style: TextStyle(
                      color: mocha,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Our Services

            const Align(
              alignment: Alignment.centerLeft,

              child: Text(
                'What We Offer',
                style: TextStyle(
                  color: mocha,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            serviceItem('Hair Styling'),
            serviceItem('Professional Makeup'),
            serviceItem('Nail Art'),
            serviceItem('Facial & Skin Care'),
            serviceItem('Bridal Services'),

            const SizedBox(height: 25),

            // Tagline

            const Text(
              'Your Beauty, Our Passion',
              style: TextStyle(
                color: blushPink,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Thank you for choosing HEER Beauty Salon!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: mocha,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  static Widget serviceItem(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Row(
        children: [

          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: golden,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 12),

          Text(
            title,
            style: const TextStyle(
              color: mocha,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
