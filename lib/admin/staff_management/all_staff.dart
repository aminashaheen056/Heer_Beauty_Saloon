import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';
import 'add_staff.dart';
import 'staff_detail.dart';

class AllStaffScreen extends StatefulWidget {
  const AllStaffScreen({super.key});

  @override
  State<AllStaffScreen> createState() => _AllStaffScreenState();
}

class _AllStaffScreenState extends State<AllStaffScreen> {
  String _query = '';
  String _filter = 'All';

  Future<void> _add() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddStaffScreen()),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final q = _query.toLowerCase();
    final list = AdminStore.staff.where((s) {
      final matchesFilter = _filter == 'All' ||
          (_filter == 'Active' && s.active) ||
          (_filter == 'Inactive' && !s.active);
      final matchesQuery = q.isEmpty ||
          s.name.toLowerCase().contains(q) ||
          s.specialization.toLowerCase().contains(q);
      return matchesFilter && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: AdminColors.cream,
      appBar: AdminUi.appBar('All Staff'),
      floatingActionButton:
      AdminUi.fab('Add Staff', Icons.person_add_alt_1, _add),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: [
                AdminUi.searchBar('Search name or specialization',
                        (v) => setState(() => _query = v)),
                const SizedBox(height: 10),
                AdminUi.filterChips(const ['All', 'Active', 'Inactive'], _filter,
                        (v) => setState(() => _filter = v)),
              ],
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? AdminUi.emptyState('No staff members found',
                icon: Icons.badge_outlined)
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 90),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final s = list[i];
                return AdminUi.card(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => StaffDetailScreen(staff: s)),
                  ).then((_) => setState(() {})),
                  child: Row(
                    children: [
                      Opacity(
                        opacity: s.active ? 1 : 0.5,
                        child: ClipOval(
                          child: Image.asset(
                            s.image,
                            width: 62,
                            height: 62,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, st) => Container(
                              width: 62,
                              height: 62,
                              color: AdminColors.softBeige,
                              child: const Icon(Icons.person,
                                  color: AdminColors.mocha),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AdminColors.mocha)),
                            Text(s.specialization,
                                style: const TextStyle(
                                    fontSize: 12.5,
                                    color: AdminColors.golden)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 15, color: AdminColors.golden),
                                const SizedBox(width: 3),
                                Text(s.rating == 0 ? 'New' : s.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                        fontSize: 12.5,
                                        color: AdminColors.mocha)),
                                const SizedBox(width: 10),
                                Text(s.experience,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AdminColors.mocha
                                            .withValues(alpha: 0.7))),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AdminUi.statusChip(
                              s.active ? 'Active' : 'Inactive'),
                          const SizedBox(height: 6),
                          if (s.active)
                            AdminUi.statusChip(
                                s.onDuty ? 'Available' : 'Off duty'),
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
