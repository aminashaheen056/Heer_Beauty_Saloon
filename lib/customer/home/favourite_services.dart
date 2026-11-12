
import 'package:flutter/material.dart';

// Shared Favourite Services Manager
class FavouriteServices {
  static final ValueNotifier<Set<String>> favourites =
  ValueNotifier<Set<String>>({});

  // Add or remove a favourite service
  static void toggleFavourite(String serviceName) {
    final updatedFavourites =
    Set<String>.from(favourites.value);

    if (updatedFavourites.contains(serviceName)) {
      updatedFavourites.remove(serviceName);
    } else {
      updatedFavourites.add(serviceName);
    }

    favourites.value = updatedFavourites;
  }

  // Check whether a service is favourite
  static bool isFavourite(String serviceName) {
    return favourites.value.contains(serviceName);
  }
}

// Favourite Services Screen
class FavouriteServicesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> services;

  const FavouriteServicesScreen({
    super.key,
    required this.services,
  });

  static const Color cream = Color(0xFFFFF7F0);
  static const Color gold = Color(0xFFC9913D);
  static const Color blushPink = Color(0xFFD88C95);
  static const Color mocha = Color(0xFF49352E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,

      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: mocha),
        title: const Text(
          'My Favourites',
          style: TextStyle(
            color: mocha,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ValueListenableBuilder<Set<String>>(
        valueListenable: FavouriteServices.favourites,

        builder: (context, favouriteNames, child) {
          final favouriteList = services.where((service) {
            return favouriteNames.contains(
              service['name']?.toString(),
            );
          }).toList();

          if (favouriteList.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.favorite_border,
                      size: 85,
                      color: blushPink,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'No Favourites Yet!',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: mocha,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Add your favourite beauty services '
                          'and they will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: mocha,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(18),
            itemCount: favouriteList.length,

            itemBuilder: (context, index) {
              final service = favouriteList[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(15),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE8DCCB),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: mocha.withOpacity(0.07),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    // Service Icon
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        color: blushPink.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(
                        service['icon'] is IconData
                            ? service['icon'] as IconData
                            : Icons.spa_outlined,
                        size: 32,
                        color: mocha,
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Service Information
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            service['name']?.toString() ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: mocha,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            service['category']?.toString() ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              color: mocha.withOpacity(0.7),
                            ),
                          ),

                          const SizedBox(height: 7),

                          Text(
                            'Rs. ${service['price'] ?? ''}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: gold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            service['duration']?.toString() ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              color: mocha.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Remove Favourite Button
                    IconButton(
                      onPressed: () {
                        FavouriteServices.toggleFavourite(
                          service['name'].toString(),
                        );
                      },
                      icon: const Icon(
                        Icons.favorite,
                        color: blushPink,
                        size: 27,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
