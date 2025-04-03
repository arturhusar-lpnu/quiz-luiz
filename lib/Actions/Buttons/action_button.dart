import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double width;
  final double height;
  final double fontSize;

  const ActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
    required this.width,
    required this.height,
    this.textColor = Colors.white,
    this.fontSize = 32
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,  // Force width
      height: height, // Force height
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          minimumSize: Size(width, height), // Ensure it respects width & height
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
