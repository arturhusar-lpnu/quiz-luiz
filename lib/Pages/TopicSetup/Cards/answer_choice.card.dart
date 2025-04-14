import "package:flutter/material.dart";
import "package:fluter_prjcts/Actions/RadioButtons/select_square.button.dart";
import "package:fluter_prjcts/Models/answer.dart";


class AnswerChoiceCard extends StatefulWidget {
  final Color backGroundColor;
  final Color textColor;
  final double textFontSize;
  final double width;
  final double height;
  final Answer answer;
  final ValueChanged<Answer>? onChanged;

  const AnswerChoiceCard({
    super.key,
    required this.width,
    required this.height,
    required this.textColor,
    required this.backGroundColor,
    required this.textFontSize,
    required this.answer,
    this.onChanged
  });

  @override
  AnswerChoiceState createState() => AnswerChoiceState();
}

class AnswerChoiceState extends State<AnswerChoiceCard> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.text = widget.answer.content;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void updateContent() async {
    final newText = _textController.text.trim();

    if(newText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Answer Content is required!")),
      );
      return;
    }

    if (newText != widget.answer.content) {
      setState(() {
        widget.answer.content = newText;
      });

      widget.onChanged?.call(widget.answer);
    }
  }

  void _toggleCorrectAnswer() {
    setState(() {
      widget.answer.isCorrect = !widget.answer.isCorrect;
    });
    widget.onChanged?.call(widget.answer);
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Container(
        decoration: BoxDecoration(
          color: widget.backGroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.textColor,
            width: 2,
          ),
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SelectSquareButton(
                    isSelected: widget.answer.isCorrect,
                    onTap: _toggleCorrectAnswer,
                    borderColor: widget.textColor,
                  ),
                ],
              ),
            Center(
              child: TextField(
                controller: _textController,
                onChanged: (_) => updateContent(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Insert answer",
                  hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18
                  ),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: widget.textFontSize,
                ),
              ),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}