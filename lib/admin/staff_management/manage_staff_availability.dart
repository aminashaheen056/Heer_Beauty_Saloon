import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';

/// Lists every staff member with editable working days, hours and duty status.
/// When [staff] is given, that member's tile starts expanded.
class ManageStaffAvailabilityScreen extends StatefulWidget {
  final StaffMember? staff;

  const ManageStaffAvailabilityScreen({super.key, this.staff});

  @override
  State<ManageStaffAvailabilityScreen> createState() =>
      _ManageStaffAvailabilityScreenState();
}

class _ManageStaffAvailabilityScreenState
    extends State<ManageStaffAvailabilityScreen> {
  Future<void> _pickTime(StaffMember s, bool start) async {
    final picked =
    await AdminUi.pickTime(context, start ? s.startTime : s.endTime);
    if (picked == null) return;
    setState(() {
      if (start) {
        s.startTime = picked;
      } else {
        s.endTime = picked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final list = AdminStore.staff.where((s) => s.active).toList();

    return Scaffold(
      backgroundColor: AdminColors.cream,
      appBar: AdminUi.appBar('Staff Availability'),
      body: list.isEmpty
          ? AdminUi.emptyState('No active staff members', icon: Icons.schedule)
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (context, i) {
          final s = list[i];
          return AdminUi.card(
            padding: EdgeInsets.zero,
            child: Theme(
              data: Theme.of(context)
                  .copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                key: PageStorageKey(s.id),
                initiallyExpanded: widget.staff == s,
                tilePadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                childrenPadding:
                const EdgeInsets.fromLTRB(14, 0, 14, 14),
                leading: ClipOval(
                  child: Image.asset(
                    s.image,
                    width: 46,
                    height: 46,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, st) => Container(
                        width: 46,
                        height: 46,
                        color: AdminColors.softBeige),
                  ),
                ),
                title: Text(s.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AdminColors.mocha)),
                subtitle: Text(
                  '${AdminStore.weekDays.where(s.workingDays.contains).length} days  •  ${s.startTime} - ${s.endTime}',
                  style: TextStyle(
                      fontSize: 12,
                      color: AdminColors.mocha.withValues(alpha: 0.75)),
                ),
                trailing: AdminUi.statusChip(
                    s.onDuty ? 'Available' : 'Off duty'),
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Available for bookings',
                        style: TextStyle(color: AdminColors.mocha)),
                    value: s.onDuty,
                    activeTrackColor: AdminColors.blushPink,
                    onChanged: (v) => setState(() => s.onDuty = v),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Working days',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AdminColors.mocha)),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: AdminStore.weekDays.map((d) {
                      final on = s.workingDays.contains(d);
                      return FilterChip(
                        label: Text(d),
                        selected: on,
                        showCheckmark: false,
                        selectedColor: AdminColors.blushPink,
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                            color: AdminColors.softBeige),
                        labelStyle: TextStyle(
                            color: on ? Colors.white : AdminColors.mocha,
                            fontWeight: FontWeight.w600),
                        onSelected: (v) => setState(() {
                          if (v) {
                            s.workingDays.add(d);
                          } else {
                            s.workingDays.remove(d);
                          }
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickTime(s, true),
                          icon: const Icon(Icons.login, size: 16),
                          label: Text('Start ${s.startTime}'),
                          style: OutlinedButton.styleFrom(
                              foregroundColor: AdminColors.mocha,
                              side: const BorderSide(
                                  color: AdminColors.golden)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickTime(s, false),
                          icon: const Icon(Icons.logout, size: 16),
                          label: Text('End ${s.endTime}'),
                          style: OutlinedButton.styleFrom(
                              foregroundColor: AdminColors.mocha,
                              side: const BorderSide(
                                  color: AdminColors.golden)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
