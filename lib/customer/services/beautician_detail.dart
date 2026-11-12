
import 'package:flutter/material.dart';
import '../appointment/book_appointment.dart';

class BeauticianDetailScreen extends StatelessWidget {
  final String name;
  final String image;
  final String experience;
  final String specialization;
  final String rating;
  final String description;

  const BeauticianDetailScreen({
    super.key,
    required this.name,
    required this.image,
    required this.experience,
    required this.specialization,
    required this.rating,
    required this.description,
  });

  static const Color cream = Color(0xFFFFF8F0);
  static const Color blushPink = Color(0xFFE8A6B7);
  static const Color mocha = Color(0xFF6F4E37);
  static const Color golden = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        title: const Text(
          'Beautician Details',
          style: TextStyle(
            color: mocha,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: cream,
        elevation: 0,
        iconTheme: const IconThemeData(color: mocha),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Beautician Image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  image,
                  height: 230,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 230,
                      width: double.infinity,
                      color: blushPink.withValues(alpha: 0.3),
                      child: const Icon(
                        Icons.person,
                        size: 100,
                        color: mocha,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Name and Rating
            Text(
              name,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: mocha,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.star, color: golden, size: 20),
                const SizedBox(width: 5),
                Text(
                  rating,
                  style: const TextStyle(
                    fontSize: 15,
                    color: mocha,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Experience
            _detailCard(
              icon: Icons.work_outline,
              title: 'Experience',
              value: experience,
            ),

            const SizedBox(height: 12),

            // Specialization
            _detailCard(
              icon: Icons.spa_outlined,
              title: 'Specialization',
              value: specialization,
            ),

            const SizedBox(height: 22),

            const Text(
              'About Beautician',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: mocha,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 25),

            // Availability
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 10),
                  Text(
                    'Available for Appointments',
                    style: TextStyle(
                      color: mocha,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Book Appointment Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookAppointmentScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: blushPink,
                  foregroundColor: mocha,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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

  Widget _detailCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: blushPink, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: mocha,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
