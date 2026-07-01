import 'package:flutter/material.dart';

class SplitActionButton extends StatefulWidget {
  final String mainLabel;
  final String? subLabel;
  final IconData mainIcon;
  final IconData rightIcon;
  final VoidCallback onMainTap;
  final VoidCallback onRightTap;

  const SplitActionButton({
    super.key,
    required this.mainLabel,
    this.subLabel,
    required this.mainIcon,
    required this.rightIcon,
    required this.onMainTap,
    required this.onRightTap,
  });

  @override
  State<SplitActionButton> createState() => _SplitActionButtonState();
}

class _SplitActionButtonState extends State<SplitActionButton> {
  // Track which side is currently being touched/pressed
  bool _isMainPressed = false;
  bool _isRightPressed = false;

  @override
  Widget build(BuildContext context) {
    // --- COLORS FOR LEFT SIDE ---
    final Color mainBg = _isMainPressed ? Colors.black : Colors.white;
    final Color mainFg = _isMainPressed ? Colors.white : Colors.black;

    // --- COLORS FOR RIGHT SIDE ---
    final Color rightBg = _isRightPressed ? Colors.black : Colors.white;
    final Color rightFg = _isRightPressed ? Colors.white : Colors.black;

    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Row(
        children: [
          // --- 80% LEFT SIDE ---
          Expanded(
            flex: 8,
            child: Material(
              color: mainBg, // Changes instantly on tap down
              child: InkWell(
                // 1. Start the black flash when finger touches
                onTapDown: (_) => setState(() => _isMainPressed = true),
                // 2. Revert back to white when finger lifts or moves away
                onTapCancel: () => setState(() => _isMainPressed = false),
                // 3. Execute logic and revert color after tap is released
                onTap: () {
                  setState(() => _isMainPressed = false); // Revert color
                  widget.onMainTap(); // Execute your function
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Icon(widget.mainIcon, size: 22, color: mainFg),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.mainLabel,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: mainFg,
                            letterSpacing: 1,
                          ),
                        ),
                        if (widget.subLabel != null)
                          Text(
                            widget.subLabel!,
                            style: TextStyle(
                              color: _isMainPressed
                                  ? Colors.white70
                                  : Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- 20% RIGHT SIDE (With its own independent flash) ---
          Expanded(
            flex: 2,
            child: Material(
              color: rightBg, // Changes instantly on tap down
              child: InkWell(
                onTapDown: (_) => setState(() => _isRightPressed = true),
                onTapCancel: () => setState(() => _isRightPressed = false),
                onTap: () {
                  setState(() => _isRightPressed = false);
                  widget.onRightTap();
                },
                child: Container(
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  child: Center(child: Icon(widget.rightIcon, color: rightFg)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
