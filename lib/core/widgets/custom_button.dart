import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color pressedBackgroundColor;
  final Color pressedForegroundColor;
  final double? width;
  final double? height;
  final double fontSize;
  final double letterSpacing;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.backgroundColor = Colors.black,
    this.foregroundColor = Colors.white,
    this.pressedBackgroundColor = Colors.white,
    this.pressedForegroundColor = Colors.black,
    this.width,
    this.height,
    this.fontSize = 11.0,
    this.letterSpacing = 1.8,
    this.borderRadius,
    this.borderSide,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final currentBgColor = _isPressed ? widget.pressedBackgroundColor : widget.backgroundColor;
    final currentFgColor = _isPressed ? widget.pressedForegroundColor : widget.foregroundColor;

    // Use widget's borderSide, or fallback to an outline if pressed and the background becomes white
    // so it doesn't blend into the white page background.
    final border = widget.borderSide ??
        (_isPressed && currentBgColor == Colors.white
            ? const BorderSide(color: Colors.black, width: 1.0)
            : BorderSide.none);

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: currentBgColor,
          borderRadius: widget.borderRadius ?? BorderRadius.zero,
          border: border != BorderSide.none ? Border.fromBorderSide(border) : null,
        ),
        alignment: Alignment.center,
        child: Text(
          widget.text,
          style: TextStyle(
            color: currentFgColor,
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w700,
            letterSpacing: widget.letterSpacing,
          ),
        ),
      ),
    );
  }
}
