
import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> service;
  final DateTime bookingDate;
  final TimeOfDay bookingTime;
  final String bookingId;

  const BookingConfirmationScreen({
    super.key,
    required this.service,
    required this.bookingDate,
    required this.bookingTime,
    required this.bookingId,
  });

  static const Color cream = Color(0xFFFFF8F0);
  static const Color blushPink = Color(0xFFE8A6B7);
  static const Color mocha = Color(0xFF6F4E37);
  static const Color golden = Color(0xFFD4AF37);
  static const Color softBeige = Color(0xFFE8DCCB);

  // Format selected date
  String formatDate() {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${bookingDate.day} '
        '${months[bookingDate.month - 1]} '
        '${bookingDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    final String serviceName = service['name']?.toString() ?? 'Beauty Service';
    final String servicePrice = service['price']?.toString() ?? '0';
    final String serviceImage = service['image']?.toString() ?? '';

    final String formattedTime = bookingTime.format(context);

    return Scaffold(
      backgroundColor: cream,

      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Booking Confirmation',
          style: TextStyle(
            color: mocha,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),

          child: Column(
            children: [
              const SizedBox(height: 15),

              // Success Image
              Container(
                width: 115,
                height: 115,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.check_circle,
                        size: 85,
                        color: Colors.green,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Confirmation Message
              const Text(
                'Booking Confirmed!',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: mocha,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Your appointment has been successfully booked.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: mocha,
                ),
              ),

              const SizedBox(height: 30),

              // Booking Details Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: softBeige,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: mocha.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Appointment Details',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: mocha,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Selected Service Image and Name
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: serviceImage.isNotEmpty
                              ? Image.network(
                            serviceImage,
                            width: 90,
                            height: 85,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) {
                              return serviceImagePlaceholder();
                            },
                          )
                              : serviceImagePlaceholder(),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                serviceName,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: mocha,
                                ),
                              ),

                              const SizedBox(height: 6),

                              const Text(
                                'HEER Beauty Salon',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: mocha,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                'Rs. $servicePrice',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: golden,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    const Divider(color: softBeige),

                    const SizedBox(height: 15),

                    // Booking Information
                    BookingDetailRow(
                      title: 'Booking ID',
                      value: bookingId,
                    ),

                    const SizedBox(height: 15),

                    BookingDetailRow(
                      title: 'Date',
                      value: formatDate(),
                    ),

                    const SizedBox(height: 15),

                    BookingDetailRow(
                      title: 'Time',
                      value: formattedTime,
                    ),

                    const SizedBox(height: 15),

                    const BookingDetailRow(
                      title: 'Status',
                      value: 'Confirmed',
                      valueColor: Colors.green,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Back to Home Button
              SizedBox(
                width: double.infinity,
                height: 52,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                          (route) => false,
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: blushPink,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  child: const Text(
                    'Back to Home',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Thank you for choosing HEER Beauty Salon!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: mocha,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Placeholder for unavailable service image
  Widget serviceImagePlaceholder() {
    return Container(
      width: 90,
      height: 85,
      color: softBeige,
      child: const Icon(
        Icons.spa_outlined,
        size: 35,
        color: mocha,
      ),
    );
  }
}

// Reusable Booking Detail Row
class BookingDetailRow extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;

  const BookingDetailRow({
    super.key,
    required this.title,
    required this.value,
    this.valueColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),

        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}
