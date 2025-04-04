import "package:flutter/material.dart";
import "package:fluter_prjcts/Models/answer.dart";
import "package:fluter_prjcts/Widgets/Cards/answer_choice.card.dart";

List<Color> answerCardsColors = [
  Color(0xFF5DD39E),
  Color(0xFFE8C547),
  Color(0xFF7173FF),
  Color(0xFFD4C2FC),
];

class AnswerList extends StatefulWidget {
  const AnswerList({super.key});

  @override
  AnswerListState createState() => AnswerListState();
}

class AnswerListState extends State<AnswerList> {
  List<Answer> answers = List.generate(4, (_) => Answer(id: "", content: "", isCorrect: false, questionId: ''));

  void _handleAnswerChange(Answer updatedAnswer, int index) {
    setState(() {
      answers[index] = updatedAnswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(answers.length, (index) {
        return AnswerChoiceCard(
          width: 300,
          height: 100,
          textColor: Colors.black,
          backGroundColor: answerCardsColors[index],
          textFontSize: 16,
          onAnswerChanged: (answer) => _handleAnswerChange(answer, index),
        );
      }),
    );
  }
}
