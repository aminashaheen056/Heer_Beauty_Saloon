
import 'package:flutter/material.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final String serviceName;
  final String price;
  final String imagePath;

  const AppointmentDetailScreen({
    super.key,
    this.serviceName = 'Hair Styling',
    this.price = 'Rs. 1500',
    this.imagePath = 'assets/images/hair_styling.jpg',
  });

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState
    extends State<AppointmentDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController =
  TextEditingController();

  final TextEditingController phoneController =
  TextEditingController();

  final TextEditingController notesController =
  TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // App colors
  static const Color cream = Color(0xFFFFF8F0);
  static const Color blushPink = Color(0xFFE8A6B7);
  static const Color mocha = Color(0xFF6F4E37);
  static const Color golden = Color(0xFFD4AF37);
  static const Color softBeige = Color(0xFFE8DCCB);

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    notesController.dispose();
    super.dispose();
  }

  // Select appointment date
  Future<void> pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: blushPink,
              onPrimary: Colors.white,
              onSurface: mocha,
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

  // Select appointment time
  Future<void> pickTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: blushPink,
              onPrimary: Colors.white,
              onSurface: mocha,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Confirm appointment
  void confirmAppointment() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select appointment date and time.'),
          backgroundColor: mocha,
        ),
      );
      return;
    }

    // Demo confirmation only; no booking is saved to a database.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Appointment details submitted successfully!'),
        backgroundColor: mocha,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,

      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: mocha),
        title: const Text(
          'Appointment Details',
          style: TextStyle(
            color: mocha,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Selected service image
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  widget.imagePath,
                  width: double.infinity,
                  height: 190,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 190,
                      width: double.infinity,
                      color: softBeige,
                      alignment: Alignment.center,
                      child: const Text(
                        'Service Image',
                        style: TextStyle(
                          color: mocha,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Service details
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: softBeige),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selected Service',
                      style: TextStyle(
                        color: mocha,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      widget.serviceName,
                      style: const TextStyle(
                        color: mocha,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      widget.price,
                      style: const TextStyle(
                        color: golden,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Choose Appointment Date',
                style: TextStyle(
                  color: mocha,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // Date picker
              InkWell(
                onTap: pickDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: softBeige),
                  ),
                  child: Text(
                    selectedDate == null
                        ? 'Select appointment date'
                        : formatDate(selectedDate!),
                    style: TextStyle(
                      color: selectedDate == null
                          ? Colors.grey
                          : mocha,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Choose Appointment Time',
                style: TextStyle(
                  color: mocha,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // Time picker
              InkWell(
                onTap: pickTime,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: softBeige),
                  ),
                  child: Text(
                    selectedTime == null
                        ? 'Select appointment time'
                        : selectedTime!.format(context),
                    style: TextStyle(
                      color: selectedTime == null
                          ? Colors.grey
                          : mocha,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Customer Information',
                style: TextStyle(
                  color: mocha,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // Customer name
              const Text(
                'Full Name',
                style: TextStyle(
                  color: mocha,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: nameController,
                decoration: inputDecoration('Enter your full name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Phone number
              const Text(
                'Phone Number',
                style: TextStyle(
                  color: mocha,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: inputDecoration('Enter your phone number'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your phone number';
                  }

                  if (!RegExp(r'^\d{11}$').hasMatch(value.trim())) {
                    return 'Enter an 11-digit phone number';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Additional notes
              const Text(
                'Additional Notes (Optional)',
                style: TextStyle(
                  color: mocha,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: notesController,
                maxLines: 3,
                decoration: inputDecoration(
                  'Any special instructions?',
                ),
              ),

              const SizedBox(height: 30),

              // Confirm button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: confirmAppointment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blushPink,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Confirm Appointment',
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
      ),
    );
  }

  // Common text field styling
  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: softBeige),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: softBeige),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: blushPink,
          width: 1.5,
        ),
      ),
    );
  }
}
