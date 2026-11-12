import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';
import 'appointments_detail.dart';

class ManageAppointmentsScreen extends StatefulWidget {
  const ManageAppointmentsScreen({super.key});

  @override
  State<ManageAppointmentsScreen> createState() =>
      _ManageAppointmentsScreenState();
}

class _ManageAppointmentsScreenState extends State<ManageAppointmentsScreen> {
  int _minutes(String time) {
    final t = AdminStore.parseTime(time);
    return t.hour * 60 + t.minute;
  }

  List<AdminAppointment> _sorted(Iterable<AdminAppointment> items) {
    final list = items.toList();
    list.sort((a, b) {
      final d = a.date.compareTo(b.date);
      return d != 0 ? d : _minutes(a.time).compareTo(_minutes(b.time));
    });
    return list;
  }

  Future<void> _changeStatus(AdminAppointment a, String status) async {
    if (status == 'Cancelled') {
      final ok = await AdminUi.confirm(
        context,
        title: 'Cancel appointment?',
        message: '${a.customerName}\'s ${a.service} appointment will be cancelled.',
        confirmText: 'Cancel appointment',
        danger: true,
      );
      if (!ok) return;
    }
    setState(() => AdminStore.updateAppointmentStatus(a, status));
    if (mounted) AdminUi.snack(context, 'Marked as $status');
  }

