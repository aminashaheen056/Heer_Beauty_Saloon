import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';

class ManagePaymentsScreen extends StatefulWidget {
  const ManagePaymentsScreen({super.key});

  @override
  State<ManagePaymentsScreen> createState() => _ManagePaymentsScreenState();
}

class _ManagePaymentsScreenState extends State<ManagePaymentsScreen> {
  Future<void> _markPaid(AdminTransaction t) async {
    final ok = await AdminUi.confirm(
      context,
      title: 'Mark as paid?',
      message:
      'Confirm that ${AdminStore.money(t.amount)} was received from ${t.customerName} for ${t.service}.',
      confirmText: 'Mark paid',
    );
    if (!ok) return;
    setState(() => t.status = 'Paid');
    if (mounted) AdminUi.snack(context, 'Payment ${t.id} marked as paid');
  }

  Future<void> _markFailed(AdminTransaction t) async {
    final ok = await AdminUi.confirm(
      context,
      title: 'Mark as failed?',
      message: 'This payment will be marked as failed / not collected.',
      confirmText: 'Mark failed',
      danger: true,
    );
    if (ok) setState(() => t.status = 'Failed');
  }

  Future<void> _recordPayment() async {
    final customers = AdminStore.customers;
    if (customers.isEmpty) {
      AdminUi.snack(context, 'Add a customer first');
      return;
    }
    final formKey = GlobalKey<FormState>();
    final service = TextEditingController();
    final amount = TextEditingController();
    AdminCustomer customer = customers.first;
    String method = AdminStore.paymentMethods.first;

    final ok = await AdminUi.formDialog(
      context,
      title: 'Record Payment',
      formKey: formKey,
      fields: (setState) => Column(
        children: [
          AdminUi.dropdown<AdminCustomer>(
            value: customer,
            items: customers,
            label: 'Customer',
            icon: Icons.person_outline,
            itemLabel: (c) => c.name,
            onChanged: (v) => setState(() => customer = v ?? customer),
          ),
          AdminUi.field(service, 'Service / item',
              icon: Icons.spa_outlined, validator: AdminUi.validateRequired),
          AdminUi.field(amount, 'Amount (Rs.)',
              icon: Icons.payments_outlined,
              keyboardType: TextInputType.number,
              validator: AdminUi.validateNumber),
          AdminUi.dropdown<String>(
            value: method,
            items: AdminStore.paymentMethods,
            label: 'Payment method',
            icon: Icons.credit_card,
            onChanged: (v) => setState(() => method = v ?? method),
          ),
        ],
      ),
    );

    if (!ok) return;
    setState(() {
      AdminStore.addTransaction(
        customer: customer,
        service: service.text.trim(),
        amount: int.parse(amount.text.trim()),
        method: method,
      );
    });
    if (mounted) AdminUi.snack(context, 'Payment recorded');
  }

  @override
  Widget build(BuildContext context) {
    final pending = AdminStore.transactions
        .where((t) => t.status == 'Pending')
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    final todayPaid = AdminStore.revenueOn(AdminStore.today());

    return Scaffold(
      backgroundColor: AdminColors.cream,
      appBar: AdminUi.appBar('Manage Payments'),
      floatingActionButton:
      AdminUi.fab('Record Payment', Icons.add_card, _recordPayment),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
        children: [
          AdminUi.statRow(
            AdminUi.statCard(
                icon: Icons.hourglass_bottom,
                label: 'To collect',
                value: AdminStore.money(AdminStore.sum(pending)),
                color: AdminColors.orange),
            AdminUi.statCard(
                icon: Icons.today,
                label: 'Collected today',
                value: AdminStore.money(todayPaid),
                color: AdminColors.green),
          ),
          AdminUi.sectionTitle('Pending Payments (${pending.length})'),
          if (pending.isEmpty)
            AdminUi.emptyState('All payments are settled',
                icon: Icons.check_circle_outline)
          else
            ...pending.map(
                  (t) => AdminUi.card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t.service,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: AdminColors.mocha)),
                              Text(t.customerName,
                                  style: const TextStyle(
                                      fontSize: 13, color: AdminColors.mocha)),
                              Text(
                                  '${AdminStore.shortDate(t.date)}  •  ${t.method}  •  ${t.id}',
                                  style: TextStyle(
                                      fontSize: 11.5,
                                      color: AdminColors.mocha
                                          .withValues(alpha: 0.7))),
                            ],
                          ),
                        ),
                        Text(AdminStore.money(t.amount),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AdminColors.mocha)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: [
                        AdminUi.smallButton('Mark as paid', () => _markPaid(t),
                            color: AdminColors.green),
                        AdminUi.smallButton('Mark failed', () => _markFailed(t),
                            color: AdminColors.red, outlined: true),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
