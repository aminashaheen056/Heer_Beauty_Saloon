import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';
import '../notification/revenue_report_screen.dart';
import 'all_transactions.dart';
import 'manage_payments.dart';
import 'refund_payement_management.dart';

class FinanceDashboardScreen extends StatefulWidget {
  const FinanceDashboardScreen({super.key});

  @override
  State<FinanceDashboardScreen> createState() => _FinanceDashboardScreenState();
}

class _FinanceDashboardScreenState extends State<FinanceDashboardScreen> {
  void _go(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page))
        .then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = AdminStore.today();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthRevenue = AdminStore.sum(AdminStore.paidBetween(monthStart, now));
    final todayRevenue = AdminStore.revenueOn(now);
    final net = AdminStore.totalRevenue;

    final weekly = AdminStore.dailyRevenue(7)
        .map((e) => MapEntry(AdminStore.dayMonth(e.key).split(' ').first, e.value))
        .toList();
    final paid = AdminStore.transactions.where((t) => t.status == 'Paid').toList();

    return Scaffold(
      backgroundColor: AdminColors.cream,
      appBar: AdminUi.appBar('Finance Dashboard'),
      body: RefreshIndicator(
        color: AdminColors.blushPink,
        onRefresh: () async => setState(() {}),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AdminColors.mocha, Color(0xFF8B6A4F)]),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total revenue (paid)',
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(AdminStore.money(net),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(
                      'Today ${AdminStore.money(todayRevenue)}  •  This month ${AdminStore.money(monthRevenue)}',
                      style: const TextStyle(color: Colors.white, fontSize: 12.5)),
                ],
              ),
            ),
            AdminUi.statRow(
              AdminUi.statCard(
                  icon: Icons.hourglass_bottom,
                  label: 'Pending payments',
                  value: AdminStore.money(AdminStore.pendingAmount),
                  color: AdminColors.orange,
                  onTap: () => _go(const ManagePaymentsScreen())),
              AdminUi.statCard(
                  icon: Icons.assignment_return_outlined,
                  label: 'Refunded',
                  value: AdminStore.money(AdminStore.refundedAmount),
                  color: AdminColors.golden,
                  onTap: () => _go(const RefundManagementScreen())),
            ),
            AdminUi.statRow(
              AdminUi.statCard(
                  icon: Icons.receipt_long,
                  label: 'Transactions',
                  value: '${AdminStore.transactions.length}',
                  color: AdminColors.blue,
                  onTap: () => _go(const AllTransactionsScreen())),
              AdminUi.statCard(
                  icon: Icons.pending_actions,
                  label: 'Refund requests',
                  value: '${AdminStore.pendingRefundCount}',
                  color: AdminColors.red,
                  onTap: () => _go(const RefundManagementScreen())),
            ),
            AdminUi.sectionTitle('Last 7 Days'),
            AdminUi.card(child: AdminBarChart(data: weekly)),
            AdminUi.sectionTitle('Revenue by Payment Method'),
            AdminUi.card(
                child: AdminHBars(data: AdminStore.revenueByMethod(paid))),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: AdminUi.primaryButton('TRANSACTIONS',
                          () => _go(const AllTransactionsScreen()),
                      icon: Icons.receipt_long),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AdminUi.primaryButton('FULL REPORT',
                          () => _go(const RevenueReportScreen()),
                      icon: Icons.bar_chart, color: AdminColors.mocha),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
