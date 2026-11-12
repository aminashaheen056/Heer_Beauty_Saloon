
import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class ReceiptColors {
  static const Color cream = Color(0xFFFFF8F0);
  static const Color blushPink = Color(0xFFE8A6B7);
  static const Color white = Colors.white;
  static const Color mocha = Color(0xFF6F4E37);
  static const Color golden = Color(0xFFD4AF37);
  static const Color softBeige = Color(0xFFE8DCCB);
}

class PaymentReceiptScreen extends StatelessWidget {
  final String serviceName;
  final DateTime appointmentDate;
  final TimeOfDay appointmentTime;
  final int amount;
  final String paymentMethod;
  final String receiptNumber;

  const PaymentReceiptScreen({
    super.key,
    required this.serviceName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.amount,
    required this.paymentMethod,
    required this.receiptNumber,
  });

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final bool payAtSalon = paymentMethod == 'Cash at Salon';

    return Scaffold(
      backgroundColor: ReceiptColors.cream,

      appBar: AppBar(
        title: const Text(
          'Payment Receipt',
          style: TextStyle(
            color: ReceiptColors.mocha,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: ReceiptColors.cream,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            const SizedBox(height: 15),

            // Receipt Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),

              decoration: BoxDecoration(
                color: ReceiptColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: ReceiptColors.softBeige,
                ),
              ),

              child: Column(
                children: [

                  // Optional Salon Logo
                  Image.asset(
                    'assets/images/logo.png',
                    height: 90,
                    width: 120,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Booking Receipt',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: ReceiptColors.mocha,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Thank you for choosing HEER Beauty Salon!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ReceiptColors.mocha,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Divider(
                    color: ReceiptColors.softBeige,
                  ),

                  const SizedBox(height: 15),

                  receiptRow(
                    'Receipt Number',
                    receiptNumber,
                  ),

                  const SizedBox(height: 15),

                  receiptRow(
                    'Service',
                    serviceName,
                  ),

                  const SizedBox(height: 15),

                  receiptRow(
                    'Appointment Date',
                    formatDate(appointmentDate),
                  ),

                  const SizedBox(height: 15),

                  receiptRow(
                    'Appointment Time',
                    appointmentTime.format(context),
                  ),

                  const SizedBox(height: 15),

                  receiptRow(
                    'Payment Method',
                    paymentMethod,
                  ),

                  const SizedBox(height: 15),

                  const Divider(
                    color: ReceiptColors.softBeige,
                  ),

                  const SizedBox(height: 15),

                  receiptRow(
                    'Total Amount',
                    'Rs. $amount',
                    isTotal: true,
                  ),

                  const SizedBox(height: 20),

                  // Payment Status
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(13),

                    decoration: BoxDecoration(
                      color: ReceiptColors.softBeige.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: Column(
                      children: [

                        Text(
                          payAtSalon
                              ? 'PAYMENT STATUS'
                              : 'TRANSACTION STATUS',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ReceiptColors.mocha,
                          ),
                        ),

                        const SizedBox(height: 7),

                        Text(
                          payAtSalon
                              ? 'Payment Due at Salon'
                              : 'Demo Booking - Payment Not Processed',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: ReceiptColors.mocha,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'Your beauty journey starts here!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ReceiptColors.mocha,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Done Button
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
                  backgroundColor: ReceiptColors.blushPink,
                  foregroundColor: ReceiptColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: const Text(
                  'Done',
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

  Widget receiptRow(
      String title,
      String value, {
        bool isTotal = false,
      }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: ReceiptColors.mocha,
              fontWeight: isTotal
                  ? FontWeight.bold
                  : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ),

        const SizedBox(width: 10),

        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: ReceiptColors.mocha,
              fontWeight: FontWeight.bold,
              fontSize: isTotal ? 18 : 14,
            ),
          ),
        ),
      ],
    );
  }
}
