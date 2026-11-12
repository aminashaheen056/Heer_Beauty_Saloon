
import 'package:flutter/material.dart';
import 'offer_screen.dart';

class GalleryColors {
  static const Color cream = Color(0xFFFFF8F0);
  static const Color blushPink = Color(0xFFE8A6B7);
  static const Color white = Color(0xFFFFFFFF);
  static const Color mocha = Color(0xFF6F4E37);
  static const Color golden = Color(0xFFD4AF37);
  static const Color softBeige = Color(0xFFE8DCCB);
}

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {

  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Hair',
    'Makeup',
    'Nails',
    'Skin',
  ];

  final List<Map<String, String>> galleryImages = [
    {
      'image': 'assets/images/hair.jpg',
      'category': 'Hair',
      'title': 'Elegant Hair Styling',
    },
    {
      'image': 'assets/images/hair2.jpg',
      'category': 'Hair',
      'title': 'Bridal Hairstyle',
    },
    {
      'image': 'assets/images/makeup.jpg',
      'category': 'Makeup',
      'title': 'Party Makeup',
    },
    {
      'image': 'assets/images/party_makup.jpg',
      'category': 'Makeup',
      'title': 'Bridal Makeup',
    },
    {
      'image': 'assets/images/nail1.jpg',
      'category': 'Nails',
      'title': 'Nail Art Design',
    },
    {
      'image': 'assets/images/nail4.jpg',
      'category': 'Nails',
      'title': 'Elegant Nail Art',
    },
    {
      'image': 'assets/images/facial.jpg',
      'category': 'Skin',
      'title': 'Facial Treatment',
    },
    {
      'image': 'assets/images/facial1.jpg',
      'category': 'Skin',
      'title': 'Skin Care',
    },
  ];

  List<Map<String, String>> get filteredImages {
    if (selectedCategory == 'All') {
      return galleryImages;
    }

    return galleryImages
        .where((image) => image['category'] == selectedCategory)
        .toList();
  }

  // Image Preview Dialog
  void showImagePreview(
      BuildContext context,
      Map<String, String> image,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: GalleryColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),

          child: Padding(
            padding: const EdgeInsets.all(12),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(12),

                  child: Image.asset(
                    image['image']!,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  image['title']!,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: GalleryColors.mocha,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  image['category']!,
                  style: const TextStyle(
                    color: GalleryColors.golden,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: GalleryColors.blushPink,
                    foregroundColor: GalleryColors.white,
                  ),

                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Navigate to Offers Screen
  void openOffers() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OfferScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: GalleryColors.cream,

      appBar: AppBar(
        backgroundColor: GalleryColors.cream,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          'Our Gallery',
          style: TextStyle(
            color: GalleryColors.mocha,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // Gallery Banner
            ClipRRect(
              borderRadius: BorderRadius.circular(15),

              child: Image.asset(
                'assets/images/saloon-banner.png',
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Discover Our Beauty Work',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: GalleryColors.mocha,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Explore our latest hairstyles, makeup looks, '
                  'nail art and skincare treatments.',
              style: TextStyle(
                fontSize: 13,
                color: GalleryColors.mocha,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 25),

            // Special Offers Heading
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [

                const Text(
                  'Special Offers',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: GalleryColors.mocha,
                  ),
                ),

                TextButton(
                  onPressed: openOffers,

                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: GalleryColors.mocha,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Special Offers Banner
            GestureDetector(
              onTap: openOffers,

              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),

                child: Stack(
                  children: [

                    Image.asset(
                      'assets/images/bridal2.jpg',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),

                    Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.35),

                      padding: const EdgeInsets.all(18),

                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [

                          Text(
                            'Special Beauty Deals',
                            style: TextStyle(
                              color: GalleryColors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            'Enjoy exclusive salon discounts!',
                            style: TextStyle(
                              color: GalleryColors.white,
                              fontSize: 13,
                            ),
                          ),

                          SizedBox(height: 10),

                          Text(
                            'Explore Offers →',
                            style: TextStyle(
                              color: GalleryColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Gallery Heading
            const Text(
              'Our Work',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: GalleryColors.mocha,
              ),
            ),

            const SizedBox(height: 15),

            // Category Filters
            SizedBox(
              height: 42,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,

                itemBuilder: (context, index) {

                  String category = categories[index];

                  bool isSelected =
                      selectedCategory == category;

                  return Padding(
                    padding: const EdgeInsets.only(right: 10),

                    child: ChoiceChip(
                      label: Text(category),

                      selected: isSelected,

                      selectedColor: GalleryColors.blushPink,

                      backgroundColor: GalleryColors.white,

                      labelStyle: TextStyle(
                        color: GalleryColors.mocha,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),

                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            // Gallery Images Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              itemCount: filteredImages.length,

              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),

              itemBuilder: (context, index) {

                final image = filteredImages[index];

                return GestureDetector(
                  onTap: () {
                    showImagePreview(context, image);
                  },

                  child: Container(
                    decoration: BoxDecoration(
                      color: GalleryColors.white,
                      borderRadius: BorderRadius.circular(12),

                      border: Border.all(
                        color: GalleryColors.softBeige,
                      ),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(11),
                            ),

                            child: Image.asset(
                              image['image']!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(10),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [

                              Text(
                                image['title']!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,

                                style: const TextStyle(
                                  color: GalleryColors.mocha,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                image['category']!,
                                style: const TextStyle(
                                  color: GalleryColors.golden,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
