import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';

class RefundManagementScreen extends StatefulWidget {
  const RefundManagementScreen({super.key});

  @override
  State<RefundManagementScreen> createState() => _RefundManagementScreenState();
}

class _RefundManagementScreenState extends State<RefundManagementScreen> {
  Future<void> _approve(RefundRequest r) async {
    final ok = await AdminUi.confirm(
      context,
      title: 'Approve refund?',
      message:
      'Refund ${AdminStore.money(r.amount)} to ${r.transaction.customerName}. The transaction will be marked as Refunded.',
      confirmText: 'Approve',
    );
    if (!ok) return;
    setState(() => AdminStore.approveRefund(r));
    if (mounted) AdminUi.snack(context, 'Refund approved');
  }

  Future<void> _reject(RefundRequest r) async {
    final ok = await AdminUi.confirm(
      context,
      title: 'Reject refund?',
      message: 'The customer will be notified that this refund was rejected.',
      confirmText: 'Reject',
      danger: true,
    );
    if (!ok) return;
    setState(() => AdminStore.rejectRefund(r));
    if (mounted) AdminUi.snack(context, 'Refund rejected');
  }

  Future<void> _newRefund() async {
    final pendingIds = AdminStore.refunds
        .where((r) => r.status == 'Pending')
        .map((r) => r.transaction.id)
        .toSet();
    final eligible = AdminStore.transactions
        .where((t) => t.status == 'Paid' && !pendingIds.contains(t.id))
        .toList();

    if (eligible.isEmpty) {
      AdminUi.snack(context, 'No paid transactions available for refund');
      return;
    }

    final formKey = GlobalKey<FormState>();
    final amount = TextEditingController(text: '${eligible.first.amount}');
    final reason = TextEditingController();
    AdminTransaction tx = eligible.first;

    final ok = await AdminUi.formDialog(
      context,
      title: 'New Refund Request',
      formKey: formKey,
      confirmText: 'Create',
      fields: (setState) => Column(
        children: [
          AdminUi.dropdown<AdminTransaction>(
            value: tx,
            items: eligible,
            label: 'Transaction',
            icon: Icons.receipt_long_outlined,
            itemLabel: (t) =>
            '${t.customerName} - ${t.service} (${AdminStore.money(t.amount)})',
            onChanged: (v) => setState(() {
              tx = v ?? tx;
              amount.text = '${tx.amount}';
            }),
          ),
          AdminUi.field(amount, 'Refund amount (Rs.)',
              icon: Icons.payments_outlined,
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = int.tryParse((v ?? '').trim());
                if (n == null || n <= 0) return 'Enter a valid amount';
                if (n > tx.amount) {
                  return 'Cannot exceed ${AdminStore.money(tx.amount)}';
                }
                return null;
              }),
          AdminUi.field(reason, 'Reason',
              icon: Icons.notes,
              maxLines: 3,
              validator: AdminUi.validateRequired),
        ],
      ),
    );

    if (!ok) return;
    setState(() {
      AdminStore.requestRefund(tx, int.parse(amount.text.trim()), reason.text.trim());
    });
  }

  Widget _card(RefundRequest r) {
    final t = r.transaction;
    return AdminUi.card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.customerName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AdminColors.mocha)),
                    Text('${t.service}  •  ${t.id}',
                        style: TextStyle(
                            fontSize: 12,
                            color: AdminColors.mocha.withValues(alpha: 0.75))),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(AdminStore.money(r.amount),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AdminColors.mocha)),
                  const SizedBox(height: 4),
                  AdminUi.statusChip(r.status),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(r.reason,
              style: const TextStyle(
                  fontSize: 13, height: 1.4, color: AdminColors.mocha)),
          const SizedBox(height: 4),
          Text('Requested ${AdminStore.date(r.date)}  •  Paid via ${t.method}',
              style: TextStyle(
                  fontSize: 11.5, color: AdminColors.mocha.withValues(alpha: 0.6))),
          if (r.status == 'Pending') ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [
                AdminUi.smallButton('Approve', () => _approve(r),
                    color: AdminColors.green),
                AdminUi.smallButton('Reject', () => _reject(r),
                    color: AdminColors.red, outlined: true),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _tab(String status) {
    final items = AdminStore.refunds.where((r) => r.status == status).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    if (items.isEmpty) {
      return AdminUi.emptyState('No ${status.toLowerCase()} refunds',
          icon: Icons.assignment_return_outlined);
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
      itemCount: items.length,
      itemBuilder: (context, i) => _card(items[i]),
    );
  }

  @override
  Widget build(BuildContext context) {
    int count(String s) => AdminStore.refunds.where((r) => r.status == s).length;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AdminColors.cream,
        appBar: AdminUi.appBar(
          'Refund Management',
          bottom: TabBar(
            labelColor: AdminColors.blushPink,
            unselectedLabelColor: AdminColors.mocha,
            indicatorColor: AdminColors.blushPink,
            tabs: [
              Tab(text: 'Pending (${count('Pending')})'),
              Tab(text: 'Approved (${count('Approved')})'),
              Tab(text: 'Rejected (${count('Rejected')})'),
            ],
          ),
        ),
        floatingActionButton:
        AdminUi.fab('New Refund', Icons.add, _newRefund),
        body: TabBarView(
          children: [_tab('Pending'), _tab('Approved'), _tab('Rejected')],
        ),
      ),
    );
  }
}
