
import 'package:flutter/material.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const cream = Color(0xFFFFF8F0);
  static const blushPink = Color(0xFFE8A6B7);
  static const mocha = Color(0xFF6F4E37);
  static const golden = Color(0xFFD4AF37);
  static const softBeige = Color(0xFFE8DCCB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 35),

              // HEER Beauty Salon Logo
              Image.asset(
                'assets/images/logo.png',
                height: 350,
                width: 250,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 35),

              // Welcome Heading
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Welcome to HEER',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: mocha,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Description
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Discover your beauty with our professional '
                      'beauty services. Relax, refresh and feel beautiful!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: mocha,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Golden Decorative Line
              Container(
                height: 2,
                width: 80,
                color: golden,
              ),

              const SizedBox(height: 30),

              // Customer Get Started Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blushPink,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'GET STARTED',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Admin / Staff Login Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/staff-login');
                    },
                    icon: const Icon(Icons.admin_panel_settings_outlined),
                    label: const Text(
                      'ADMIN / STAFF LOGIN',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: mocha,
                      side: const BorderSide(
                        color: golden,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // Tagline
              const Text(
                'Your Beauty, Our Passion',
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: mocha,
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
