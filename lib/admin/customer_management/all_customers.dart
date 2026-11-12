import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';
import 'customers_detail.dart';

class AllCustomersScreen extends StatefulWidget {
  const AllCustomersScreen({super.key});

  @override
  State<AllCustomersScreen> createState() => _AllCustomersScreenState();
}

class _AllCustomersScreenState extends State<AllCustomersScreen> {
  String _query = '';
  String _filter = 'All';

  Future<void> _addCustomer() async {
    final formKey = GlobalKey<FormState>();
    final name = TextEditingController();
    final phone = TextEditingController();
    final email = TextEditingController();
    final address = TextEditingController();

    final ok = await AdminUi.formDialog(
      context,
      title: 'Add Customer',
      formKey: formKey,
      fields: (setState) => Column(
        children: [
          AdminUi.field(name, 'Full name',
              icon: Icons.person_outline, validator: AdminUi.validateRequired),
          AdminUi.field(phone, 'Phone number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: AdminUi.validateRequired),
          AdminUi.field(email, 'Email address',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: AdminUi.validateEmail),
          AdminUi.field(address, 'Address', icon: Icons.location_on_outlined),
        ],
      ),
    );

    if (!ok) return;
    setState(() {
      AdminStore.customers.insert(
        0,
        AdminCustomer(
          id: AdminStore.nextId('c'),
          name: name.text.trim(),
          email: email.text.trim(),
          phone: phone.text.trim(),
          address: address.text.trim(),
          joined: DateTime.now(),
        ),
      );
    });
    if (mounted) AdminUi.snack(context, 'Customer added');
  }

  @override
  Widget build(BuildContext context) {
    final q = _query.toLowerCase();
    final list = AdminStore.customers.where((c) {
      final matchesFilter = _filter == 'All' ||
          (_filter == 'Active' && !c.blocked) ||
          (_filter == 'Blocked' && c.blocked);
      final matchesQuery = q.isEmpty ||
          c.name.toLowerCase().contains(q) ||
          c.email.toLowerCase().contains(q) ||
          c.phone.contains(q);
      return matchesFilter && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: AdminColors.cream,
      appBar: AdminUi.appBar('All Customers'),
      floatingActionButton:
      AdminUi.fab('Add Customer', Icons.person_add_alt_1, _addCustomer),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: [
                AdminUi.searchBar('Search name, email or phone',
                        (v) => setState(() => _query = v)),
                const SizedBox(height: 10),
                AdminUi.filterChips(const ['All', 'Active', 'Blocked'], _filter,
                        (v) => setState(() => _filter = v)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${list.length} customer(s)',
                style: TextStyle(
                    fontSize: 12.5,
                    color: AdminColors.mocha.withValues(alpha: 0.7)),
              ),
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? AdminUi.emptyState('No customers found',
                icon: Icons.people_outline)
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 90),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final c = list[i];
                final visits = AdminStore.appointmentsOfCustomer(c.id)
                    .where((a) => a.status == 'Completed')
                    .length;
                return AdminUi.card(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CustomerDetailsScreen(customer: c)),
                  ).then((_) => setState(() {})),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor:
                        AdminColors.blushPink.withValues(alpha: 0.25),
                        child: Text(
                          c.name.isEmpty ? '?' : c.name[0].toUpperCase(),
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AdminColors.mocha),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: AdminColors.mocha)),
                            Text(c.phone,
                                style: TextStyle(
                                    fontSize: 12.5,
                                    color: AdminColors.mocha
                                        .withValues(alpha: 0.75))),
                            Text('$visits completed visit(s)',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AdminColors.mocha
                                        .withValues(alpha: 0.6))),
                          ],
                        ),
                      ),
                      AdminUi.statusChip(c.blocked ? 'Blocked' : 'Active'),
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
