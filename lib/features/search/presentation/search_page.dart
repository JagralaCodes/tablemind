import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app/core/widgets/custom_button.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _restaurants = [
    {
      'initials': 'NO',
      'name': 'Nobu New York',
      'cuisine': 'Japanese Contemporary',
      'distance': '0.3 mi',
      'rating': 4.9,
    },
    {
      'initials': 'LE',
      'name': 'Le Bernardin',
      'cuisine': 'French Seafood',
      'distance': '1.1 mi',
      'rating': 4.8,
    },
    {
      'initials': 'EL',
      'name': 'Eleven Madison Park',
      'cuisine': 'Modern American',
      'distance': '0.8 mi',
      'rating': 4.7,
    },
    {
      'initials': 'PE',
      'name': 'Per Se',
      'cuisine': 'French-American',
      'distance': '1.4 mi',
      'rating': 4.8,
    },
    {
      'initials': 'DA',
      'name': 'Daniel',
      'cuisine': 'Contemporary French',
      'distance': '2.1 mi',
      'rating': 4.7,
    },
    {
      'initials': 'GR',
      'name': 'Gramercy Tavern',
      'cuisine': 'American Seasonal',
      'distance': '0.6 mi',
      'rating': 4.6,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header / App Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      size: 28,
                      color: Colors.black,
                    ),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "GOOGLE BUSINESS",
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 1.8,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "Find a Restaurant",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Search input and action row
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: TextField(
                            controller: _searchController,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: Colors.grey.shade400,
                                size: 24,
                              ),
                              hintText: "Name or cuisine..",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade300,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CustomButton(
                        text: "SEARCH",
                        onTap: () {
                          // Handle Search Action
                        },
                        width: 90,
                        height: 48,
                        fontSize: 10,
                        letterSpacing: 1.5,
                        borderRadius: BorderRadius.zero,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Location Indicator
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.grey.shade400,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "New York, NY — Near you",
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(color: Colors.black12, thickness: 0.8, height: 24),
            ),

            // Popular section title
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                top: 8.0,
                bottom: 12.0,
              ),
              child: Text(
                "POPULAR NEARBY",
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.8,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Scrollable List of Restaurants
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                itemCount: _restaurants.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.black12,
                  thickness: 0.8,
                  height: 24,
                ),
                itemBuilder: (context, index) {
                  final rest = _restaurants[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Initials Box
                        Container(
                          width: 52,
                          height: 52,
                          color: Colors.grey.shade100,
                          alignment: Alignment.center,
                          child: Text(
                            rest['initials'],
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Details Column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rest['name'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${rest['cuisine']} · ${rest['distance']}",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Rating star + score
                        Row(
                          children: [
                            Icon(
                              Icons.star_border_rounded,
                              color: Colors.grey.shade400,
                              size: 16,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              rest['rating'].toString(),
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
