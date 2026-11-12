import 'package:flutter/material.dart';
 import '../data/app_store.dart';
class AppointmentColors {
  static const Color cream = Color(0xFFFFF8F0);
  static const Color blushPink = Color(0xFFE8A6B7);
  static const Color white = Colors.white;
  static const Color mocha = Color(0xFF6F4E37);
  static const Color golden = Color(0xFFD4AF37);
  static const Color softBeige = Color(0xFFE8DCCB);
}

class MyAppointmentScreen extends StatefulWidget {
  const MyAppointmentScreen({super.key});

  @override
  State<MyAppointmentScreen> createState() =>
      _MyAppointmentScreenState();
}

class _MyAppointmentScreenState
    extends State<MyAppointmentScreen> {

  int selectedTab = 0;

  // Sample appointment data
  final List<Map<String, String>> appointments = [
    ...AppStore.appointments,
    {
      'name': 'Hair Styling',
      'date': '15 November 2026',
      'time': '02:00 PM',
      'price': 'Rs. 1500',
      'status': 'Upcoming',
      'image': 'assets/images/hair_styling.jpg',
    },
    {
      'name': 'Bridal Makeup',
      'date': '18 November 2026',
      'time': '04:00 PM',
      'price': 'Rs. 5000',
      'status': 'Upcoming',
      'image': 'assets/images/makeup.jpg',
    },
    {
      'name': 'Facial Treatment',
      'date': '05 November 2026',
      'time': '01:00 PM',
      'price': 'Rs. 2000',
      'status': 'Completed',
      'image': 'assets/images/facial.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {

    final filteredAppointments = appointments.where((appointment) {
      if (selectedTab == 0) {
        return appointment['status'] == 'Upcoming';
      } else {
        return appointment['status'] == 'Completed';
      }
    }).toList();

    return Scaffold(
      backgroundColor: AppointmentColors.cream,

      appBar: AppBar(
        backgroundColor: AppointmentColors.cream,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Appointments',
          style: TextStyle(
            color: AppointmentColors.mocha,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Heading
            const Text(
              'Your Beauty Schedule',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppointmentColors.mocha,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Manage your salon appointments here.',
              style: TextStyle(
                fontSize: 14,
                color: AppointmentColors.mocha,
              ),
            ),

            const SizedBox(height: 25),

            // Upcoming and Completed Tabs
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppointmentColors.softBeige,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Row(
                children: [

                  Expanded(
                    child: tabButton('Upcoming', 0),
                  ),

                  Expanded(
                    child: tabButton('Completed', 1),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 25),

            // Appointment List
            Expanded(
              child: filteredAppointments.isEmpty
                  ? const Center(
                child: Text(
                  'No appointments found.',
                  style: TextStyle(
                    color: AppointmentColors.mocha,
                    fontSize: 16,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: filteredAppointments.length,

                itemBuilder: (context, index) {
                  return appointmentCard(
                    filteredAppointments[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tab Button
  Widget tabButton(String title, int index) {
    bool isSelected = selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },

      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),

        decoration: BoxDecoration(
          color: isSelected
              ? AppointmentColors.blushPink
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),

        alignment: Alignment.center,

        child: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? AppointmentColors.white
                : AppointmentColors.mocha,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // Appointment Card
  Widget appointmentCard(Map<String, String> appointment) {

    bool isUpcoming = appointment['status'] == 'Upcoming';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),

      decoration: BoxDecoration(
        color: AppointmentColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppointmentColors.mocha.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Service Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),

            child: Image.asset(
              appointment['image']!,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Service Name and Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Expanded(
                      child: Text(
                        appointment['name']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppointmentColors.mocha,
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(
                        color: isUpcoming
                            ? const Color(0xFFEAF5E9)
                            : AppointmentColors.softBeige,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Text(
                        appointment['status']!,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isUpcoming
                              ? Colors.green
                              : AppointmentColors.mocha,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Date
                Text(
                  'Date: ${appointment['date']}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppointmentColors.mocha,
                  ),
                ),

                const SizedBox(height: 7),

                // Time
                Text(
                  'Time: ${appointment['time']}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppointmentColors.mocha,
                  ),
                ),

                const SizedBox(height: 7),

                // Price
                Text(
                  'Price: ${appointment['price']}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppointmentColors.mocha,
                  ),
                ),

                if (isUpcoming) ...[
                  const SizedBox(height: 16),

                  // Cancel Appointment Button
                  SizedBox(
                    width: double.infinity,
                    height: 42,

                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Cancellation feature will be connected later.',
                            ),
                          ),
                        );
                      },

                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(
                          color: Colors.redAccent,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      child: const Text('Cancel Appointment'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
