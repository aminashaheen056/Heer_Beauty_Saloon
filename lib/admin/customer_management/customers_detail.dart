import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';
import '../appointment_management/appointments_detail.dart';
import 'customer_finance.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final AdminCustomer customer;

  const CustomerDetailsScreen({super.key, required this.customer});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  AdminCustomer get c => widget.customer;

  Future<void> _edit() async {
    final formKey = GlobalKey<FormState>();
    final name = TextEditingController(text: c.name);
    final phone = TextEditingController(text: c.phone);
    final email = TextEditingController(text: c.email);
    final address = TextEditingController(text: c.address);

    final ok = await AdminUi.formDialog(
      context,
      title: 'Edit Customer',
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
      c.name = name.text.trim();
      c.phone = phone.text.trim();
      c.email = email.text.trim();
      c.address = address.text.trim();
    });
  }

  Future<void> _toggleBlock() async {
    final blocking = !c.blocked;
    final ok = await AdminUi.confirm(
      context,
      title: blocking ? 'Block customer?' : 'Unblock customer?',
      message: blocking
          ? '${c.name} will no longer be able to book appointments.'
          : '${c.name} will be able to book appointments again.',
      confirmText: blocking ? 'Block' : 'Unblock',
      danger: blocking,
    );
    if (ok) setState(() => c.blocked = !c.blocked);
  }

  @override
  Widget build(BuildContext context) {
    final appts = AdminStore.appointmentsOfCustomer(c.id)
      ..sort((a, b) => b.date.compareTo(a.date));
    final completed = appts.where((a) => a.status == 'Completed').length;
    final txns = AdminStore.transactionsOfCustomer(c.id);
    final spent = AdminStore.sum(txns.where((t) => t.status == 'Paid'));
    final packages = AdminStore.packagesOfCustomer(c.id)
        .where((p) => p.currentStatus == 'Active')
        .length;

    return Scaffold(
      backgroundColor: AdminColors.cream,
      appBar: AdminUi.appBar(
        'Customer Details',
        actions: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: _edit),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: AdminColors.blushPink.withValues(alpha: 0.25),
              child: Text(
                c.name.isEmpty ? '?' : c.name[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AdminColors.mocha,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            c.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AdminColors.mocha,
            ),
          ),
          const SizedBox(height: 6),
          Center(child: AdminUi.statusChip(c.blocked ? 'Blocked' : 'Active')),
          const SizedBox(height: 16),
          AdminUi.statRow(
            AdminUi.statCard(
                icon: Icons.event_available,
                label: 'Completed visits',
                value: '$completed',
                color: AdminColors.blue),
            AdminUi.statCard(
                icon: Icons.account_balance_wallet,
                label: 'Total spent',
                value: AdminStore.money(spent),
                color: AdminColors.green),
          ),
          AdminUi.card(
            child: Column(
              children: [
                AdminUi.infoRow(Icons.phone_outlined, 'Phone', c.phone),
                AdminUi.infoRow(Icons.email_outlined, 'Email', c.email),
                AdminUi.infoRow(Icons.location_on_outlined, 'Address', c.address),
                AdminUi.infoRow(
                    Icons.calendar_month, 'Joined', AdminStore.date(c.joined)),
                AdminUi.infoRow(
                    Icons.card_giftcard, 'Packages', '$packages active'),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: AdminUi.primaryButton(
                  'FINANCE',
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CustomerFinanceScreen(customer: c)),
                  ),
                  icon: Icons.account_balance_wallet_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AdminUi.primaryButton(
                  c.blocked ? 'UNBLOCK' : 'BLOCK',
                  _toggleBlock,
                  icon: c.blocked ? Icons.lock_open : Icons.block,
                  color: c.blocked ? AdminColors.green : AdminColors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AdminUi.sectionTitle('Appointment History'),
          if (appts.isEmpty)
            AdminUi.card(
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('No appointments yet',
                      style: TextStyle(color: AdminColors.mocha)),
                ),
              ),
            )
          else
            ...appts.take(8).map(
                  (a) => AdminUi.card(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          AppointmentsDetailScreen(appointment: a)),
                ).then((_) => setState(() {})),
                child: Row(
                  children: [
                    AdminUi.thumb(a.image, size: 46),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a.service,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AdminColors.mocha)),
                          Text('${AdminStore.date(a.date)}  •  ${a.time}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AdminColors.mocha
                                      .withValues(alpha: 0.75))),
                        ],
                      ),
                    ),
                    AdminUi.statusChip(a.status),
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
