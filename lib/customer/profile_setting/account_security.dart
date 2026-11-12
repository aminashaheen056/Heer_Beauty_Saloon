
import 'package:flutter/material.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() =>
      _AccountSecurityScreenState();
}

class _AccountSecurityScreenState
    extends State<AccountSecurityScreen> {
  final _formKey = GlobalKey<FormState>();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool hideCurrentPassword = true;
  bool hideNewPassword = true;
  bool hideConfirmPassword = true;

  final Color cream = const Color(0xFFFFF8F0);
  final Color blushPink = const Color(0xFFE8A6B7);
  final Color mocha = const Color(0xFF6F4E37);

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Widget passwordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: mocha),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: mocha,
          ),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: blushPink, width: 2),
        ),
      ),
    );
  }

  void savePassword() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password details validated successfully!',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        title: const Text('Account Security'),
        backgroundColor: blushPink,
        foregroundColor: mocha,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Icon(
                  Icons.lock_outline,
                  size: 65,
                  color: mocha,
                ),
              ),

              const SizedBox(height: 15),

              Center(
                child: Text(
                  'Keep Your Account Secure',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: mocha,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: Text(
                  'Update your password to protect your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: mocha),
                ),
              ),

              const SizedBox(height: 30),

              Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: mocha,
                ),
              ),

              const SizedBox(height: 18),

              passwordField(
                label: 'Current Password',
                controller: currentPasswordController,
                obscureText: hideCurrentPassword,
                onToggle: () {
                  setState(() {
                    hideCurrentPassword = !hideCurrentPassword;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter current password';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              passwordField(
                label: 'New Password',
                controller: newPasswordController,
                obscureText: hideNewPassword,
                onToggle: () {
                  setState(() {
                    hideNewPassword = !hideNewPassword;
                  });
                },
                validator: (value) {
                  if (value == null || value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              passwordField(
                label: 'Confirm New Password',
                controller: confirmPasswordController,
                obscureText: hideConfirmPassword,
                onToggle: () {
                  setState(() {
                    hideConfirmPassword = !hideConfirmPassword;
                  });
                },
                validator: (value) {
                  if (value != newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: savePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mocha,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
