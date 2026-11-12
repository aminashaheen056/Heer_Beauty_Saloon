
import 'package:flutter/material.dart';

class SearchServiceScreen extends StatefulWidget {
  final List<Map<String, dynamic>> services;

  const SearchServiceScreen({
    super.key,
    required this.services,
  });

  @override
  State<SearchServiceScreen> createState() =>
      _SearchServiceScreenState();
}

class _SearchServiceScreenState
    extends State<SearchServiceScreen> {

  static const Color cream = Color(0xFFFFF7F0);
  static const Color gold = Color(0xFFC9913D);
  static const Color blushPink = Color(0xFFD88C95);
  static const Color mocha = Color(0xFF49352E);

  final TextEditingController searchController =
  TextEditingController();

  String searchQuery = '';

  List<Map<String, dynamic>> get filteredServices {
    if (searchQuery.trim().isEmpty) {
      return [];
    }

    return widget.services.where((service) {
      final name =
          service['name']?.toString().toLowerCase() ?? '';

      final category =
          service['category']?.toString().toLowerCase() ?? '';

      final query = searchQuery.toLowerCase().trim();

      return name.contains(query) || category.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,

      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,

        // Back Button
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: mocha,
          ),
        ),

        title: const Text(
          'Search Services',
          style: TextStyle(
            color: mocha,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(18),

            child: TextField(
              controller: searchController,

              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },

              decoration: InputDecoration(
                hintText: 'Search beauty services...',
                hintStyle: TextStyle(
                  color: mocha.withOpacity(0.55),
                  fontSize: 14,
                ),

                prefixIcon: const Icon(
                  Icons.search,
                  color: gold,
                ),

                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                  onPressed: () {
                    searchController.clear();

                    setState(() {
                      searchQuery = '';
                    });
                  },
                  icon: const Icon(
                    Icons.close,
                    color: mocha,
                  ),
                )
                    : null,

                filled: true,
                fillColor: Colors.white,

                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color(0xFFE8DCCB),
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: gold,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          // Search Results
          Expanded(
            child: searchQuery.isEmpty
                ? _buildInitialMessage()
                : filteredServices.isEmpty
                ? _buildNoResults()
                : ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
              ),

              itemCount: filteredServices.length,

              itemBuilder: (context, index) {
                final service =
                filteredServices[index];

                return _buildServiceCard(service);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Initial Message
  Widget _buildInitialMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              Icons.search_rounded,
              size: 80,
              color: blushPink,
            ),

            const SizedBox(height: 18),

            const Text(
              'Find Your Perfect Service',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: mocha,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Search for your favourite beauty services.',
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

  // No Results Message
  Widget _buildNoResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              Icons.search_off,
              size: 75,
              color: blushPink,
            ),

            const SizedBox(height: 18),

            const Text(
              'No Services Found!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: mocha,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Try searching with another service name.',
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

  // Service Card
  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE8DCCB),
        ),
        boxShadow: [
          BoxShadow(
            color: mocha.withOpacity(0.06),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [

          Container(
            width: 60,
            height: 60,

            decoration: BoxDecoration(
              color: blushPink.withOpacity(0.18),
              borderRadius: BorderRadius.circular(13),
            ),

            child: Icon(
              service['icon'] is IconData
                  ? service['icon'] as IconData
                  : Icons.spa_outlined,
              color: mocha,
              size: 30,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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

                const SizedBox(height: 6),

                Text(
                  'Rs. ${service['price']}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: gold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
