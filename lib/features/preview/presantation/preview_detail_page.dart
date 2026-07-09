import 'package:flutter/material.dart';

import '../../../shared/entities/menu_entity.dart';

/// Displays the structured [Menu] produced by the Processing screen,
/// grouped by category. Pure `StatelessWidget` — this screen only reads
/// data it's handed via the constructor, no Riverpod state of its own.
class PreviewScreen extends StatelessWidget {
  final Menu menu;

  const PreviewScreen({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    final categories = menu.categories;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TABLEMIND',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${menu.items.length} items found',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // TODO: wire to your Chat feature once it's built,
                      // e.g. context.push(AppRoutes.chat, extra: menu);
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: menu.items.isEmpty
                  ? const Center(
                      child: Text(
                        'No items were found in this scan.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, categoryIndex) {
                        final category = categories[categoryIndex];
                        final items = menu.itemsInCategory(category);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                                bottom: 8,
                              ),
                              child: Text(
                                category.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            ...items.map((item) => _MenuItemTile(item: item)),
                          ],
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

class _MenuItemTile extends StatelessWidget {
  final MenuItem item;

  const _MenuItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                if (item.description != null &&
                    item.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.description!,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          // A price might genuinely be missing (a standalone price line
          // that never got matched, or a menu item priced "Market Rate")
          // — show that honestly instead of a fake "0" or a crash.
          Text(
            item.price != null
                ? '${item.currencySymbol.isNotEmpty ? item.currencySymbol : '₹'}${item.price!.toStringAsFixed(0)}'
                : '—',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
