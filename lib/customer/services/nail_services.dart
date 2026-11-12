
import 'package:flutter/material.dart';
import 'service_detail.dart';

class NailServices extends StatelessWidget {
  const NailServices({super.key});

  static const Color cream = Color(0xFFFFF8F0);
  static const Color pink = Color(0xFFE8A6B7);
  static const Color mocha = Color(0xFF6F4E37);

  static const List<Map<String, String>> services = [
    {
      'name': 'Basic Manicure',
      'description': 'Nail cleaning, shaping and polish.',
      'price': 'Rs. 1200',
      'duration': '30 minutes',
      'image': 'assets/images/nail_art.jpg',
    },
    {
      'name': 'Basic Pedicure',
      'description': 'Relaxing foot care and nail treatment.',
      'price': 'Rs. 1500',
      'duration': '45 minutes',
      'image': 'assets/images/nail1.jpg',
    },
    {
      'name': 'Nail Art',
      'description': 'Creative and stylish nail art designs.',
      'price': 'Rs. 2000',
      'duration': '60 minutes',
      'image': 'assets/images/nail2.jpg',
    },
    {
      'name': 'Gel Nails',
      'description': 'Long-lasting and glossy gel nail polish.',
      'price': 'Rs. 2500',
      'duration': '60 minutes',
      'image': 'assets/images/nail3.jpg',
    },
    {
      'name': 'Acrylic Nails',
      'description': 'Beautiful acrylic nail extensions.',
      'price': 'Rs. 3500',
      'duration': '90 minutes',
      'image': 'assets/images/nail4.jpg',
    },
    {
      'name': 'Nail Extensions',
      'description': 'Elegant nail extensions and finishing.',
      'price': 'Rs. 3000',
      'duration': '75 minutes',
      'image': 'assets/images/nail5.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        title: const Text(
          'Nail Services',
          style: TextStyle(color: mocha, fontWeight: FontWeight.bold),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      service['image']!,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 160,
                        color: cream,
                        child: const Icon(
                          Icons.brush,
                          size: 50,
                          color: mocha,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    service['name']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: mocha,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(service['description']!),
                  const SizedBox(height: 10),
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
                      Text(service['duration']!),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pink,
                        foregroundColor: mocha,
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
