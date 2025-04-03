import 'package:flutter/material.dart';

class SelectSquareButton extends StatelessWidget {
  final bool isSelected;
  final Color borderColor;
  final VoidCallback onTap;

  const SelectSquareButton({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.transparent,
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
        ),
        child: isSelected
            ? Icon(Icons.check, color: Colors.white, size: 24)
            : null,
      ),
    );
  }
}