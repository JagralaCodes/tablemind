import 'package:flutter/material.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({super.key, required this.width, this.color});
  final double width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: color?.withAlpha(100) ?? Colors.white,
          width: 0.8,
        ),
      ),
      height: width,
      width: width,
      padding: EdgeInsets.all(width * .2),
      child: Container(
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(width * .2),
          ),
        ),
      ),
    );
  }
}
