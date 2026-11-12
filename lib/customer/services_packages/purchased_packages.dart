
import 'package:flutter/material.dart';
import '../data/app_store.dart';

class PurchasedPackagesScreen extends StatefulWidget {
  const PurchasedPackagesScreen({super.key});

  @override
  State<PurchasedPackagesScreen> createState() =>
      _PurchasedPackagesScreenState();
}

class _PurchasedPackagesScreenState
    extends State<PurchasedPackagesScreen> {

  static const Color cream = Color(0xFFFFF8F0);
  static const Color blushPink = Color(0xFFE8A6B7);
  static const Color mocha = Color(0xFF6F4E37);
  static const Color golden = Color(0xFFD4AF37);

  String selectedFilter = 'All';

  final List<Map<String, dynamic>> purchasedPackages = [
    ...AppStore.purchasedPackages,
    {
      'name': 'Bridal Glow Package',
      'price': 'Rs. 25,000',
      'purchaseDate': '10 Nov 2026',
      'expiryDate': '10 Dec 2026',
      'status': 'Active',
      'remaining': 3,
      'total': 5,
      'image': 'assets/images/bridal1.jpg',
    },
    {
      'name': 'Hair Care Package',
      'price': 'Rs. 8,000',
      'purchaseDate': '20 Oct 2026',
      'expiryDate': '04 Nov 2026',
      'status': 'Expired',
      'remaining': 0,
      'total': 4,
      'image': 'assets/images/hair2.jpg',
    },
    {
      'name': 'Nail Care Package',
      'price': 'Rs. 5,000',
      'purchaseDate': '01 Nov 2026',
      'expiryDate': '16 Nov 2026',
      'status': 'Used',
      'remaining': 0,
      'total': 4,
      'image': 'assets/images/nail3.jpg',
    },
  ];

  List<Map<String, dynamic>> get filteredPackages {
    if (selectedFilter == 'All') {
      return purchasedPackages;
    }

    return purchasedPackages.where((package) {
      return package['status'] == selectedFilter;
    }).toList();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Expired':
        return Colors.red;
      case 'Used':
        return golden;
      default:
        return mocha;
    }
  }

  Widget buildPackageCard(Map<String, dynamic> package) {
    final status = package['status'] as String;
    final remaining = package['remaining'] as int;
    final total = package['total'] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: mocha.withValues(alpha: 0.08),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  package['image'],
                  width: 95,
                  height: 95,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 95,
                      height: 95,
                      color: blushPink.withValues(alpha: 0.25),
                      child: const Icon(
                        Icons.spa,
                        color: mocha,
                        size: 35,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: mocha,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      package['price'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: mocha,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: getStatusColor(status).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: getStatusColor(status),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(height: 25),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Purchase Date',
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
              Text(
                package['purchaseDate'],
                style: const TextStyle(
                  color: mocha,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Expiry Date',
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
              Text(
                package['expiryDate'],
                style: const TextStyle(
                  color: mocha,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Remaining Services',
                style: TextStyle(
                  color: mocha,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$remaining / $total',
                style: const TextStyle(
                  color: mocha,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : remaining / total,
              minHeight: 7,
              backgroundColor: blushPink.withValues(alpha: 0.25),
              color: blushPink,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,

      appBar: AppBar(
        title: const Text(
          'My Packages',
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
            const Text(
              'My Package History',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: mocha,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'View your purchased packages and their details.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 20),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Active', 'Used', 'Expired'].map((filter) {
                  final isSelected = selectedFilter == filter;

                  return Padding(
                    padding: const EdgeInsets.only(right: 9),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      selectedColor: blushPink,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : mocha,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            if (filteredPackages.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 55,
                        color: mocha.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'No packages found.',
                        style: TextStyle(
                          color: mocha,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...filteredPackages.map(buildPackageCard),
          ],
        ),
      ),
    );
  }
}
