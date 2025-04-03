import 'package:flutter/material.dart';

class SelectRadioButton extends StatelessWidget {
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const SelectRadioButton({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? color : Colors.transparent,
          border: Border.all(
            color: color,
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