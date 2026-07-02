import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LinkMenuBottomSheet extends StatefulWidget {
  const LinkMenuBottomSheet({super.key});

  @override
  State<LinkMenuBottomSheet> createState() => _LinkMenuBottomSheetState();
}

class _LinkMenuBottomSheetState extends State<LinkMenuBottomSheet> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final Color mainBg = _isPressed ? Colors.white : Colors.black;
    final Color mainFg = _isPressed ? Colors.black : Colors.white;

    return DraggableScrollableSheet(
      initialChildSize: 0.25,
      minChildSize: 0.2,
      snap: true,
      snapSizes: const [0.25, 0.5, 0.92],
      // This enables native smooth dragging from anywhere in the sheet
      builder: (context, scrollController) {
        return Material(
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: const BoxDecoration(color: Colors.white),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- THE DRAG HANDLE ---
                  Center(
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

                  // Header
                  const SizedBox(height: 16),
                  Text(
                    "PASTE MENU LINK",
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 2.2,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Flexible(
                        child: TextField(
                          cursorColor: Colors.black,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                            hintText: "https://restaurant.com/menu",
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade400,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 18,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.zero,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          // Handle GO action
                        },
                        onTapDown: (_) => setState(() => _isPressed = true),
                        onTapUp: (_) => setState(() => _isPressed = false),
                        onTapCancel: () => setState(() => _isPressed = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 120),
                          curve: Curves.easeInOut,
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: mainBg,
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 120),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                              child: Text(
                                "GO",
                                style: TextStyle(color: mainFg),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ), // Column
            ), // SingleChildScrollView
          ), // Container
        ); // Material
      },
    );
  }
}
