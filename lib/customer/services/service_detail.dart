
import 'package:flutter/material.dart';
import 'package:heer_beauty_saloon/customer/appointment/book_appointment.dart';
import 'package:heer_beauty_saloon/customer/data/app_store.dart';

class ServiceDetailScreen extends StatelessWidget {
  final String serviceName;
  final String description;
  final String price;
  final String duration;
  final String image;

  const ServiceDetailScreen({
    super.key,
    required this.serviceName,
    required this.description,
    required this.price,
    required this.duration,
    required this.image,
  });

  static const Color cream = Color(0xFFFFF8F0);
  static const Color pink = Color(0xFFE8A6B7);
  static const Color mocha = Color(0xFF6F4E37);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,

      appBar: AppBar(
        title: const Text(
          'Service Details',
          style: TextStyle(
            color: mocha,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: pink,
        foregroundColor: mocha,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                image,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 250,
                    width: double.infinity,
                    color: Colors.white,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      size: 50,
                      color: mocha,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Service Name
            Text(
              serviceName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: mocha,
              ),
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            // Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Price',
                  style: TextStyle(
                    fontSize: 16,
                    color: mocha,
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: mocha,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Duration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Duration',
                  style: TextStyle(
                    fontSize: 16,
                    color: mocha,
                  ),
                ),
                Text(
                  duration,
                  style: const TextStyle(
                    fontSize: 16,
                    color: mocha,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Book Appointment Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: pink,
                  foregroundColor: mocha,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookAppointmentScreen(
                        serviceName: serviceName,
                        price: AppStore.parsePrice(price),
                        image: image,
                      ),
                    ),
                  );
                },

                child: const Text(
                  'Book Appointment',
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
    );
  }
}
