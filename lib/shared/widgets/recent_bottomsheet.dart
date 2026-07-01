import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RecentBar extends StatelessWidget {
  const RecentBar({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Just opens the sheet
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black12, width: 1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history_rounded,
                  size: 14,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 6),
                Text(
                  "RECENT",
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 2.2,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.keyboard_arrow_up_rounded,
                  size: 18,
                  color: Colors.grey.shade500,
                ),
              ],
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Draggable bottom sheet — Recent items
// ─────────────────────────────────────────────────────────────────────────────
class RecentBottomSheet extends StatelessWidget {
  const RecentBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.25,
      maxChildSize: 0.92,
      snap: true,
      snapSizes: const [0.25, 0.5, 0.92],
      // This enables native smooth dragging from anywhere in the sheet
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.black, width: 1.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- THE DRAG HANDLE ---
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 4),
                  child: GestureDetector(
                    // IMPORTANT: Tells Flutter to capture drag events instantly
                    dragStartBehavior: DragStartBehavior.down,
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.history_rounded,
                      size: 16,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "RECENT",
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 2.2,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Colors.black12),

              // Items
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _demoItems.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: Colors.black12),
                  itemBuilder: (context, index) {
                    final item = _demoItems[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 4,
                      ),
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12, width: 1),
                          color: Colors.grey.shade50,
                        ),
                        child: Icon(item.icon, size: 20, color: Colors.black54),
                      ),
                      title: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        item.subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      trailing: Text(
                        item.time,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Demo data
class _RecentItem {
  const _RecentItem(this.icon, this.title, this.subtitle, this.time);
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
}

const _demoItems = [
  _RecentItem(
    Icons.camera_alt_outlined,
    "Pizza Palace Menu",
    "Uploaded via Camera",
    "2h ago",
  ),
  _RecentItem(
    Icons.link_rounded,
    "Burger Barn",
    "Scanned from link",
    "Yesterday",
  ),
  _RecentItem(
    Icons.search_rounded,
    "Sushi World",
    "Restaurant search",
    "2d ago",
  ),
  _RecentItem(
    Icons.upload_file_outlined,
    "Taco Town Menu.pdf",
    "PDF Upload",
    "3d ago",
  ),
  _RecentItem(
    Icons.camera_alt_outlined,
    "Green Garden",
    "Uploaded via Camera",
    "5d ago",
  ),
];
