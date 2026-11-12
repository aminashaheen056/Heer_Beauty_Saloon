import 'package:flutter/material.dart';
import 'package:heer_beauty_saloon/customer/authentication/welcome_screen.dart';

import 'admin/admin_authentication/staff_login.dart';
// import 'customer/authentication/login_screen.dart';
// import 'customer/authentication/sign_up_screen.dart';
// import 'customer/authentication/forgot_password.dart';
// import 'customer/authentication/reset-password.dart';
// import 'customer/home/home_screen.dart';

void main() {
  runApp(const HeerBeautySalon());
}

class HeerBeautySalon extends StatelessWidget {
  const HeerBeautySalon({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'HEER Beauty Salon',

      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFF8F0),

        primaryColor: const Color(0xFFE8A6B7),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE8A6B7),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFF8F0),
          foregroundColor: Color(0xFF6F4E37),
          elevation: 0,
        ),

        useMaterial3: true,
      ),

      // First screen of application
      home: const WelcomeScreen(),
      routes: {
        '/staff-login': (context) => const StaffLoginScreen(),
      },
    );
  }
}
