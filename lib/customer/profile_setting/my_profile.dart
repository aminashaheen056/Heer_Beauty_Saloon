
import 'package:flutter/material.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final Color cream = const Color(0xFFFFF8F0);
  final Color blushPink = const Color(0xFFE8A6B7);
  final Color mocha = const Color(0xFF6F4E37);
  final Color softBeige = const Color(0xFFE8DCCB);

  final nameController =
  TextEditingController(text: 'Amina');
  final emailController =
  TextEditingController(text: 'amina@gmail.com');
  final phoneController =
  TextEditingController(text: '03001234567');

  final addressController =
  TextEditingController(text: 'Lahore, Pakistan');

  bool isEditing = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Widget profileField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        readOnly: !isEditing,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: mocha),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: softBeige),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: softBeige),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: blushPink, width: 2),
          ),
        ),
      ),
    );
  }

  void saveProfile() {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
        ),
      );
      return;
    }

    setState(() {
      isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,

      appBar: AppBar(
        title: Text(
          'My Profile',
          style: TextStyle(
            color: mocha,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: blushPink,
        foregroundColor: mocha,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isEditing ? Icons.close : Icons.edit,
              color: mocha,
            ),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 15),

            // Profile Picture
            CircleAvatar(
              radius: 55,
              backgroundColor: softBeige,
              child: Icon(
                Icons.person,
                size: 65,
                color: mocha,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              nameController.text,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: mocha,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              emailController.text,
              style: TextStyle(
                color: mocha,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 30),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: mocha,
                ),
              ),
            ),

            const SizedBox(height: 18),

            profileField(
              label: 'Full Name',
              controller: nameController,
              icon: Icons.person_outline,
            ),

            profileField(
              label: 'Email Address',
              controller: emailController,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),

            profileField(
              label: 'Phone Number',
              controller: phoneController,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),

            profileField(
              label: 'Address',
              controller: addressController,
              icon: Icons.location_on_outlined,
            ),

            const SizedBox(height: 10),

            if (isEditing)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: saveProfile,
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

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
