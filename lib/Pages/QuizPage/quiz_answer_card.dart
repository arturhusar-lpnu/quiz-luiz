import "package:flutter/material.dart";
import "package:fluter_prjcts/Models/answer.dart";

class QuizAnswerCard extends StatefulWidget {
  final Color backGroundColor;
  final Color textColor;
  final double textFontSize;
  final double width;
  final double height;
  final Answer answer;
  final bool isSelected;
  final VoidCallback? onTap;

  const QuizAnswerCard({
    super.key,
    required this.width,
    required this.height,
    required this.textColor,
    required this.backGroundColor,
    required this.textFontSize,
    required this.answer,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<QuizAnswerCard> createState() => _QuizAnswerCardState();
}

class _QuizAnswerCardState extends State<QuizAnswerCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Transform.translate(
        offset: widget.isSelected ? Offset(0, -10) : Offset.zero,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backGroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white10,
              width: 4,
            ),
            boxShadow: widget.isSelected
                ? [
              BoxShadow(
                color: widget.backGroundColor.withAlpha((0.8 * 255).round()),
                blurRadius: 12,
                offset: Offset(0, 4),
              )
            ]
                : [],
          ),
          padding: EdgeInsets.all(12),
          child: Center(
            child: Text(
              widget.answer.content,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: widget.textFontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
