
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends State<ResetPasswordScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController newPasswordController =
  TextEditingController();

  final TextEditingController confirmPasswordController =
  TextEditingController();

  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;

  // HEER Color Theme
  static const cream = Color(0xFFFFF8F0);
  static const blushPink = Color(0xFFE8A6B7);
  static const mocha = Color(0xFF6F4E37);
  static const golden = Color(0xFFD4AF37);
  static const softBeige = Color(0xFFE8DCCB);

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Password Validation
  String? validatePassword(String? value) {

    if (value == null || value.isEmpty) {
      return 'Please enter a new password';
    }

    if (value.length < 8) {
      return 'Password must contain at least 8 characters';
    }

    if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
      return 'Password must contain an alphabet';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain a number';
    }

    if (!RegExp(
        r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\\/;~`]'
    ).hasMatch(value)) {
      return 'Password must contain a special character';
    }

    return null;
  }

  // Update Password Function
  void updatePassword() {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Password validated successfully!',
        ),
        backgroundColor: mocha,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: cream,

      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: mocha,
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(

          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 20,
          ),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [

                const SizedBox(height: 15),

                // Salon Logo
                const Image(
                  image: AssetImage('assets/images/logo.png'),
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 10),

                const Text(
                  'HEER',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 7,
                    color: mocha,
                  ),
                ),

                const Text(
                  'BEAUTY SALON',
                  style: TextStyle(
                    fontSize: 13,
                    letterSpacing: 3,
                    color: mocha,
                  ),
                ),

                const SizedBox(height: 40),

                // Lock Icon
                Container(
                  height: 105,
                  width: 105,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: softBeige,
                      width: 2,
                    ),
                  ),

                  child: const Icon(
                    Icons.lock_reset,
                    size: 60,
                    color: golden,
                  ),
                ),

                const SizedBox(height: 25),

                // Heading
                const Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: mocha,
                  ),
                ),

                const SizedBox(height: 12),

                // Description
                const Text(
                  'Create a strong new password for your '
                      'HEER Beauty Salon account.',

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: mocha,
                  ),
                ),

                const SizedBox(height: 30),

                // New Password Label
                const Align(
                  alignment: Alignment.centerLeft,

                  child: Text(
                    'New Password',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: mocha,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // New Password Field
                TextFormField(
                  controller: newPasswordController,
                  obscureText: obscureNewPassword,

                  decoration: InputDecoration(
                    hintText: 'Enter new password',

                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: golden,
                    ),

                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureNewPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: golden,
                      ),

                      onPressed: () {
                        setState(() {
                          obscureNewPassword =
                          !obscureNewPassword;
                        });
                      },
                    ),

                    filled: true,
                    fillColor: Colors.white,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: softBeige,
                      ),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: softBeige,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: blushPink,
                        width: 2,
                      ),
                    ),
                  ),

                  validator: validatePassword,
                ),

                const SizedBox(height: 22),

                // Confirm Password Label
                const Align(
                  alignment: Alignment.centerLeft,

                  child: Text(
                    'Confirm Password',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: mocha,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Confirm Password Field
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirmPassword,

                  decoration: InputDecoration(
                    hintText: 'Confirm new password',

                    prefixIcon: const Icon(
                      Icons.lock_reset,
                      color: golden,
                    ),

                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: golden,
                      ),

                      onPressed: () {
                        setState(() {
                          obscureConfirmPassword =
                          !obscureConfirmPassword;
                        });
                      },
                    ),

                    filled: true,
                    fillColor: Colors.white,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: softBeige,
                      ),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: softBeige,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: blushPink,
                        width: 2,
                      ),
                    ),
                  ),

                  validator: (value) {

                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }

                    if (value != newPasswordController.text) {
                      return 'Passwords do not match';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // Update Password Button
                SizedBox(
                  height: 55,
                  width: double.infinity,

                  child: ElevatedButton(

                    onPressed: updatePassword,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: blushPink,
                      foregroundColor: Colors.white,
                      elevation: 2,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    child: const Text(
                      'UPDATE PASSWORD',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Back to Login
                TextButton.icon(

                  onPressed: () {
                    Navigator.popUntil(
                      context,
                          (route) => route.isFirst,
                    );
                  },

                  icon: const Icon(
                    Icons.arrow_back,
                    color: mocha,
                  ),

                  label: const Text(
                    'Back to Login',
                    style: TextStyle(
                      color: mocha,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Your Beauty, Our Passion',
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: mocha,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