  Future<void> _assignStaff(AdminAppointment a) async {
    final staff = AdminStore.activeStaff;
    final picked = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        backgroundColor: AdminColors.cream,
        title: const Text('Assign staff',
            style: TextStyle(
                color: AdminColors.mocha, fontWeight: FontWeight.bold)),
        children: [
          ...staff.map(
                (s) => SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, s.id),
              child: Row(
                children: [
                  const Icon(Icons.badge_outlined,
                      color: AdminColors.golden, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('${s.name} - ${s.specialization}',
                        style: const TextStyle(color: AdminColors.mocha)),
                  ),
                ],
              ),
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, ''),
            child: const Text('Unassign',
                style: TextStyle(color: AdminColors.red)),
          ),
        ],
      ),
    );
    if (picked == null) return;
    setState(() => AdminStore.assignStaff(a, AdminStore.findStaff(picked)));
  }

  Future<void> _addWalkIn() async {
    final customers = AdminStore.customers.where((c) => !c.blocked).toList();
    final services = AdminStore.services.where((s) => s.active).toList();
    if (customers.isEmpty || services.isEmpty) {
      AdminUi.snack(context, 'Add at least one customer and one active service first');
      return;
    }

    final formKey = GlobalKey<FormState>();
    AdminCustomer customer = customers.first;
    ServiceItem service = services.first;
    String staffId = '';
    DateTime day = AdminStore.today();
    String time = '10:00 AM';
    final staffIds = ['', ...AdminStore.activeStaff.map((s) => s.id)];

    final ok = await AdminUi.formDialog(
      context,
      title: 'New Appointment',
      formKey: formKey,
      confirmText: 'Book',
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
          AdminUi.dropdown<ServiceItem>(
            value: service,
            items: services,
            label: 'Service',
            icon: Icons.spa_outlined,
            itemLabel: (s) => '${s.name} (${AdminStore.money(s.price)})',
            onChanged: (v) => setState(() => service = v ?? service),
          ),
          AdminUi.dropdown<String>(
            value: staffId,
            items: staffIds,
            label: 'Beautician',
            icon: Icons.badge_outlined,
            itemLabel: (id) =>
            id.isEmpty ? 'Unassigned' : AdminStore.findStaff(id)!.name,
            onChanged: (v) => setState(() => staffId = v ?? ''),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final d = await AdminUi.pickDate(context, day);
                    if (d != null) setState(() => day = d);
                  },
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: Text(AdminStore.dayMonth(day)),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: AdminColors.mocha,
                      side: const BorderSide(color: AdminColors.golden)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final t = await AdminUi.pickTime(context, time);
                    if (t != null) setState(() => time = t);
                  },
                  icon: const Icon(Icons.access_time, size: 16),
                  label: Text(time),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: AdminColors.mocha,
                      side: const BorderSide(color: AdminColors.golden)),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (!ok) return;
    setState(() {
      AdminStore.addAppointment(
        customer: customer,
        service: service,
        day: day,
        time: time,
        staffMember: AdminStore.findStaff(staffId),
      );
    });
    if (mounted) AdminUi.snack(context, 'Appointment booked for ${customer.name}');
  }

  Widget _card(AdminAppointment a) {
    final actions = <Widget>[];

    if (a.status == 'Pending') {
      actions.addAll([
        AdminUi.smallButton('Confirm', () => _changeStatus(a, 'Upcoming'),
            color: AdminColors.green),
        AdminUi.smallButton('Reject', () => _changeStatus(a, 'Cancelled'),
            color: AdminColors.red, outlined: true),
      ]);
    } else if (a.status == 'Upcoming') {
      actions.addAll([
        AdminUi.smallButton('Complete', () => _changeStatus(a, 'Completed'),
            color: AdminColors.green),
        AdminUi.smallButton('Cancel', () => _changeStatus(a, 'Cancelled'),
            color: AdminColors.red, outlined: true),
      ]);
    }
    actions.add(AdminUi.smallButton('Assign', () => _assignStaff(a),
        outlined: true, color: AdminColors.mocha));

    return AdminUi.card(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => AppointmentsDetailScreen(appointment: a)),
      ).then((_) => setState(() {})),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AdminUi.thumb(a.image, size: 54),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a.service,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AdminColors.mocha)),
                    Text(a.customerName,
                        style: const TextStyle(
                            fontSize: 13, color: AdminColors.mocha)),
                    Text('${AdminStore.dayMonth(a.date)}  •  ${a.time}',
                        style: TextStyle(
                            fontSize: 12,
                            color: AdminColors.mocha.withValues(alpha: 0.75))),
                  ],
                ),
              ),
              AdminUi.statusChip(a.status),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.badge_outlined,
                  size: 15,
                  color: a.staffName.isEmpty
                      ? AdminColors.orange
                      : AdminColors.golden),
              const SizedBox(width: 6),
              Text(
                a.staffName.isEmpty ? 'No staff assigned' : a.staffName,
                style: TextStyle(
                    fontSize: 12.5,
                    color: a.staffName.isEmpty
                        ? AdminColors.orange
                        : AdminColors.mocha),
              ),
              const Spacer(),
              Text(AdminStore.money(a.price),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: AdminColors.mocha)),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 6, children: actions),
        ],
      ),
    );
  }

  Widget _tab(List<AdminAppointment> items, String emptyText) {
    if (items.isEmpty) {
      return AdminUi.emptyState(emptyText, icon: Icons.event_available);
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
      itemCount: items.length,
      itemBuilder: (context, i) => _card(items[i]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final all = AdminStore.appointments;
    final today = AdminStore.today();

    final pending = _sorted(all.where((a) => a.status == 'Pending'));
    final upcoming = _sorted(all.where((a) => a.status == 'Upcoming'));
    final todays = _sorted(all.where(
            (a) => AdminStore.sameDay(a.date, today) && a.status != 'Cancelled'));

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AdminColors.cream,
        appBar: AdminUi.appBar(
          'Manage Appointments',
          bottom: TabBar(
            labelColor: AdminColors.blushPink,
            unselectedLabelColor: AdminColors.mocha,
            indicatorColor: AdminColors.blushPink,
            tabs: [
              Tab(text: 'Pending (${pending.length})'),
              Tab(text: 'Upcoming (${upcoming.length})'),
              Tab(text: 'Today (${todays.length})'),
            ],
          ),
        ),
        floatingActionButton:
        AdminUi.fab('New Booking', Icons.add, _addWalkIn),
        body: TabBarView(
          children: [
            _tab(pending, 'No appointments waiting for approval'),
            _tab(upcoming, 'No upcoming appointments'),
            _tab(todays, 'Nothing scheduled for today'),
          ],
        ),
      ),
    );
  }
}
