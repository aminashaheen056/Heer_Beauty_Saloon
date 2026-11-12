import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';
import 'staff_login.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name =
  TextEditingController(text: AdminStore.adminName);
  late final TextEditingController _email =
  TextEditingController(text: AdminStore.adminEmail);
  late final TextEditingController _phone =
  TextEditingController(text: AdminStore.adminPhone);

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      AdminStore.adminName = _name.text.trim();
      AdminStore.adminEmail = _email.text.trim();
      AdminStore.adminPhone = _phone.text.trim();
    });
    FocusScope.of(context).unfocus();
    AdminUi.snack(context, 'Profile updated successfully');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.cream,
      appBar: AdminUi.appBar('My Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 110,
                  height: 110,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AdminColors.golden, width: 2),
                  ),
                  child: ClipOval(
                    child: Image.asset('assets/images/logo.png',
                        fit: BoxFit.contain),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AdminStore.adminName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AdminColors.mocha,
                ),
              ),
              const SizedBox(height: 4),
              Center(child: AdminUi.statusChip('Administrator')),
              const SizedBox(height: 24),
              AdminUi.sectionTitle('Personal Information'),
              AdminUi.field(_name, 'Full name',
                  icon: Icons.person_outline,
                  validator: AdminUi.validateRequired),
              AdminUi.field(_email, 'Email address',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: AdminUi.validateEmail),
              AdminUi.field(_phone, 'Phone number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: AdminUi.validateRequired),
              const SizedBox(height: 4),
              AdminUi.primaryButton('SAVE CHANGES', _save, icon: Icons.save),
              const SizedBox(height: 12),
              SizedBox(
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: _changePassword,
                  icon: const Icon(Icons.lock_reset),
                  label: const Text('Change Password'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AdminColors.mocha,
                    side: const BorderSide(color: AdminColors.golden),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AdminColors.red,
                    side: const BorderSide(color: AdminColors.red),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
