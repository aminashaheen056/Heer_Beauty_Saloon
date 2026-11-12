
import 'package:flutter/material.dart';
import 'payment_reciept.dart';
import '../data/app_store.dart';

class PaymentColors {
  static const Color cream = Color(0xFFFFF8F0);
  static const Color blushPink = Color(0xFFE8A6B7);
  static const Color white = Colors.white;
  static const Color mocha = Color(0xFF6F4E37);
  static const Color golden = Color(0xFFD4AF37);
  static const Color softBeige = Color(0xFFE8DCCB);
}

class PaymentScreen extends StatefulWidget {
  final String serviceName;
  final DateTime appointmentDate;
  final TimeOfDay appointmentTime;
  final int amount;
  final String image;

  const PaymentScreen({
    super.key,
    required this.serviceName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.amount,
    this.image = 'assets/images/salon.jpg',
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  String selectedPayment = 'Cash at Salon';

  // Available payment methods
  final List<Map<String, String>> paymentMethods = [
    {
      'name': 'Cash ',
      'image': 'assets/images/cash.jpg',
    },
    {
      'name': 'JazzCash',
      'image': 'assets/images/jazzcash.jpg',
    },
    {
      'name': 'EasyPaisa',
      'image': 'assets/images/easypaisa.jpg',
    },
    {
      'name': 'Debit/Credit Card',
      'image': 'assets/images/card.jpg',
    },
  ];

  void confirmPayment() {
    final receiptNumber = 'HEER-${DateTime.now().millisecondsSinceEpoch}';

    // Save the booking so it appears in My Appointments and Payment History.
    AppStore.addBooking(
      serviceName: widget.serviceName,
      date: widget.appointmentDate,
      time: widget.appointmentTime.format(context),
      amount: widget.amount,
      paymentMethod: selectedPayment,
      receiptNumber: receiptNumber,
      image: widget.image,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentReceiptScreen(
          serviceName: widget.serviceName,
          appointmentDate: widget.appointmentDate,
          appointmentTime: widget.appointmentTime,
          amount: widget.amount,
          paymentMethod: selectedPayment,
          receiptNumber: receiptNumber,
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PaymentColors.cream,

      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(
            color: PaymentColors.mocha,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: PaymentColors.cream,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: PaymentColors.mocha,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Payment Banner Image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/images/salon.png',
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 25),

            // Page Heading
            const Text(
              'Booking Summary',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: PaymentColors.mocha,
              ),
            ),

            const SizedBox(height: 15),

            // Booking Details
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: PaymentColors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: PaymentColors.softBeige,
                ),
              ),

              child: Column(
                children: [

                  detailRow(
                    'Service',
                    widget.serviceName,
                  ),

                  const SizedBox(height: 15),

                  detailRow(
                    'Appointment Date',
                    formatDate(widget.appointmentDate),
                  ),

                  const SizedBox(height: 15),

                  detailRow(
                    'Appointment Time',
                    widget.appointmentTime.format(context),
                  ),

                  const Divider(
                    height: 30,
                    color: PaymentColors.softBeige,
                  ),

                  detailRow(
                    'Total Amount',
                    'Rs. ${widget.amount}',
                    isTotal: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Payment Method Heading
            const Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: PaymentColors.mocha,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Choose your preferred payment method.',
              style: TextStyle(
                fontSize: 13,
                color: PaymentColors.mocha,
              ),
            ),

            const SizedBox(height: 18),

            // Payment Methods
            ...paymentMethods.map((method) {

              final isSelected =
                  selectedPayment == method['name'];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedPayment = method['name']!;
                  });
                },

                child: Container(
                  margin: const EdgeInsets.only(bottom: 13),
                  padding: const EdgeInsets.all(14),

                  decoration: BoxDecoration(
                    color: PaymentColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? PaymentColors.blushPink
                          : PaymentColors.softBeige,
                      width: isSelected ? 2 : 1,
                    ),
                  ),

                  child: Row(
                    children: [

                      // Payment Method Image
                      Image.asset(
                        method['image']!,
                        width: 48,
                        height: 38,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Text(
                          method['name']!,
                          style: const TextStyle(
                            color: PaymentColors.mocha,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      Radio<String>(
                        value: method['name']!,
                        groupValue: selectedPayment,
                        activeColor: PaymentColors.blushPink,
                        onChanged: (value) {
                          setState(() {
                            selectedPayment = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            // Amount Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: PaymentColors.softBeige.withOpacity(0.45),
                borderRadius: BorderRadius.circular(12),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Text(
                    'Amount to Pay',
                    style: TextStyle(
                      color: PaymentColors.mocha,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  Text(
                    'Rs. ${widget.amount}',
                    style: const TextStyle(
                      color: PaymentColors.mocha,
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Confirm Payment Button
            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton(
                onPressed: confirmPayment,

                style: ElevatedButton.styleFrom(
                  backgroundColor: PaymentColors.blushPink,
                  foregroundColor: PaymentColors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: const Text(
                  'Confirm Payment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Booking Details Row
  Widget detailRow(
      String title,
      String value, {
        bool isTotal = false,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: PaymentColors.mocha,
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),

        const SizedBox(width: 10),

        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: PaymentColors.mocha,
              fontSize: isTotal ? 18 : 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
