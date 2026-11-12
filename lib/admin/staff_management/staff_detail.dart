import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';
import '../appointment_management/appointments_detail.dart';
import 'add_staff.dart';
import 'manage_staff_availability.dart';

class StaffDetailScreen extends StatefulWidget {
  final StaffMember staff;

  const StaffDetailScreen({super.key, required this.staff});

  @override
  State<StaffDetailScreen> createState() => _StaffDetailScreenState();
}

class _StaffDetailScreenState extends State<StaffDetailScreen> {
  StaffMember get s => widget.staff;

  Future<void> _edit() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddStaffScreen(staff: s)),
    );
    if (mounted) setState(() {});
  }

  Future<void> _availability() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => ManageStaffAvailabilityScreen(staff: s)),
    );
    if (mounted) setState(() {});
  }

  Future<void> _toggleActive() async {
    final deactivating = s.active;
    final ok = await AdminUi.confirm(
      context,
      title: deactivating ? 'Deactivate staff?' : 'Activate staff?',
      message: deactivating
          ? '${s.name} will no longer be available for new appointments.'
          : '${s.name} will be available for appointments again.',
      confirmText: deactivating ? 'Deactivate' : 'Activate',
      danger: deactivating,
    );
    if (ok) setState(() => s.active = !s.active);
  }

  Future<void> _delete() async {
    final assigned = AdminStore.appointmentsOfStaff(s.id)
        .where((a) => a.status == 'Pending' || a.status == 'Upcoming')
        .length;
    final ok = await AdminUi.confirm(
      context,
      title: 'Delete staff member?',
      message: assigned > 0
          ? '${s.name} still has $assigned open appointment(s). They will become unassigned.'
          : '${s.name} will be removed permanently.',
      confirmText: 'Delete',
      danger: true,
    );
    if (!ok) return;
    for (final a in AdminStore.appointmentsOfStaff(s.id)) {
      if (a.status == 'Pending' || a.status == 'Upcoming') {
        AdminStore.assignStaff(a, null);
      }
    }
    AdminStore.staff.remove(s);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final appts = AdminStore.appointmentsOfStaff(s.id)
      ..sort((a, b) => b.date.compareTo(a.date));
    final completed = appts.where((a) => a.status == 'Completed').length;
    final open =
    appts.where((a) => a.status == 'Pending' || a.status == 'Upcoming').toList();
    final earned = appts
        .where((a) => a.status == 'Completed')
        .fold<int>(0, (sum, a) => sum + a.price);

    return Scaffold(
      backgroundColor: AdminColors.cream,
      appBar: AdminUi.appBar(
        'Staff Details',
        actions: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: _edit),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: ClipOval(
              child: Image.asset(
                s.image,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (c, e, st) => Container(
                  width: 110,
                  height: 110,
                  color: AdminColors.softBeige,
                  child: const Icon(Icons.person, size: 48),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(s.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AdminColors.mocha)),
          Text(s.specialization,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13.5, color: AdminColors.golden)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AdminUi.statusChip(s.active ? 'Active' : 'Inactive'),
              const SizedBox(width: 8),
              if (s.active) AdminUi.statusChip(s.onDuty ? 'Available' : 'Off duty'),
            ],
          ),
          const SizedBox(height: 16),
          AdminUi.statRow(
            AdminUi.statCard(
                icon: Icons.done_all,
                label: 'Completed jobs',
                value: '$completed',
                color: AdminColors.green),
            AdminUi.statCard(
                icon: Icons.payments_outlined,
                label: 'Service value',
                value: AdminStore.money(earned),
                color: AdminColors.blue),
          ),
          AdminUi.card(
            child: Column(
              children: [
                AdminUi.infoRow(Icons.star, 'Rating',
                    s.rating == 0 ? 'New' : s.rating.toStringAsFixed(1)),
                AdminUi.infoRow(Icons.timeline, 'Experience', s.experience),
                AdminUi.infoRow(Icons.phone_outlined, 'Phone', s.phone),
                AdminUi.infoRow(Icons.email_outlined, 'Email', s.email),
                AdminUi.infoRow(Icons.calendar_view_week, 'Works',
                    AdminStore.weekDays.where(s.workingDays.contains).join(', ')),
                AdminUi.infoRow(Icons.access_time, 'Hours',
                    '${s.startTime} - ${s.endTime}'),
              ],
            ),
          ),
          AdminUi.card(
            child: Text(s.description,
                style: const TextStyle(height: 1.5, color: AdminColors.mocha)),
          ),
          Row(
            children: [
              Expanded(
                child: AdminUi.primaryButton('AVAILABILITY', _availability,
                    icon: Icons.schedule),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AdminUi.primaryButton(
                  s.active ? 'DEACTIVATE' : 'ACTIVATE',
                  _toggleActive,
                  icon: s.active ? Icons.pause_circle_outline : Icons.play_circle_outline,
                  color: s.active ? AdminColors.orange : AdminColors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AdminUi.primaryButton('DELETE STAFF MEMBER', _delete,
              icon: Icons.delete_outline, color: AdminColors.red),
          AdminUi.sectionTitle('Open Assignments'),
          if (open.isEmpty)
            AdminUi.card(
              child: const Text('No open appointments assigned',
                  style: TextStyle(color: AdminColors.mocha)),
            )
          else
            ...open.map(
                  (a) => AdminUi.card(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AppointmentsDetailScreen(appointment: a)),
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
                          Text(
                              '${a.customerName}  •  ${AdminStore.dayMonth(a.date)}, ${a.time}',
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
