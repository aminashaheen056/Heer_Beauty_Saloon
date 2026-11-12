
import 'package:flutter/material.dart';
import '../finance/payment.dart';
import '../data/app_store.dart';

class SalonColors {
  static const Color cream = Color(0xFFFFF8F0);
  static const Color blushPink = Color(0xFFE8A6B7);
  static const Color white = Colors.white;
  static const Color mocha = Color(0xFF6F4E37);
  static const Color golden = Color(0xFFD4AF37);
  static const Color softBeige = Color(0xFFE8DCCB);
}

class BookAppointmentScreen extends StatefulWidget {
  // Optional: pre-select a service coming from a service/category screen.
  final String? serviceName;
  final int? price;
  final String? image;

  const BookAppointmentScreen({
    super.key,
    this.serviceName,
    this.price,
    this.image,
  });

  @override
  State<BookAppointmentScreen> createState() =>
      _BookAppointmentScreenState();
}

class _BookAppointmentScreenState
    extends State<BookAppointmentScreen> {

  String? selectedService;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final List<Map<String, dynamic>> services = [
    {
      'name': 'Hair Styling',
      'price': 1500,
      'image': 'assets/images/hair_styling.jpg',
    },
    {
      'name': 'Makeup',
      'price': 2500,
      'image': 'assets/images/makeup.jpg',
    },
    {
      'name': 'Nail Art',
      'price': 1200,
      'image': 'assets/images/nail_art.jpg',
    },
    {
      'name': 'Facial Treatment',
      'price': 2000,
      'image': 'assets/images/facial.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();

    // A service chosen on a previous screen is added and pre-selected.
    final name = widget.serviceName;
    if (name != null) {
      if (!services.any((s) => s['name'] == name)) {
        services.insert(0, {
          'name': name,
          'price': widget.price ?? 0,
          'image': widget.image ?? 'assets/images/salon.jpg',
        });
      }
      selectedService = name;
    }
  }

  String get selectedImage {
    if (selectedService == null) return 'assets/images/saloon-banner.png';
    return services.firstWhere(
          (service) => service['name'] == selectedService,
    )['image'] as String;
  }

  int get selectedPrice {
    if (selectedService == null) return 0;

    return services.firstWhere(
          (service) => service['name'] == selectedService,
    )['price'] as int;
  }

  Future<void> pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(
        const Duration(days: 1),
      ),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 90),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: SalonColors.blushPink,
              onPrimary: SalonColors.white,
              onSurface: SalonColors.mocha,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  void continueToPayment() {
    if (selectedService == null ||
        selectedDate == null ||
        selectedTime == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select service, date and time.',
          ),
        ),
      );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          serviceName: selectedService!,
          appointmentDate: selectedDate!,
          appointmentTime: selectedTime!,
          amount: selectedPrice,
          image: selectedImage,
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
      backgroundColor: SalonColors.cream,

      appBar: AppBar(
        title: const Text(
          'Book Appointment',
          style: TextStyle(
            color: SalonColors.mocha,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: SalonColors.cream,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: SalonColors.mocha,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Booking Banner Image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                selectedImage,
                height: 190,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Book Your Beauty Session',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: SalonColors.mocha,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Select your preferred service, date and time.',
              style: TextStyle(
                color: SalonColors.mocha,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 25),

            // Select Service
            const Text(
              'Select Service',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: SalonColors.mocha,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: selectedService,
              decoration: InputDecoration(
                hintText: 'Choose a service',
                filled: true,
                fillColor: SalonColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: SalonColors.softBeige,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: SalonColors.softBeige,
                  ),
                ),
              ),

              items: services.map((service) {
                return DropdownMenuItem<String>(
                  value: service['name'],
                  child: Text(
                    service['name'] as String,
                  ),
                );
              }).toList(),

              onChanged: (value) {
                setState(() {
                  selectedService = value;
                });
              },
            ),

            const SizedBox(height: 20),

            // Service Price
            if (selectedService != null)
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: SalonColors.softBeige.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Service Price',
                      style: TextStyle(
                        color: SalonColors.mocha,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Text(
                      'Rs. $selectedPrice',
                      style: const TextStyle(
                        color: SalonColors.mocha,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 25),

            // Appointment Date
            const Text(
              'Appointment Date',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: SalonColors.mocha,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 10),

            InkWell(
              onTap: pickDate,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: SalonColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: SalonColors.softBeige,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate == null
                          ? 'Select appointment date'
                          : formatDate(selectedDate!),
                      style: const TextStyle(
                        color: SalonColors.mocha,
                      ),
                    ),

                    const Icon(
                      Icons.calendar_month,
                      color: SalonColors.golden,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Appointment Time
            const Text(
              'Appointment Time',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: SalonColors.mocha,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 10),

            InkWell(
              onTap: pickTime,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: SalonColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: SalonColors.softBeige,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedTime == null
                          ? 'Select appointment time'
                          : selectedTime!.format(context),
                      style: const TextStyle(
                        color: SalonColors.mocha,
                      ),
                    ),

                    const Icon(
                      Icons.access_time,
                      color: SalonColors.golden,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 35),

            // Continue Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: continueToPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: SalonColors.blushPink,
                  foregroundColor: SalonColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue to Payment',
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
}
