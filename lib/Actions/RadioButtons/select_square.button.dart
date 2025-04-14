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
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: isSelected ? Color(0xFF3AFFA3) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
            width: 2,
            style: BorderStyle.solid
          ),
        ),
        child: isSelected
            ? Icon(Icons.check, color: Colors.black, size: 26)
            : null,
      ),
    );
  }
}