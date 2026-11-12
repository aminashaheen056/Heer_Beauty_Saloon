
import 'package:flutter/material.dart';
import '../appointment/book_appointment.dart';
import '../data/app_store.dart';

class MakeupServices extends StatelessWidget {
  const MakeupServices({super.key});

  static const Color cream = Color(0xFFFFF8F0);
  static const Color pink = Color(0xFFE8A6B7);
  static const Color mocha = Color(0xFF6F4E37);

  static const List<Map<String, String>> services = [
    {
      'name': 'Party Makeup',
      'description': 'Elegant makeup for parties and events.',
      'price': 'Rs. 3500',
      'duration': '60 minutes',
      'image': 'assets/images/party_makup.jpg',
    },
    {
      'name': 'Bridal Makeup',
      'description': 'Complete bridal makeup for your special day.',
      'price': 'Rs. 15000',
      'duration': '180 minutes',
      'image': 'assets/images/bride.jpg',
    },
    {
      'name': 'Engagement Makeup',
      'description': 'Beautiful makeup for engagement events.',
      'price': 'Rs. 8000',
      'duration': '120 minutes',
      'image': 'assets/images/bridal1.jpg',
    },
    {
      'name': 'Natural Makeup',
      'description': 'Soft and natural everyday makeup look.',
      'price': 'Rs. 2500',
      'duration': '45 minutes',
      'image': 'assets/images/makeup.jpg',
    },
    {
      'name': 'Eye Makeup',
      'description': 'Professional eye makeup and styling.',
      'price': 'Rs. 1500',
      'duration': '30 minutes',
      'image': 'assets/images/party1.jpg',
    },
    {
      'name': 'Reception Makeup',
      'description': 'Glamorous makeup for reception events.',
      'price': 'Rs. 10000',
      'duration': '120 minutes',
      'image': 'assets/images/bridal3.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        title: const Text(
          'Makeup Services',
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
            margin: const EdgeInsets.only(bottom: 18),
            elevation: 3,
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
                      height: 190,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 190,
                          width: double.infinity,
                          color: cream,
                          child: const Icon(
                            Icons.image_not_supported_outlined,
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
                      color: Colors.black87,
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
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        service['duration']!,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Select Service Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pink,
                        foregroundColor: mocha,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookAppointmentScreen(
                              serviceName: service['name']!,
                              price: AppStore.parsePrice(service['price']!),
                              image: service['image']!,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Select Service',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
