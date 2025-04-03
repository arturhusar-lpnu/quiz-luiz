import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Actions/RadioButtons/select_radio_button.dart';

class GameSetupCard extends StatelessWidget {
  final int index;
  final bool isSelected;
  final Function(int) onSelect;
  final double width;
  final double height;
  final Color headerBackColor;
  final Color bodyBackColor;
  final Text descriptionWidget;
  final Text titleWidget;
  final double headerHeight;

  const GameSetupCard({
    super.key,
    required this.index,
    required this.isSelected,
    required this.onSelect,
    required this.width,
    required this.height,
    required this.headerBackColor,
    required this.bodyBackColor,
    required this.titleWidget,
    required this.descriptionWidget,
    this.headerHeight = 60
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(index),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: bodyBackColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header

            Container(
              height: headerHeight,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: headerBackColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: titleWidget
              ),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  descriptionWidget,
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: SelectRadioButton(
                      isSelected: isSelected,
                      color: headerBackColor,
                      onTap: () => onSelect(index),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}