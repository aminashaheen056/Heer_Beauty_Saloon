
import 'package:flutter/material.dart';
import 'package:heer_beauty_saloon/customer/services_packages/services_package_details_booking.dart';

class AllPackagesScreen extends StatelessWidget {
  AllPackagesScreen({super.key});

  static const Color cream = Color(0xFFFFF8F0);
  static const Color blushPink = Color(0xFFE8A6B7);
  static const Color mocha = Color(0xFF6F4E37);
  static const Color golden = Color(0xFFD4AF37);

  final List<Map<String, dynamic>> packages = [
    {
      'name': 'Bridal Glow Package',
      'description':
      'A complete beauty package designed to make your special day memorable.',
      'price': 'Rs. 25,000',
      'validity': '30 Days',
      'image': 'assets/images/bridal1.jpg',
      'services': [
        'Bridal Makeup',
        'Hair Styling',
        'Facial',
        'Manicure',
        'Pedicure',
      ],
    },
    {
      'name': 'Hair Care Package',
      'description':
      'Give your hair the care and attention it deserves with our hair care package.',
      'price': 'Rs. 8,000',
      'validity': '15 Days',
      'image': 'assets/images/hair2.jpg',
      'services': [
        'Hair Spa',
        'Hair Cutting',
        'Hair Styling',
        'Hair Treatment',
      ],
    },
    {
      'name': 'Nail Care Package',
      'description':
      'Enjoy beautiful and well-maintained nails with our nail care services.',
      'price': 'Rs. 5,000',
      'validity': '15 Days',
      'image': 'assets/images/nail3.jpg',
      'services': [
        'Manicure',
        'Pedicure',
        'Nail Art',
        'Nail Polish',
      ],
    },
    {
      'name': 'Complete Beauty Package',
      'description':
      'A complete beauty experience covering hair, skin, makeup and nail care.',
      'price': 'Rs. 15,000',
      'validity': '30 Days',
      'image': 'assets/images/salon.jpg',
      'services': [
        'Facial',
        'Hair Styling',
        'Manicure',
        'Pedicure',
        'Party Makeup',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        title: const Text(
          'Beauty Packages',
          style: TextStyle(
            color: mocha,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: cream,
        elevation: 0,
        iconTheme: const IconThemeData(color: mocha),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Explore Our Packages',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: mocha,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Choose the perfect beauty package for yourself.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 20),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: packages.length,
              itemBuilder: (context, index) {
                final package = packages[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: mocha.withValues(alpha: 0.10),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                        child: Image.asset(
                          package['image'],
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 180,
                              width: double.infinity,
                              color: blushPink.withValues(alpha: 0.25),
                              child: const Icon(
                                Icons.spa,
                                size: 55,
                                color: mocha,
                              ),
                            );
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              package['name'],
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: mocha,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              package['description'],
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),

                            const SizedBox(height: 14),

                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  package['price'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: mocha,
                                  ),
                                ),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: golden,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      package['validity'],
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PackageDetailsBookingScreen(
                                            packageName: package['name'],
                                            description: package['description'],
                                            price: package['price'],
                                            validity: package['validity'],
                                            image: package['image'],
                                            includedServices:
                                            List<String>.from(
                                              package['services'],
                                            ),
                                          ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: blushPink,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 13,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'View Details',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
