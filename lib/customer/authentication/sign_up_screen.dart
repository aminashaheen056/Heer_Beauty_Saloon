
import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool agreeToTerms = false;

  // HEER Colors
  static const Color cream = Color(0xFFFFF8F0);
  static const Color blushPink = Color(0xFFE8A6B7);
  static const Color mocha = Color(0xFF6F4E37);
  static const Color golden = Color(0xFFD4AF37);
  static const Color softBeige = Color(0xFFE8DCCB);

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Input Decoration
  InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: golden),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 17,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: softBeige),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: softBeige),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: blushPink,
          width: 2,
        ),
      ),
    );
  }

  // Signup Function
  void signUp() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please accept the Terms and Conditions',
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Account created successfully! Welcome to HEER.',
        ),
        backgroundColor: mocha,
      ),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,

      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior.onDrag,

          padding: const EdgeInsets.all(24),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // Back Arrow
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: mocha,
                      size: 27,
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                // HEER Beauty Salon Logo
                const Center(
                  child: Image(
                    image: AssetImage(
                      'assets/images/logo.png',
                    ),
                    width: 250,
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                ),

                // Create Account Heading
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: mocha,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Join HEER Beauty Salon and experience beauty.',
                  style: TextStyle(
                    fontSize: 13,
                    color: mocha,
                  ),
                ),

                const SizedBox(height: 25),

                // Full Name
                const Text(
                  'Full Name',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: mocha,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: nameController,

                  decoration: inputDecoration(
                    hint: 'Enter your full name',
                    icon: Icons.person_outline,
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }

                    if (value.trim().length < 3) {
                      return 'Name must contain at least 3 characters';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // Email
                const Text(
                  'Email Address',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: mocha,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,

                  decoration: inputDecoration(
                    hint: 'Enter your email',
                    icon: Icons.email_outlined,
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }

                    if (!RegExp(
                      r'^[\w.-]+@[\w.-]+\.[A-Za-z]{2,}$',
                    ).hasMatch(value.trim())) {
                      return 'Enter a valid email address';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // Phone Number
                const Text(
                  'Phone Number',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: mocha,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,

                  decoration: inputDecoration(
                    hint: '03XXXXXXXXX',
                    icon: Icons.phone_outlined,
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your phone number';
                    }

                    if (!RegExp(
                      r'^(03\d{9}|\+923\d{9})$',
                    ).hasMatch(value.trim())) {
                      return 'Enter a valid Pakistani phone number';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // Password
                const Text(
                  'Password',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: mocha,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword,

                  decoration: inputDecoration(
                    hint: 'Create password',
                    icon: Icons.lock_outline,

                    suffix: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: golden,
                      ),

                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please create a password';
                    }

                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }

                    if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
                      return 'Include at least one alphabet';
                    }

                    if (!RegExp(r'[0-9]').hasMatch(value)) {
                      return 'Include at least one number';
                    }

                    if (!RegExp(
                      r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\/~`;]',
                    ).hasMatch(value)) {
                      return 'Include at least one special character';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // Confirm Password
                const Text(
                  'Confirm Password',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: mocha,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirmPassword,

                  decoration: inputDecoration(
                    hint: 'Confirm your password',
                    icon: Icons.lock_reset_outlined,

                    suffix: IconButton(
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
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }

                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 15),

                // Terms and Conditions
                Row(
                  children: [
                    Checkbox(
                      value: agreeToTerms,
                      activeColor: blushPink,

                      onChanged: (value) {
                        setState(() {
                          agreeToTerms = value ?? false;
                        });
                      },
                    ),

                    const Expanded(
                      child: Text(
                        'I agree to the Terms and Conditions',
                        style: TextStyle(
                          fontSize: 13,
                          color: mocha,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton(
                    onPressed: signUp,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: blushPink,
                      foregroundColor: Colors.white,
                      elevation: 2,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    child: const Text(
                      'CREATE ACCOUNT',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Login Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(color: mocha),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: blushPink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
