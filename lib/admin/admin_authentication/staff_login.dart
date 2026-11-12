import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';
import 'dashboard.dart';

/// Logs the admin out and returns to the staff login screen.
void adminLogout(BuildContext context) {
  AdminStore.loggedIn = false;
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const StaffLoginScreen()),
        (route) => false,
  );
}

class StaffLoginScreen extends StatefulWidget {
  const StaffLoginScreen({super.key});

  @override
  State<StaffLoginScreen> createState() => _StaffLoginScreenState();
}

class _StaffLoginScreenState extends State<StaffLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    final emailOk =
        _email.text.trim().toLowerCase() == AdminStore.adminEmail.toLowerCase();
    final passOk = _password.text == AdminStore.adminPassword;

    if (!emailOk || !passOk) {
      AdminUi.snack(context, 'Invalid email or password');
      return;
    }

    AdminStore.loggedIn = true;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AdminDashboard()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.cream,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AdminColors.golden, width: 1.5),
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Staff & Admin Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AdminColors.mocha,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Sign in to manage HEER Beauty Salon',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AdminColors.mocha.withValues(alpha: 0.75),
                    ),
                  ),
                  const SizedBox(height: 28),
                  AdminUi.field(
                    _email,
                    'Email address',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: AdminUi.validateEmail,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextFormField(
                      controller: _password,
                      obscureText: _obscure,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Please enter your password'
                          : null,
                      decoration:
                      AdminUi.inputDecoration('Password', icon: Icons.lock_outline)
                          .copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure ? Icons.visibility_off : Icons.visibility,
                            color: AdminColors.golden,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  AdminUi.primaryButton('LOGIN', _login, icon: Icons.login),
                  const SizedBox(height: 18),

                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () {
                      if (Navigator.canPop(context)) Navigator.pop(context);
                    },

                    label: const Text('Back to customer login'),
                    style: TextButton.styleFrom(
                      foregroundColor: AdminColors.blushPink,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
