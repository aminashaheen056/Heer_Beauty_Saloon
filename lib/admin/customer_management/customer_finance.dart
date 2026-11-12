import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';

class CustomerFinanceScreen extends StatelessWidget {
  final AdminCustomer customer;

  const CustomerFinanceScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final txns = AdminStore.transactionsOfCustomer(customer.id)
      ..sort((a, b) => b.date.compareTo(a.date));
    final paid = AdminStore.sum(txns.where((t) => t.status == 'Paid'));
    final pending = AdminStore.sum(txns.where((t) => t.status == 'Pending'));
    final refunded = AdminStore.sum(txns.where((t) => t.status == 'Refunded'));
    final packages = AdminStore.packagesOfCustomer(customer.id);

    return Scaffold(
      backgroundColor: AdminColors.cream,
      appBar: AdminUi.appBar('Customer Finance'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            customer.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AdminColors.mocha,
            ),
          ),
          const SizedBox(height: 12),
          AdminUi.statRow(
            AdminUi.statCard(
                icon: Icons.check_circle_outline,
                label: 'Total paid',
                value: AdminStore.money(paid),
                color: AdminColors.green),
            AdminUi.statCard(
                icon: Icons.hourglass_bottom,
                label: 'Outstanding',
                value: AdminStore.money(pending),
                color: AdminColors.orange),
          ),
          AdminUi.statRow(
            AdminUi.statCard(
                icon: Icons.assignment_return_outlined,
                label: 'Refunded',
                value: AdminStore.money(refunded),
                color: AdminColors.golden),
            AdminUi.statCard(
                icon: Icons.card_giftcard,
                label: 'Packages bought',
                value: '${packages.length}',
                color: AdminColors.blue),
          ),
          AdminUi.sectionTitle('Transactions'),
          if (txns.isEmpty)
            AdminUi.emptyState('No transactions for this customer',
                icon: Icons.receipt_long_outlined)
          else
            ...txns.map(
                  (t) => AdminUi.card(
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AdminColors.softBeige,
                      child: Icon(Icons.receipt_long, color: AdminColors.mocha),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.service,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AdminColors.mocha)),
                          Text('${AdminStore.shortDate(t.date)}  •  ${t.method}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color:
                                  AdminColors.mocha.withValues(alpha: 0.75))),
                          Text(t.id,
                              style: TextStyle(
                                  fontSize: 11,
                                  color:
                                  AdminColors.mocha.withValues(alpha: 0.5))),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(AdminStore.money(t.amount),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AdminColors.mocha)),
                        const SizedBox(height: 4),
                        AdminUi.statusChip(t.status),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
