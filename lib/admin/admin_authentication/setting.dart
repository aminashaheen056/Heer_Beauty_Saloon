import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';
import 'staff_login.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  Future<void> _editSalonInfo() async {
    final formKey = GlobalKey<FormState>();
    final name = TextEditingController(text: AdminStore.salonName);
    final phone = TextEditingController(text: AdminStore.salonPhone);
    final address = TextEditingController(text: AdminStore.salonAddress);

    final ok = await AdminUi.formDialog(
      context,
      title: 'Salon Information',
      formKey: formKey,
      fields: (setState) => Column(
        children: [
          AdminUi.field(name, 'Salon name',
              icon: Icons.storefront, validator: AdminUi.validateRequired),
          AdminUi.field(phone, 'Contact number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: AdminUi.validateRequired),
          AdminUi.field(address, 'Address',
              icon: Icons.location_on_outlined,
              validator: AdminUi.validateRequired),
        ],
      ),
    );

    if (ok) {
      setState(() {
        AdminStore.salonName = name.text.trim();
        AdminStore.salonPhone = phone.text.trim();
        AdminStore.salonAddress = address.text.trim();
      });
    }
  }

  Future<void> _pickHours(bool opening) async {
    final current =
    opening ? AdminStore.openingTime : AdminStore.closingTime;
    final picked = await AdminUi.pickTime(context, current);
    if (picked == null) return;
    setState(() {
      if (opening) {
        AdminStore.openingTime = picked;
      } else {
        AdminStore.closingTime = picked;
      }
    });
  }

  Future<void> _changePassword() async {
    final ok = await AdminUi.changePasswordDialog(context);
    if (ok && mounted) AdminUi.snack(context, 'Password changed successfully');
  }

  Future<void> _logout() async {
    final ok = await AdminUi.confirm(
      context,
      title: 'Logout',
      message: 'Are you sure you want to log out?',
      confirmText: 'Logout',
      danger: true,
    );
    if (ok && mounted) adminLogout(context);
  }

  Widget _switchTile(
      String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title,
          style: const TextStyle(
              color: AdminColors.mocha, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle,
          style: TextStyle(
              fontSize: 12, color: AdminColors.mocha.withValues(alpha: 0.7))),
      value: value,
      activeTrackColor: AdminColors.blushPink,
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.cream,
      appBar: AdminUi.appBar('Settings'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AdminUi.sectionTitle(
            'Salon Information',
            trailing: TextButton.icon(
              onPressed: _editSalonInfo,
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Edit'),
              style: TextButton.styleFrom(
                  foregroundColor: AdminColors.blushPink),
            ),
          ),
          AdminUi.card(
            child: Column(
              children: [
                AdminUi.infoRow(Icons.storefront, 'Salon', AdminStore.salonName),
                AdminUi.infoRow(Icons.phone, 'Phone', AdminStore.salonPhone),
                AdminUi.infoRow(
                    Icons.location_on_outlined, 'Address', AdminStore.salonAddress),
              ],
            ),
          ),
          AdminUi.sectionTitle('Business Hours'),
          AdminUi.card(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _pickHours(true),
                    child: Column(
                      children: [
                        const Text('Opens',
                            style: TextStyle(color: AdminColors.mocha)),
                        const SizedBox(height: 4),
                        Text(AdminStore.openingTime,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AdminColors.blushPink)),
                      ],
                    ),
                  ),
                ),
                Container(width: 1, height: 40, color: AdminColors.softBeige),
                Expanded(
                  child: InkWell(
                    onTap: () => _pickHours(false),
                    child: Column(
                      children: [
                        const Text('Closes',
                            style: TextStyle(color: AdminColors.mocha)),
                        const SizedBox(height: 4),
                        Text(AdminStore.closingTime,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AdminColors.blushPink)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          AdminUi.sectionTitle('Booking & Payments'),
          AdminUi.card(
            child: Column(
              children: [
                _switchTile(
                  'Online booking',
                  'Allow customers to book appointments from the app',
                  AdminStore.onlineBooking,
                      (v) => setState(() => AdminStore.onlineBooking = v),
                ),
                const Divider(height: 1),
                _switchTile(
                  'Auto-confirm appointments',
                  'New customer bookings skip the approval queue',
                  AdminStore.autoConfirm,
                      (v) => setState(() => AdminStore.autoConfirm = v),
                ),
                const Divider(height: 1),
                _switchTile(
                  'Accept cash at salon',
                  'Show "Cash at Salon" as a payment option',
                  AdminStore.acceptCash,
                      (v) => setState(() => AdminStore.acceptCash = v),
                ),
                const Divider(height: 1),
                _switchTile(
                  'Push notifications',
                  'Notify customers about booking updates',
                  AdminStore.pushNotifications,
                      (v) => setState(() => AdminStore.pushNotifications = v),
                ),
              ],
            ),
          ),
          AdminUi.sectionTitle('Security'),
          AdminUi.card(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock_reset, color: AdminColors.golden),
                  title: const Text('Change password',
                      style: TextStyle(color: AdminColors.mocha)),
                  trailing: const Icon(Icons.chevron_right,
                      color: AdminColors.mocha),
                  onTap: _changePassword,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.logout, color: AdminColors.red),
                  title: const Text('Logout',
                      style: TextStyle(color: AdminColors.red)),
                  onTap: _logout,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'HEER Beauty Salon Admin  •  v1.0.0',
              style: TextStyle(
                  fontSize: 12, color: AdminColors.mocha.withValues(alpha: 0.6)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
