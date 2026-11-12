import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';

class RevenueReportScreen extends StatefulWidget {
  const RevenueReportScreen({super.key});

  @override
  State<RevenueReportScreen> createState() => _RevenueReportScreenState();
}

class _RevenueReportScreenState extends State<RevenueReportScreen> {
  static const periods = ['7 Days', '30 Days', 'This Month', 'All Time'];

  String _period = '7 Days';

  DateTime _from(DateTime today) {
    switch (_period) {
      case '7 Days':
        return today.subtract(const Duration(days: 6));
      case '30 Days':
        return today.subtract(const Duration(days: 29));
      case 'This Month':
        return DateTime(today.year, today.month, 1);
      default:
        return DateTime(2000);
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = AdminStore.today();
    final from = _from(today);
    final paid = AdminStore.paidBetween(from, today);
    final total = AdminStore.sum(paid);
    final average = paid.isEmpty ? 0 : (total / paid.length).round();

    // Group revenue per day for the chart (7 days -> every day,
    // longer ranges -> per week so the bars stay readable).
    final List<MapEntry<String, int>> bars = [];
    if (_period == '7 Days') {
      for (int i = 6; i >= 0; i--) {
        final d = today.subtract(Duration(days: i));
        bars.add(MapEntry('${d.day}', AdminStore.revenueOn(d)));
      }
    } else {
      final start = _period == 'All Time'
          ? (paid.isEmpty
          ? today
          : paid.map((t) => t.date).reduce((a, b) => a.isBefore(b) ? a : b))
          : from;
      var cursor = DateTime(start.year, start.month, start.day);
      while (!cursor.isAfter(today)) {
        final end = cursor.add(const Duration(days: 6));
        final weekEnd = end.isAfter(today) ? today : end;
        final amount = AdminStore.sum(AdminStore.paidBetween(cursor, weekEnd));
        bars.add(MapEntry(AdminStore.dayMonth(cursor), amount));
        cursor = cursor.add(const Duration(days: 7));
      }
      // Keep the chart readable: show only the latest 8 weeks.
      if (bars.length > 8) bars.removeRange(0, bars.length - 8);
    }

    final byCategory = AdminStore.revenueByCategory(paid);
    final byMethod = AdminStore.revenueByMethod(paid);

    // Top services by revenue.
    final byService = <String, int>{};
    for (final t in paid) {
      byService[t.service] = (byService[t.service] ?? 0) + t.amount;
    }
    final topServices = byService.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      backgroundColor: AdminColors.cream,
      appBar: AdminUi.appBar('Revenue Report'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AdminUi.filterChips(
              periods, _period, (v) => setState(() => _period = v)),
          const SizedBox(height: 14),
          AdminUi.statRow(
            AdminUi.statCard(
                icon: Icons.account_balance_wallet,
                label: 'Revenue',
                value: AdminStore.money(total),
                color: AdminColors.green),
            AdminUi.statCard(
                icon: Icons.receipt_long,
                label: 'Paid transactions',
                value: '${paid.length}',
                color: AdminColors.blue),
          ),
          AdminUi.statRow(
            AdminUi.statCard(
                icon: Icons.trending_up,
                label: 'Average sale',
                value: AdminStore.money(average),
                color: AdminColors.golden),
            AdminUi.statCard(
                icon: Icons.hourglass_bottom,
                label: 'Still pending',
                value: AdminStore.money(AdminStore.pendingAmount),
                color: AdminColors.orange),
          ),
          AdminUi.sectionTitle(
              _period == '7 Days' ? 'Daily Revenue' : 'Weekly Revenue'),
          AdminUi.card(
            child: bars.isEmpty
                ? const Text('No data for this period',
                style: TextStyle(color: AdminColors.mocha))
                : AdminBarChart(data: bars),
          ),
          AdminUi.sectionTitle('By Category'),
          AdminUi.card(child: AdminHBars(data: byCategory)),
          AdminUi.sectionTitle('By Payment Method'),
          AdminUi.card(
              child: AdminHBars(data: byMethod, color: AdminColors.blushPink)),
          AdminUi.sectionTitle('Top Services & Packages'),
          if (topServices.isEmpty)
            AdminUi.card(
              child: const Text('No data for this period',
                  style: TextStyle(color: AdminColors.mocha)),
            )
          else
            AdminUi.card(
              child: Column(
                children: [
                  for (int i = 0; i < topServices.length && i < 5; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor:
                            AdminColors.golden.withValues(alpha: 0.2),
                            child: Text('${i + 1}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AdminColors.mocha)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(topServices[i].key,
                                style:
                                const TextStyle(color: AdminColors.mocha)),
                          ),
                          Text(AdminStore.money(topServices[i].value),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AdminColors.mocha)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
