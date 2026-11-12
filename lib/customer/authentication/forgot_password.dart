
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController =
  TextEditingController();

  static const cream = Color(0xFFFFF8F0);
  static const blushPink = Color(0xFFE8A6B7);
  static const mocha = Color(0xFF6F4E37);
  static const golden = Color(0xFFD4AF37);
  static const softBeige = Color(0xFFE8DCCB);

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  // Send Reset Link
  void sendResetLink() {

    if (_formKey.currentState!.validate()) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Email validated! Connect Firebase to send reset link.',
          ),
          backgroundColor: mocha,
        ),
      );
    }
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

                const SizedBox(height: 20),

                // Logo Icon
                // Salon Logo
                const Image(
                  image: AssetImage('assets/images/logo.png'),
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),


                // Lock Icon Container
                Container(
                  height: 110,
                  width: 110,

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
                    size: 65,
                    color: golden,
                  ),
                ),

                const SizedBox(height: 30),

                // Heading
                const Text(
                  'Forgot Password?',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: mocha,
                  ),
                ),

                const SizedBox(height: 15),

                // Description
                const Text(
                  'No worries! Enter your registered email address '
                      'and we will send you instructions to reset '
                      'your password.',

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: mocha,
                  ),
                ),

                const SizedBox(height: 35),

                // Email Label
                const Align(
                  alignment: Alignment.centerLeft,

                  child: Text(
                    'Email Address',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: mocha,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Email Input
                TextFormField(
                  controller: emailController,

                  keyboardType: TextInputType.emailAddress,

                  decoration: InputDecoration(
                    hintText: 'Enter your registered email',

                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: golden,
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
                      return 'Please enter your email';
                    }

                    if (!RegExp(
                      r'^[\w.-]+@[\w.-]+\.[A-Za-z]{2,}$',
                    ).hasMatch(value.trim())) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // Send Reset Link Button
                SizedBox(
                  height: 55,
                  width: double.infinity,

                  child: ElevatedButton(

                    onPressed: sendResetLink,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: blushPink,
                      foregroundColor: Colors.white,
                      elevation: 2,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    child: const Text(
                      'SEND RESET LINK',

                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Back to Login
                TextButton.icon(

                  onPressed: () {
                    Navigator.pop(context);
                  },



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
