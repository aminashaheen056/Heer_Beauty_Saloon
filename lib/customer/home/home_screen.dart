
import 'package:flutter/material.dart';

// Home screens
import 'search_screen.dart';
import 'notification_screen.dart';
import 'favourite_services.dart';

// Service categories
import '../services/hair_services.dart';
import '../services/makeup_services.dart';
import '../services/nail_services.dart';
import '../services/skin_care.dart';

// Appointment screens
import '../appointment/book_appointment.dart';
import '../appointment/my_appointment_screen.dart';

// Gallery and offers
import '../gallery&offer/gallery_screen.dart';
import '../gallery&offer/offer_screen.dart';

// Finance screens
import '../finance/transaction_history.dart';

// Services packages
import '../services_packages/purchased_packages.dart';

// Profile and settings
import '../profile_setting/my_profile.dart';
import '../profile_setting/setting.dart';
import '../profile_setting/contact_us.dart';
import '../profile_setting/help_support_screen.dart';
import '../profile_setting/privacy_policy_screen.dart';
import '../profile_setting/about_screen.dart';

// Packages and beauticians
import '../services_packages/all_packages.dart';
import '../services/beautician_detail.dart';

// --------------------------------------------------
// APP COLORS
// --------------------------------------------------

class SalonColors {
  static const Color cream = Color(0xFFFFF8F0);
  static const Color blushPink = Color(0xFFE8A6B7);
  static const Color white = Color(0xFFFFFFFF);
  static const Color mocha = Color(0xFF6F4E37);
  static const Color golden = Color(0xFFD4AF37);
  static const Color softBeige = Color(0xFFE8DCCB);
}

