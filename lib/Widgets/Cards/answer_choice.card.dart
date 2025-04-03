import "package:flutter/material.dart";
import "package:fluter_prjcts/Actions/RadioButtons/select_square.button.dart";
import "package:fluter_prjcts/Models/answer.dart";


class AnswerChoiceCard extends StatefulWidget {
  final Color backGroundColor;
  final Color textColor;
  final double textFontSize;
  final double width;
  final double height;
  final Function(Answer) onAnswerChanged;

  const AnswerChoiceCard({
    super.key,
    required this.width,
    required this.height,
    required this.textColor,
    required this.backGroundColor,
    required this.textFontSize,
    required this.onAnswerChanged,
  });

  @override
  AnswerChoiceState createState() => AnswerChoiceState();
}

class AnswerChoiceState extends State<AnswerChoiceCard> {
  late Answer answer = Answer(content: "", isCorrect: false);
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.addListener(_updateContent);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _updateContent() {
    setState(() {
      answer.content = _textController.text;
    });

    widget.onAnswerChanged(answer);
  }

  void _toggleCorrectAnswer() {
    setState(() {
      answer.isCorrect = !answer.isCorrect;
    });

    widget.onAnswerChanged(answer);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backGroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.textColor,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Mark as correct"),
              const SizedBox(width: 20,),
              SelectSquareButton(
                isSelected: answer.isCorrect,
                onTap: _toggleCorrectAnswer,
                borderColor: widget.textColor,
              ),
            ],
          ),
          Center(
            child: TextField(
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: "Insert answer",
              ),
              style: TextStyle(
                color: widget.textColor,
                fontSize: widget.textFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}