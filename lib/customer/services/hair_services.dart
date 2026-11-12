
import 'package:flutter/material.dart';
import 'service_detail.dart';


class HairServices extends StatelessWidget {
  const HairServices({super.key});

  static const Color cream = Color(0xFFFFF8F0);
  static const Color pink = Color(0xFFE8A6B7);
  static const Color mocha = Color(0xFF6F4E37);

  static const List<Map<String, String>> services = [
    {
      'name': 'Hair Cutting',
      'description':
      'Professional haircut and styling for a fresh and beautiful look.',
      'price': 'Rs. 1500',
      'duration': '45 minutes',
      'image': 'assets/images/hair.jpg',
    },
    {
      'name': 'Hair Styling',
      'description':
      'Beautiful hairstyles for parties, events and special occasions.',
      'price': 'Rs. 2000',
      'duration': '60 minutes',
      'image': 'assets/images/hair_styling.jpg',
    },
    {
      'name': 'Hair Coloring',
      'description':
      'Professional hair coloring and highlights for a stylish look.',
      'price': 'Rs. 5000',
      'duration': '120 minutes',
      'image': 'assets/images/hair2.jpg',
    },
    {
      'name': 'Hair Treatment',
      'description':
      'Nourishing hair treatment to improve hair health and shine.',
      'price': 'Rs. 3000',
      'duration': '60 minutes',
      'image': 'assets/images/hair.jpg',
    },
    {
      'name': 'Hair Straightening',
      'description':
      'Get smooth, sleek and straight hair with professional care.',
      'price': 'Rs. 4000',
      'duration': '120 minutes',
      'image': 'assets/images/hair2.jpg',
    },
    {
      'name': 'Hair Spa',
      'description':
      'Relaxing hair spa with deep conditioning and nourishment.',
      'price': 'Rs. 2500',
      'duration': '60 minutes',
      'image': 'assets/images/hair.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        title: const Text(
          'Hair Services',
          style: TextStyle(
            color: mocha,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: pink,
        foregroundColor: mocha,
        elevation: 0,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];

          return Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      service['image']!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 180,
                          width: double.infinity,
                          color: cream,
                          child: const Icon(
                            Icons.spa_outlined,
                            size: 50,
                            color: mocha,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Service Name
                  Text(
                    service['name']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: mocha,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Description
                  Text(
                    service['description']!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: mocha,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Price and Duration
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        service['price']!,
                        style: const TextStyle(
                          color: mocha,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        service['duration']!,
                        style: const TextStyle(color: mocha),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Select Service
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pink,
                        foregroundColor: mocha,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
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
                      child: const Text('Select Service'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
