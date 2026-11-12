
import 'package:flutter/material.dart';

class OfferColors {
  static const Color cream = Color(0xFFFFF8F0);
  static const Color blushPink = Color(0xFFE8A6B7);
  static const Color white = Colors.white;
  static const Color mocha = Color(0xFF6F4E37);
  static const Color golden = Color(0xFFD4AF37);
  static const Color softBeige = Color(0xFFE8DCCB);
}

class OfferScreen extends StatelessWidget {
  const OfferScreen({super.key});

  final List<Map<String, String>> offers = const [
    {
      'title': 'Bridal Makeup',
      'discount': '20% OFF',
      'description':
      'Get a beautiful bridal makeover at a special discounted price.',
      'validity': 'Valid until 30 November 2026',
      'image': 'assets/images/bridal2.jpg',
    },
    {
      'title': 'Hair Styling',
      'discount': '15% OFF',
      'description':
      'Enjoy professional hair styling with our expert stylists.',
      'validity': 'Valid until 30 November 2026',
      'image': 'assets/images/hair.jpg',
    },
    {
      'title': 'Nail Art',
      'discount': '10% OFF',
      'description':
      'Give your nails a stylish look with our special nail art offer.',
      'validity': 'Valid until 25 November 2026',
      'image': 'assets/images/nail2.jpg',
    },
    {
      'title': 'Facial Treatment',
      'discount': '25% OFF',
      'description':
      'Refresh your skin with our relaxing facial treatment.',
      'validity': 'Valid until 25 November 2026',
      'image': 'assets/images/facial.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OfferColors.cream,

      appBar: AppBar(
        title: const Text(
          'Special Offers',
          style: TextStyle(
            color: OfferColors.mocha,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: OfferColors.cream,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: OfferColors.mocha,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Offers Banner
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/images/bridal2.jpg',
                width: double.infinity,
                height: 170,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Exclusive Beauty Deals',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: OfferColors.mocha,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Enjoy special discounts on your favourite salon services.',
              style: TextStyle(
                fontSize: 14,
                color: OfferColors.mocha,
              ),
            ),

            const SizedBox(height: 22),

            // Offer Cards
            ...offers.map((offer) {

              return Container(
                margin: const EdgeInsets.only(bottom: 20),

                decoration: BoxDecoration(
                  color: OfferColors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: OfferColors.softBeige,
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Offer Image
                    Stack(
                      children: [

                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(14),
                          ),

                          child: Image.asset(
                            offer['image']!,
                            height: 190,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        Positioned(
                          top: 12,
                          right: 12,

                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 9,
                            ),

                            decoration: BoxDecoration(
                              color: OfferColors.blushPink,
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: Text(
                              offer['discount']!,
                              style: const TextStyle(
                                color: OfferColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(15),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            offer['title']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: OfferColors.mocha,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            offer['description']!,
                            style: const TextStyle(
                              color: OfferColors.mocha,
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            offer['validity']!,
                            style: const TextStyle(
                              color: OfferColors.golden,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
