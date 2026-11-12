
import 'package:flutter/material.dart';
import '../data/app_store.dart';
import 'purchased_packages.dart';

class PackageDetailsBookingScreen extends StatelessWidget {
  final String packageName;
  final String description;
  final String price;
  final String validity;
  final String image;
  final List<String> includedServices;

  const PackageDetailsBookingScreen({
    super.key,
    required this.packageName,
    required this.description,
    required this.price,
    required this.validity,
    required this.image,
    required this.includedServices,
  });

  static const Color cream = Color(0xFFFFF8F0);
  static const Color blushPink = Color(0xFFE8A6B7);
  static const Color mocha = Color(0xFF6F4E37);
  static const Color golden = Color(0xFFD4AF37);

  void bookPackage(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cream,
          title: const Text(
            'Confirm Package',
            style: TextStyle(
              color: mocha,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Do you want to continue with $packageName?',
            style: const TextStyle(color: mocha),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancel',
                style: TextStyle(color: mocha),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                AppStore.addPackage(
                  name: packageName,
                  price: price,
                  validity: validity,
                  image: image,
                  totalServices: includedServices.length,
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PurchasedPackagesScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: blushPink,
                foregroundColor: Colors.white,
              ),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        title: const Text(
          'Package Details',
          style: TextStyle(
            color: mocha,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: cream,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: mocha),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                image,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 220,
                    width: double.infinity,
                    color: blushPink.withValues(alpha: 0.25),
                    child: const Icon(
                      Icons.spa,
                      size: 60,
                      color: mocha,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Text(
              packageName,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: mocha,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Package Price',
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: mocha,
                        ),
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Validity',
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        validity,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: mocha,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Included Services',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: mocha,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: includedServices.map((service) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: golden,
                          size: 19,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            service,
                            style: const TextStyle(
                              fontSize: 15,
                              color: mocha,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => bookPackage(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: blushPink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Book This Package',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
