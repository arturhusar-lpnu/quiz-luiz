import "package:flutter/material.dart";
import "package:fluter_prjcts/Models/answer.dart";
import "package:fluter_prjcts/Pages/TopicSetup/Cards/answer_choice.card.dart";

List<Color> answerCardsColors = [
  Color(0xFF5DD39E),
  Color(0xFFE8C547),
  Color(0xFF7173FF),
  Color(0xFFD4C2FC),
];

class AnswerList extends StatelessWidget {
  final List<Answer> answers;
  final Function(int index, Answer updateAnswe) onAnswerChanged;
  const AnswerList({
    super.key,
    required this.answers,
    required this.onAnswerChanged,
  });

  List<Widget> _buildAnswerCards() {
    return List.generate(4, (index) => AnswerChoiceCard(
      width: 250,
      height: 250,
      textColor: Colors.black,
      backGroundColor: answerCardsColors[index],
      textFontSize: 16,
      answer: answers[index],
      onChanged: (updatedAnswer) => onAnswerChanged(index, updatedAnswer),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1,
      physics: NeverScrollableScrollPhysics(),
      children: _buildAnswerCards(),
    );
  }
}