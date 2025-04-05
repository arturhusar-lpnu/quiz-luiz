import "package:fluter_prjcts/Firestore/Answer/answer.firestore.dart";
import "package:fluter_prjcts/Firestore/Question/question.firestore.dart";
import "package:fluter_prjcts/Screens/loading_screen.dart";
import "package:flutter/material.dart";
import "package:fluter_prjcts/Models/answer.dart";
import "package:fluter_prjcts/Widgets/Cards/answer_choice.card.dart";
import "package:fluter_prjcts/Pages/TopicSetup/Buttons/save_topic.button.dart";

List<Color> answerCardsColors = [
  Color(0xFF5DD39E),
  Color(0xFFE8C547),
  Color(0xFF7173FF),
  Color(0xFFD4C2FC),
];

class AnswerList extends StatefulWidget {
  final String questionId;
  final List<Answer> answers;
  const AnswerList({super.key, required this.questionId, this.answers = const []});

  @override
  AnswerListState createState() => AnswerListState();
}

class AnswerListState extends State<AnswerList> {
  List<Answer> answers = [];

  @override
  void initState() {
    super.initState();
    answers = widget.answers;
  }

  // Get the answers for the given question
  Future<void> _getAnswers() async {
    answers = await getAnswers(widget.questionId);

    if (answers.length > 4) {
      throw Exception("Exceeded answer size");
    }

    // If fewer than 4 answers, add empty answers for the remaining spots
    while (answers.length < 4) {
      answers.add(Answer(id: "", content: "", isCorrect: false, questionId: widget.questionId));
    }
  }


  Future<void> _saveAnswers() async{
    for (var answer in answers) {
      if (answer.id.isNotEmpty) {
        // Update existing answer
        await updateAnswer(answer.id, content: answer.content, isCorrect: answer.isCorrect);
      } else if (answer.content.isNotEmpty) {
        // Add new answer only if there's content
        await addAnswer(answer.questionId, answer.content, answer.isCorrect);
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Answers saved!")),
    );
  }

  Widget _buildContent(BuildContext context, _) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Flexible(
             child:
            ListView.builder(
              itemCount: answers.length,
              itemBuilder: (context, index) {
                return AnswerChoiceCard(
                  answer: answers[index],
                  width: 100,
                  height: 100,
                  textColor: Colors.black,
                  backGroundColor: answerCardsColors[index],
                  textFontSize: 16,
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SaveTopicButton(
              text: "Save and move to Answers",
              color: Color(0xFF6E3DDA),
              width: double.infinity,
              height: 90,
              onPressed: _saveAnswers,
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
      future: _getAnswers,
      builder: _buildContent,
      loadingText: "What could it be...",
      backgroundColor: Color(0xFF3A3D4D),
    );
  }
}