// --------------------------------------------------
// HOME SCREEN
// --------------------------------------------------

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // --------------------------------------------------
  // SERVICES DATA FOR SEARCH AND FAVOURITES
  // --------------------------------------------------

  final List<Map<String, dynamic>> services = [
    {
      'name': 'Hair Styling',
      'price': 1500,
      'category': 'Hair',
      'image': 'assets/images/hair_styling.jpg',
    },
    {
      'name': 'Makeup',
      'price': 2500,
      'category': 'Makeup',
      'image': 'assets/images/makeup.jpg',
    },
    {
      'name': 'Nail Art',
      'price': 1200,
      'category': 'Nails',
      'image': 'assets/images/nail_art.jpg',
    },
    {
      'name': 'Facial Treatment',
      'price': 2000,
      'category': 'Skin',
      'image': 'assets/images/facial.jpg',
    },
  ];

  // --------------------------------------------------
  // BEAUTICIANS DATA
  // --------------------------------------------------

  final List<Map<String, String>> beauticians = [
    {
      'name': 'Sana Malik',
      'image': 'assets/images/hair2.jpg',
      'experience': '8 years',
      'specialization': 'Hair Styling & Hair Colour',
      'rating': '4.9',
      'description':
      'Sana creates modern cuts, layers and colour looks that suit your face and lifestyle.',
    },
    {
      'name': 'Ayesha Khan',
      'image': 'assets/images/bride.jpg',
      'experience': '10 years',
      'specialization': 'Bridal & Party Makeup',
      'rating': '4.9',
      'description':
      'Ayesha is our lead makeup artist and has styled hundreds of brides for their big day.',
    },
    {
      'name': 'Hira Noor',
      'image': 'assets/images/nail4.jpg',
      'experience': '5 years',
      'specialization': 'Nail Art & Manicure',
      'rating': '4.8',
      'description':
      'Hira loves detailed nail art, gel colours and relaxing manicure and pedicure sessions.',
    },
    {
      'name': 'Mehwish Ali',
      'image': 'assets/images/facial.jpg',
      'experience': '7 years',
      'specialization': 'Facials & Skin Care',
      'rating': '4.8',
      'description':
      'Mehwish specialises in deep cleansing, hydrating and brightening facials for glowing skin.',
    },
  ];

  Widget sectionHeader(String title, VoidCallback? onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: SalonColors.mocha,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: const Text(
              'See all',
              style: TextStyle(
                color: SalonColors.golden,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget imageTile(String image, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(image, fit: BoxFit.cover),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  color: SalonColors.mocha.withOpacity(0.75),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: SalonColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
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

  // --------------------------------------------------
  // CATEGORY NAVIGATION
  // --------------------------------------------------

  void openCategory(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  // --------------------------------------------------
  // CATEGORY CARD
  // --------------------------------------------------

  Widget categoryCard({
    required String title,
    required String image,
    required Widget screen,
  }) {
    return GestureDetector(
      onTap: () {
        openCategory(screen);
      },

      child: Container(
        decoration: BoxDecoration(
          color: SalonColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: SalonColors.mocha.withOpacity(0.10),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // CATEGORY IMAGE
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),

                child: Image.asset(
                  image,
                  width: double.infinity,
                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      color: SalonColors.softBeige,
                      child: const Icon(
                        Icons.image_outlined,
                        size: 45,
                        color: SalonColors.mocha,
                      ),
                    );
                  },
                ),
              ),
            ),

            // CATEGORY NAME
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 12,
              ),

              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: SalonColors.mocha,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: SalonColors.golden,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // DRAWER ITEM
  // --------------------------------------------------

  void openScreen(BuildContext drawerContext, Widget screen) {
    Navigator.pop(drawerContext);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  Widget drawerItem({
    required BuildContext drawerContext,
    required IconData icon,
    required String title,
    required Widget screen,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: SalonColors.mocha,
      ),

      title: Text(
        title,
        style: const TextStyle(
          color: SalonColors.mocha,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: SalonColors.mocha,
      ),

      onTap: () => openScreen(drawerContext, screen),
    );
  }

  // --------------------------------------------------
  // DRAWER SECTION TITLE
  // --------------------------------------------------

  Widget drawerSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        top: 12,
        bottom: 4,
      ),

      child: Text(
        title,
        style: const TextStyle(
          color: SalonColors.golden,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // --------------------------------------------------
  // BUILD METHOD
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SalonColors.cream,

      // --------------------------------------------------
      // DRAWER
      // --------------------------------------------------

      drawer: Builder(
        builder: (drawerContext) {
          return Drawer(
            backgroundColor: SalonColors.cream,

            child: SafeArea(
              child: Column(
                children: [

                  // DRAWER HEADER
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 25,
                      horizontal: 20,
                    ),

                    decoration: const BoxDecoration(
                      color: SalonColors.blushPink,
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        CircleAvatar(
                          radius: 38,
                          backgroundColor: SalonColors.white,
                          backgroundImage:
                          const AssetImage('assets/images/logo.png'),
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          'Welcome to HEER',
                          style: TextStyle(
                            color: SalonColors.mocha,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        const Text(
                          'Beauty Salon',
                          style: TextStyle(
                            color: SalonColors.mocha,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // DRAWER OPTIONS
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [

                        drawerSectionTitle('ACCOUNT'),

                        drawerItem(
                          drawerContext: drawerContext,
                          icon: Icons.person_outline,
                          title: 'My Profile',
                          screen: const MyProfileScreen(),
                        ),

                        drawerItem(
                          drawerContext: drawerContext,
                          icon: Icons.settings_outlined,
                          title: 'Settings',
                          screen: const SettingScreen(),
                        ),

                        const Divider(
                          color: SalonColors.softBeige,
                        ),

                        drawerSectionTitle('PAYMENTS & PACKAGES'),

                        drawerItem(
                          drawerContext: drawerContext,
                          icon: Icons.history,
                          title: 'Payment History',
                          screen: const TransactionHistoryScreen(),
                        ),

                        drawerItem(
                          drawerContext: drawerContext,
                          icon: Icons.local_offer_outlined,
                          title: 'Beauty Packages',
                          screen: AllPackagesScreen(),
                        ),

                        drawerItem(
                          drawerContext: drawerContext,
                          icon: Icons.card_giftcard,
                          title: 'My Purchased Packages',
                          screen: const PurchasedPackagesScreen(),
                        ),

                        const Divider(
                          color: SalonColors.softBeige,
                        ),

                        drawerSectionTitle('MORE'),

                        drawerItem(
                          drawerContext: drawerContext,
                          icon: Icons.phone_outlined,
                          title: 'Contact Us',
                          screen: const ContactUsScreen(),
                        ),

                        drawerItem(
                          drawerContext: drawerContext,
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          screen: const HelpSupportScreen(),
                        ),

                        drawerItem(
                          drawerContext: drawerContext,
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy',
                          screen: const PrivacyPolicyScreen(),
                        ),

                        drawerItem(
                          drawerContext: drawerContext,
                          icon: Icons.info_outline,
                          title: 'About Us',
                          screen: const AboutScreen(),
                        ),
                      ],
                    ),
                  ),

                  const Divider(
                    color: SalonColors.softBeige,
                  ),

                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'HEER Beauty Salon',
                      style: TextStyle(
                        color: SalonColors.mocha,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      // --------------------------------------------------
      // APP BAR
      // --------------------------------------------------

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: SalonColors.cream,
        elevation: 0,

        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: SalonColors.mocha,
              ),

              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),

        title: const Text(
          'HEER Beauty Salon',
          style: TextStyle(
            color: SalonColors.mocha,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),

        centerTitle: true,

        actions: [

          // FAVOURITES
          IconButton(
            icon: const Icon(
              Icons.favorite_border,
              color: SalonColors.mocha,
            ),

            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavouriteServicesScreen(
                    services: services,
                  ),
                ),
              );
            },
          ),

          // NOTIFICATIONS
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: SalonColors.mocha,
            ),

            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
          ),
        ],
      ),

      // --------------------------------------------------
      // HOME BODY
      // --------------------------------------------------

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // GREETING
              const Text(
                'Hello, Beautiful!',
                style: TextStyle(
                  color: SalonColors.mocha,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Feel confident. Feel beautiful.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 20),

              // SEARCH BAR
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SearchServiceScreen(services: services),
                    ),
                  );
                },

                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 14,
                  ),

                  decoration: BoxDecoration(
                    color: SalonColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: SalonColors.softBeige,
                    ),
                  ),

                  child: const Row(
                    children: [

                      Icon(
                        Icons.search,
                        color: SalonColors.mocha,
                      ),

                      SizedBox(width: 10),

                      Text(
                        'Search for services...',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),

                      Spacer(),

                      Icon(
                        Icons.tune,
                        color: SalonColors.mocha,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // SPECIAL OFFER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: SalonColors.blushPink,
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const Text(
                            'SPECIAL OFFER',
                            style: TextStyle(
                              color: SalonColors.mocha,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            'Get 20% OFF',
                            style: TextStyle(
                              color: SalonColors.mocha,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const Text(
                            'On selected beauty services',
                            style: TextStyle(
                              color: SalonColors.mocha,
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 12),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: SalonColors.mocha,
                              foregroundColor: SalonColors.white,
                            ),

                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const OfferScreen(),
                                ),
                              );
                            },

                            child: const Text('View Offers'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 14),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        'assets/images/bridal2.jpg',
                        width: 100,
                        height: 135,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // --------------------------------------------------
              // SERVICE CATEGORIES
              // --------------------------------------------------

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Text(
                    'Explore Categories',
                    style: TextStyle(
                      color: SalonColors.mocha,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    '4 Categories',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // CATEGORY GRID
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.95,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                children: [

                  // HAIR CATEGORY
                  categoryCard(
                    title: 'Hair Services',
                    image: 'assets/images/hair_styling.jpg',
                    screen: const HairServices(),
                  ),

                  // MAKEUP CATEGORY
                  categoryCard(
                    title: 'Makeup Services',
                    image: 'assets/images/makeup.jpg',
                    screen: const MakeupServices(),
                  ),

                  // NAIL CATEGORY
                  categoryCard(
                    title: 'Nail Services',
                    image: 'assets/images/nail_art.jpg',
                    screen: const NailServices(),
                  ),

                  // SKIN CARE CATEGORY
                  categoryCard(
                    title: 'Skin Care',
                    image: 'assets/images/facial.jpg',
                    screen: const SkincareServices(),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // --------------------------------------------------
              // PACKAGES PREVIEW
              // --------------------------------------------------

              sectionHeader(
                'Beauty Packages',
                    () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllPackagesScreen(),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 170,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    imageTile(
                      'assets/images/bridal1.jpg',
                      'Bridal Glow',
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllPackagesScreen(),
                        ),
                      ),
                    ),
                    imageTile(
                      'assets/images/hair2.jpg',
                      'Hair Care',
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllPackagesScreen(),
                        ),
                      ),
                    ),
                    imageTile(
                      'assets/images/nail3.jpg',
                      'Nail Care',
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllPackagesScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // --------------------------------------------------
              // BEAUTICIANS
              // --------------------------------------------------

              sectionHeader('Meet Our Beauticians', null),

              const SizedBox(height: 12),

              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: beauticians.map((b) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BeauticianDetailScreen(
                              name: b['name']!,
                              image: b['image']!,
                              experience: b['experience']!,
                              specialization: b['specialization']!,
                              rating: b['rating']!,
                              description: b['description']!,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 88,
                        margin: const EdgeInsets.only(right: 14),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 38,
                              backgroundColor: SalonColors.softBeige,
                              backgroundImage: AssetImage(b['image']!),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              b['name']!.split(' ').first,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: SalonColors.mocha,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 25),

              // BOOK APPOINTMENT BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SalonColors.mocha,
                    foregroundColor: SalonColors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const BookAppointmentScreen(),
                      ),
                    );
                  },

                  child: const Text(
                    'Book an Appointment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // GALLERY PREVIEW
              const Text(
                'Our Beauty Gallery',
                style: TextStyle(
                  color: SalonColors.mocha,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Explore our salon work and beauty transformations.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    'assets/images/bridal2.jpg',
                    'assets/images/makeup.jpg',
                    'assets/images/nail4.jpg',
                    'assets/images/hair.jpg',
                  ].map((path) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GalleryScreen(),
                        ),
                      ),
                      child: Container(
                        width: 115,
                        margin: const EdgeInsets.only(right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(path, fit: BoxFit.cover),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,

                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: SalonColors.mocha,
                    side: const BorderSide(
                      color: SalonColors.blushPink,
                    ),
                  ),

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GalleryScreen(),
                      ),
                    );
                  },

                  child: const Text('View Our Gallery'),
                ),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),

      // --------------------------------------------------
      // BOTTOM NAVIGATION
      // --------------------------------------------------

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: SalonColors.white,
        selectedItemColor: SalonColors.mocha,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,

        onTap: (index) {

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyAppointmentScreen(),
              ),
            );
          }

          else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GalleryScreen(),
              ),
            );
          }

          else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyProfileScreen(),
              ),
            );
          }
        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Appointments',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library_outlined),
            label: 'Gallery',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
