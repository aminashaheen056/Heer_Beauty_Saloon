
import 'package:flutter/material.dart';
import 'service_detail.dart';
class SkincareServices extends StatelessWidget {
  const SkincareServices({super.key});

  static const Color cream = Color(0xFFFFF8F0);
  static const Color blushPink = Color(0xFFE8A6B7);
  static const Color mocha = Color(0xFF6F4E37);
  static const Color softBeige = Color(0xFFE8DCCB);

  final List<Map<String, String>> services = const [
    {
      'name': 'Basic Facial',
      'description': 'A refreshing facial for clean and glowing skin.',
      'price': 'Rs. 2,000',
      'duration': '45 minutes',
      'image': 'assets/images/facial.jpg',
    },
    {
      'name': 'Deep Cleansing Facial',
      'description': 'Deep cleansing to remove dirt and impurities.',
      'price': 'Rs. 2,500',
      'duration': '1 hour',
      'image': 'assets/images/facial1.jpg',
    },
    {
      'name': 'Hydrating Facial',
      'description': 'A moisturizing treatment for soft skin.',
      'price': 'Rs. 3,000',
      'duration': '1 hour',
      'image': 'assets/images/facial.jpg',
    },
    {
      'name': 'Brightening Facial',
      'description': 'A refreshing facial for a radiant appearance.',
      'price': 'Rs. 3,500',
      'duration': '1 hour',
      'image': 'assets/images/facial1.jpg',
    },
    {
      'name': 'Face Cleanup',
      'description': 'Basic skin cleansing and gentle exfoliation.',
      'price': 'Rs. 1,500',
      'duration': '30 minutes',
      'image': 'assets/images/facial.jpg',
    },
    {
      'name': 'Face Mask Treatment',
      'description': 'A relaxing mask treatment for your skin.',
      'price': 'Rs. 1,800',
      'duration': '40 minutes',
      'image': 'assets/images/facial1.jpg',
    },
  ];

  Widget serviceCard(
      BuildContext context,
      Map<String, String> service,
      ) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            service['image']!,
            height: 155,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 155,
                color: softBeige,
                child: const Center(
                  child: Icon(
                    Icons.spa_outlined,
                    size: 45,
                    color: mocha,
                  ),
                ),
              );
            },
          ),

          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['name']!,
                  style: const TextStyle(
                    color: mocha,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  service['description']!,
                  style: const TextStyle(
                    color: mocha,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      service['price']!,
                      style: const TextStyle(
                        color: mocha,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      service['duration']!,
                      style: const TextStyle(
                        color: mocha,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ServiceDetailScreen(
                            serviceName: service['name']!,
                            description: service['description']!,
                            price: service['price']!,
                            duration: service['duration']!,
                            image: service['image']!,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mocha,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Select Service'),
                  ),
                ),
              ],
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
          'Skincare Services',
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Our Skincare Services',
              style: TextStyle(
                color: mocha,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Refresh your skin and enjoy a relaxing experience.',
              style: TextStyle(color: mocha),
            ),

            const SizedBox(height: 20),

            ...services.map(
                  (service) => serviceCard(context, service),
            ),
          ],
        ),
      ),
    );
  }
}
