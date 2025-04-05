import "package:fluter_prjcts/Firestore/Answer/answer.firestore.dart";
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

  const AnswerChoiceCard({
    super.key,
    required this.width,
    required this.height,
    required this.textColor,
    required this.backGroundColor,
    required this.textFontSize,
    required this.answer,
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

  void _saveContent() async {
    final newText = _textController.text.trim();
    if (newText != widget.answer.content) {
      await updateAnswer(widget.answer.id, content: newText);
    }
  }

  Future<void> _toggleCorrectAnswer() async{
    await updateAnswer(widget.answer.id, isCorrect: !widget.answer.isCorrect);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Container(
        decoration: BoxDecoration(
          color: widget.backGroundColor,
          borderRadius: BorderRadius.circular(16),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Mark as correct"),
                const SizedBox(width: 20),
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
                onSubmitted: (_) => _saveContent(),
                decoration: const InputDecoration(
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
      ),
    );
  }
}