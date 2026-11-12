import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';
import '../customer_management/customers_detail.dart';

class AppointmentsDetailScreen extends StatefulWidget {
  final AdminAppointment appointment;

  const AppointmentsDetailScreen({super.key, required this.appointment});

  @override
  State<AppointmentsDetailScreen> createState() =>
      _AppointmentsDetailScreenState();
}

class _AppointmentsDetailScreenState extends State<AppointmentsDetailScreen> {
  AdminAppointment get a => widget.appointment;

  Future<void> _setStatus(String status, {bool ask = false}) async {
    if (ask) {
      final ok = await AdminUi.confirm(
        context,
        title: '$status appointment?',
        message:
        'This will mark the ${a.service} appointment for ${a.customerName} as $status and notify the customer.',
        confirmText: status == 'Cancelled' ? 'Cancel appointment' : status,
        danger: status == 'Cancelled',
      );
      if (!ok) return;
    }
    setState(() => AdminStore.updateAppointmentStatus(a, status));
    if (mounted) AdminUi.snack(context, 'Appointment marked as $status');
  }

  Future<void> _reschedule() async {
    final day = await AdminUi.pickDate(context, a.date,
        first: DateTime.now().subtract(const Duration(days: 1)));
    if (day == null || !mounted) return;
    final time = await AdminUi.pickTime(context, a.time);
    if (time == null || !mounted) return;
    setState(() {
      a.date = day;
      a.time = time;
    });
    AdminStore.addNotification(
      'Appointment Rescheduled',
      'Your ${a.service} appointment has been moved to ${AdminStore.date(day)} at $time.',
      a.customerName,
    );
    AdminUi.snack(context, 'Appointment rescheduled');
  }

  Future<void> _editNotes() async {
    final formKey = GlobalKey<FormState>();
    final c = TextEditingController(text: a.notes);
    final ok = await AdminUi.formDialog(
      context,
      title: 'Appointment Notes',
      formKey: formKey,
      fields: (setState) => AdminUi.field(c, 'Notes',
          icon: Icons.notes, maxLines: 4, hint: 'Allergies, preferences...'),
    );
    if (ok) setState(() => a.notes = c.text.trim());
  }

  void _openCustomer() {
    final c = AdminStore.findCustomer(a.customerId);
    if (c == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CustomerDetailsScreen(customer: c)),
    );
  }

  String _staffLabel(String id) {
    if (id.isEmpty) return 'Unassigned';
    final s = AdminStore.findStaff(id);
    if (s == null) return 'Unknown';
    return s.active ? s.name : '${s.name} (inactive)';
  }

  @override
  Widget build(BuildContext context) {
    final staffIds = ['', ...AdminStore.staff.map((s) => s.id)];
    final currentStaff = staffIds.contains(a.staffId) ? a.staffId : '';

    return Scaffold(
      backgroundColor: AdminColors.cream,
      appBar: AdminUi.appBar('Appointment Details'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              a.image,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                height: 180,
                color: AdminColors.softBeige,
                child: const Icon(Icons.spa, size: 48, color: AdminColors.mocha),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  a.service,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AdminColors.mocha,
                  ),
                ),
              ),
              AdminUi.statusChip(a.status),
            ],
          ),
          const SizedBox(height: 12),
          AdminUi.card(
            child: Column(
              children: [
                AdminUi.infoRow(Icons.confirmation_number_outlined, 'Booking ID', a.id),
                AdminUi.infoRow(Icons.person_outline, 'Customer', a.customerName),
                AdminUi.infoRow(Icons.calendar_today, 'Date', AdminStore.date(a.date)),
                AdminUi.infoRow(Icons.access_time, 'Time', a.time),
                AdminUi.infoRow(Icons.payments_outlined, 'Price', AdminStore.money(a.price)),
                AdminUi.infoRow(Icons.badge_outlined, 'Staff',
                    a.staffName.isEmpty ? 'Unassigned' : a.staffName),
                AdminUi.infoRow(Icons.notes, 'Notes', a.notes),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Wrap(
                    spacing: 8,
                    children: [
                      AdminUi.smallButton('Edit notes', _editNotes,
                          outlined: true, color: AdminColors.mocha),
                      AdminUi.smallButton('View customer', _openCustomer,
                          outlined: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AdminUi.sectionTitle('Assign Staff'),
          AdminUi.dropdown<String>(
            value: currentStaff,
            items: staffIds,
            label: 'Beautician',
            icon: Icons.badge_outlined,
            itemLabel: _staffLabel,
            onChanged: (id) {
              if (id == null) return;
              setState(() {
                AdminStore.assignStaff(a, AdminStore.findStaff(id));
              });
              AdminUi.snack(
                  context,
                  id.isEmpty
                      ? 'Staff unassigned'
                      : 'Assigned to ${AdminStore.findStaff(id)!.name}');
            },
          ),
          AdminUi.sectionTitle('Actions'),
          if (a.status == 'Pending') ...[
            AdminUi.primaryButton('CONFIRM APPOINTMENT',
                    () => _setStatus('Upcoming'),
                icon: Icons.check_circle_outline, color: AdminColors.green),
            const SizedBox(height: 10),
            AdminUi.primaryButton('REJECT / CANCEL',
                    () => _setStatus('Cancelled', ask: true),
                icon: Icons.cancel_outlined, color: AdminColors.red),
          ],
          if (a.status == 'Upcoming') ...[
            AdminUi.primaryButton('MARK AS COMPLETED',
                    () => _setStatus('Completed', ask: true),
                icon: Icons.done_all, color: AdminColors.green),
            const SizedBox(height: 10),
            AdminUi.primaryButton('RESCHEDULE', _reschedule,
                icon: Icons.edit_calendar),
            const SizedBox(height: 10),
            AdminUi.primaryButton('CANCEL APPOINTMENT',
                    () => _setStatus('Cancelled', ask: true),
                icon: Icons.cancel_outlined, color: AdminColors.red),
          ],
          if (a.status == 'Cancelled')
            AdminUi.primaryButton('RESTORE APPOINTMENT',
                    () => _setStatus('Upcoming'),
                icon: Icons.restore),
          if (a.status == 'Completed')
            AdminUi.card(
              child: const Row(
                children: [
                  Icon(Icons.verified, color: AdminColors.green),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This appointment has been completed.',
                      style: TextStyle(color: AdminColors.mocha),
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
