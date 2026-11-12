import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';

class AllTransactionsScreen extends StatefulWidget {
  const AllTransactionsScreen({super.key});

  @override
  State<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  static const filters = ['All', 'Paid', 'Pending', 'Refunded', 'Failed'];

  String _filter = 'All';
  String _query = '';

  void _showDetails(AdminTransaction t) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AdminColors.cream,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text('Transaction Details',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AdminColors.mocha)),
                  ),
                  AdminUi.statusChip(t.status),
                ],
              ),
              const SizedBox(height: 10),
              AdminUi.infoRow(Icons.tag, 'Receipt', t.id),
              AdminUi.infoRow(Icons.person_outline, 'Customer', t.customerName),
              AdminUi.infoRow(Icons.spa_outlined, 'For', t.service),
              AdminUi.infoRow(Icons.calendar_today, 'Date', AdminStore.date(t.date)),
              AdminUi.infoRow(Icons.credit_card, 'Method', t.method),
              AdminUi.infoRow(
                  Icons.payments_outlined, 'Amount', AdminStore.money(t.amount)),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final all = AdminStore.transactions;
    final q = _query.toLowerCase();

    final list = all.where((t) {
      final matchesFilter = _filter == 'All' || t.status == _filter;
      final matchesQuery = q.isEmpty ||
          t.customerName.toLowerCase().contains(q) ||
          t.service.toLowerCase().contains(q) ||
          t.id.toLowerCase().contains(q);
      return matchesFilter && matchesQuery;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    final total = AdminStore.sum(list);

    return Scaffold(
      backgroundColor: AdminColors.cream,
      appBar: AdminUi.appBar('All Transactions'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: [
                AdminUi.searchBar('Search receipt, customer or service',
                        (v) => setState(() => _query = v)),
                const SizedBox(height: 10),
                AdminUi.filterChips(
                    filters, _filter, (v) => setState(() => _filter = v)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
            child: Row(
              children: [
                Text('${list.length} transaction(s)',
                    style: TextStyle(
                        fontSize: 12.5,
                        color: AdminColors.mocha.withValues(alpha: 0.7))),
                const Spacer(),
                Text('Total ${AdminStore.money(total)}',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AdminColors.mocha)),
              ],
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? AdminUi.emptyState('No transactions found',
                icon: Icons.receipt_long_outlined)
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final t = list[i];
                return AdminUi.card(
                  onTap: () => _showDetails(t),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: AdminColors.softBeige,
                        child: Icon(Icons.receipt_long,
                            color: AdminColors.mocha),
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
                            Text(t.customerName,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: AdminColors.mocha)),
                            Text(
                                '${AdminStore.shortDate(t.date)}  •  ${t.method}',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AdminColors.mocha
                                        .withValues(alpha: 0.7))),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
