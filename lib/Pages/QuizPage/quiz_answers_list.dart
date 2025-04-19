import "package:fluter_prjcts/Pages/QuizPage/quiz_answer_card.dart";
import "package:flutter/material.dart";
import "package:fluter_prjcts/Models/answer.dart";

List<Color> answerCardsColors = [
  Color(0xFF5DD39E),
  Color(0xFFE8C547),
  Color(0xFF7173FF),
  Color(0xFFD4C2FC),
];

class QuizAnswerList extends StatelessWidget {
  final List<Answer> answers;
  final List<Answer> selectedAnswers;
  final Function(Answer selectedAnswer) onAnswerSelected;

  const QuizAnswerList({
    super.key,
    required this.answers,
    required this.selectedAnswers,
    required this.onAnswerSelected
  });

  List<Widget> _buildAnswerCards() {
    return List.generate(answers.length, (index) {
      final answer = answers[index];
      return QuizAnswerCard(
        width: 250,
        height: 250,
        textColor: Colors.black,
        backGroundColor: answerCardsColors[index % answerCardsColors.length],
        textFontSize: 16,
        answer: answer,
        isSelected: selectedAnswers.contains(answer),
        onTap: () => onAnswerSelected(answer),
      );
    });
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