
import 'package:flutter/material.dart';
import '../data/app_store.dart';

class TransactionColors {
  static const Color cream = Color(0xFFFFF8F0);
  static const Color blushPink = Color(0xFFE8A6B7);
  static const Color white = Colors.white;
  static const Color mocha = Color(0xFF6F4E37);
  static const Color golden = Color(0xFFD4AF37);
  static const Color softBeige = Color(0xFFE8DCCB);
}

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState
    extends State<TransactionHistoryScreen> {

  String selectedFilter = 'All';

  // Sample transaction data
  final List<Map<String, dynamic>> transactions = [
    ...AppStore.transactions,
    {
      'id': 'HEER-1001',
      'service': 'Hair Styling',
      'date': '10/11/2026',
      'method': 'JazzCash',
      'amount': 1500,
      'status': 'Paid',
    },
    {
      'id': 'HEER-1002',
      'service': 'Makeup',
      'date': '08/11/2026',
      'method': 'Cash at Salon',
      'amount': 2500,
      'status': 'Pending',
    },
    {
      'id': 'HEER-1003',
      'service': 'Nail Art',
      'date': '05/11/2026',
      'method': 'EasyPaisa',
      'amount': 1200,
      'status': 'Paid',
    },
    {
      'id': 'HEER-1004',
      'service': 'Facial Treatment',
      'date': '02/11/2026',
      'method': 'Debit/Credit Card',
      'amount': 2000,
      'status': 'Failed',
    },
  ];

  List<Map<String, dynamic>> get filteredTransactions {
    if (selectedFilter == 'All') {
      return transactions;
    }

    return transactions.where((transaction) {
      return transaction['status'] == selectedFilter;
    }).toList();
  }

  int get totalPaid {
    return transactions
        .where((t) => t['status'] == 'Paid')
        .fold(0, (sum, t) => sum + (t['amount'] as int));
  }

  int get totalTransactions => transactions.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TransactionColors.cream,

      appBar: AppBar(
        title: const Text(
          'Transaction History',
          style: TextStyle(
            color: TransactionColors.mocha,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: TransactionColors.cream,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: TransactionColors.mocha,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Summary Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: TransactionColors.mocha,
                borderRadius: BorderRadius.circular(15),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    'Total Amount Paid',
                    style: TextStyle(
                      color: TransactionColors.white,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Rs. $totalPaid',
                    style: const TextStyle(
                      color: TransactionColors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [

                      const Text(
                        'Total Transactions',
                        style: TextStyle(
                          color: TransactionColors.white,
                        ),
                      ),

                      Text(
                        '$totalTransactions',
                        style: const TextStyle(
                          color: TransactionColors.golden,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Your Transactions',
              style: TextStyle(
                color: TransactionColors.mocha,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // Filter Buttons
            Wrap(
              spacing: 8,
              children: ['All', 'Paid', 'Pending', 'Failed']
                  .map((filter) {

                final isSelected = selectedFilter == filter;

                return ChoiceChip(
                  label: Text(filter),
                  selected: isSelected,
                  selectedColor: TransactionColors.blushPink,
                  backgroundColor: TransactionColors.white,
                  labelStyle: TextStyle(
                    color: TransactionColors.mocha,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      selectedFilter = filter;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Transaction List
            if (filteredTransactions.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    'No transactions found.',
                    style: TextStyle(
                      color: TransactionColors.mocha,
                    ),
                  ),
                ),
              )
            else
              ...filteredTransactions.map((transaction) {

                final status = transaction['status'];

                Color statusColor;

                if (status == 'Paid') {
                  statusColor = Colors.green;
                } else if (status == 'Pending') {
                  statusColor = TransactionColors.golden;
                } else {
                  statusColor = Colors.red;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: TransactionColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: TransactionColors.softBeige,
                    ),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [

                          Expanded(
                            child: Text(
                              transaction['service'],
                              style: const TextStyle(
                                color: TransactionColors.mocha,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Text(
                            'Rs. ${transaction['amount']}',
                            style: const TextStyle(
                              color: TransactionColors.mocha,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'Transaction ID: ${transaction['id']}',
                        style: const TextStyle(
                          color: TransactionColors.mocha,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Date: ${transaction['date']}',
                        style: const TextStyle(
                          color: TransactionColors.mocha,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Payment Method: ${transaction['method']}',
                        style: const TextStyle(
                          color: TransactionColors.mocha,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [

                          const Text(
                            'Payment Status',
                            style: TextStyle(
                              color: TransactionColors.mocha,
                              fontSize: 13,
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 6,
                            ),

                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: Text(
                              status,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
