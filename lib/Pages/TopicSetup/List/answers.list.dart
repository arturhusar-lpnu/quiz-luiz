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

// class AnswerListState extends State<AnswerList> {
//   List<Answer> answers = [];
//
//   @override
//   void initState() {
//     super.initState();
//     answers = widget.answers;
//   }
//
//   // Get the answers for the given question
//   // Future<void> _getAnswers() async {
//   //   answers = await getAnswers(widget.questionId);
//   //
//   //   if (answers.length > 4) {
//   //     throw Exception("Exceeded answer size");
//   //   }
//   //
//   //   // If fewer than 4 answers, add empty answers for the remaining spots
//   //   while (answers.length < 4) {
//   //     answers.add(Answer(id: "", content: "", isCorrect: false, questionId: widget.questionId));
//   //   }
//   // }
//
//
//   Future<void> _saveAnswers() async{
//     for (var answer in answers) {
//       if (answer.id.isNotEmpty) {
//         // Update existing answer
//         await updateAnswer(answer.id, content: answer.content, isCorrect: answer.isCorrect);
//       } else if (answer.content.isNotEmpty) {
//         // Add new answer only if there's content
//         await addAnswer(answer.questionId, answer.content, answer.isCorrect);
//       }
//     }
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Answers saved!")),
//     );
//   }
//
//   List<Widget> _buildAnswerCards() {
//     return List.generate(4, (index) => AnswerChoiceCard(
//         width: 250,
//         height: 250,
//         textColor: Colors.black,
//         backGroundColor: answerCardsColors[index],
//         textFontSize: 16,
//         answer: answers[index]
//       )
//     );
//   }
//
//   Widget _buildContent(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.7,
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 24),
//             child: GridView.count(
//                 crossAxisCount: 2,
//                 shrinkWrap: true,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//                 childAspectRatio: 1,
//                 physics: NeverScrollableScrollPhysics(),
//                 children: _buildAnswerCards(),
//             ),
//           ),
//           Align(
//             alignment: Alignment.center,
//             child: ActionButton(
//               fontSize: 24,
//               text: "Save Answers",
//               color: Color(0xFF6E3DDA),
//               width: 250,
//               height: 90,
//               onPressed: _saveAnswers,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _buildContent(context);
//   }
//
//   // @override
//   // Widget build(BuildContext context) {
//   //   return LoadingScreen(
//   //     future: _getAnswers,
//   //     builder: _buildContent,
//   //     loadingText: "What could it be...",
//   //     backgroundColor: Color(0xFF3A3D4D),
//   //   );
//   // }
// }