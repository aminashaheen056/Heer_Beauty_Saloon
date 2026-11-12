import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';
import 'appointments_detail.dart';

class AllAppointmentsScreen extends StatefulWidget {
  const AllAppointmentsScreen({super.key});

  @override
  State<AllAppointmentsScreen> createState() => _AllAppointmentsScreenState();
}

class _AllAppointmentsScreenState extends State<AllAppointmentsScreen> {
  static const filters = ['All', 'Pending', 'Upcoming', 'Completed', 'Cancelled'];

  String _filter = 'All';
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final all = AdminStore.appointments;

    final list = all.where((a) {
      final matchesFilter = _filter == 'All' || a.status == _filter;
      final q = _query.toLowerCase();
      final matchesQuery = q.isEmpty ||
          a.customerName.toLowerCase().contains(q) ||
          a.service.toLowerCase().contains(q) ||
          a.staffName.toLowerCase().contains(q);
      return matchesFilter && matchesQuery;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      backgroundColor: AdminColors.cream,
      appBar: AdminUi.appBar('All Appointments'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: [
                AdminUi.searchBar('Search customer, service or staff',
                        (v) => setState(() => _query = v)),
                const SizedBox(height: 10),
                AdminUi.filterChips(
                  filters.map((f) {
                    if (f == 'All') return 'All (${all.length})';
                    return '$f (${all.where((a) => a.status == f).length})';
                  }).toList(),
                  _filter == 'All'
                      ? 'All (${all.length})'
                      : '$_filter (${all.where((a) => a.status == _filter).length})',
                      (label) => setState(() => _filter = label.split(' ').first),
                ),
              ],
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? AdminUi.emptyState('No appointments found',
                icon: Icons.event_busy)
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final a = list[i];
                return AdminUi.card(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AppointmentsDetailScreen(appointment: a),
                    ),
                  ).then((_) => setState(() {})),
                  child: Row(
                    children: [
                      AdminUi.thumb(a.image, size: 60),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a.service,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: AdminColors.mocha)),
                            const SizedBox(height: 2),
                            Text(a.customerName,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: AdminColors.mocha)),
                            const SizedBox(height: 2),
                            Text(
                              '${AdminStore.date(a.date)}  •  ${a.time}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AdminColors.mocha
                                      .withValues(alpha: 0.75)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              a.staffName.isEmpty
                                  ? 'Staff: Unassigned'
                                  : 'Staff: ${a.staffName}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: a.staffName.isEmpty
                                      ? AdminColors.orange
                                      : AdminColors.mocha
                                      .withValues(alpha: 0.75)),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AdminUi.statusChip(a.status),
                          const SizedBox(height: 8),
                          Text(AdminStore.money(a.price),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AdminColors.mocha)),
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
