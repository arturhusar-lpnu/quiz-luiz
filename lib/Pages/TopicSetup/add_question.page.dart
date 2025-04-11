import "package:fluter_prjcts/Firestore/Answer/answer.firestore.dart";
import "package:fluter_prjcts/Firestore/Question/question.firestore.dart";
import "package:fluter_prjcts/Pages/TopicSetup/Buttons/save_topic.button.dart";
import "package:fluter_prjcts/Pages/TopicSetup/List/answers.list.dart";
import "package:fluter_prjcts/Widgets/Other/screen_title.dart";
import "package:fluter_prjcts/Widgets/PopUp/saved.popup.dart";
import "package:flutter/material.dart";
import "package:fluter_prjcts/Models/question.dart";
import "package:fluter_prjcts/Actions/Buttons/back_button.dart";
import "package:fluter_prjcts/Models/answer.dart";
import "../../Widgets/PopUp/alert.popup.dart";
import "Widgets/Question/question_content_input.dart";


class AddQuestionPage extends StatefulWidget {
  final String topicId;
  const AddQuestionPage({super.key, required this.topicId});

  @override
  AddQuestionState createState() => AddQuestionState();
}


class AddQuestionState extends State<AddQuestionPage> {
  Question setupQuestion = Question(
    topicId: '',
    content: '',
    id: '',
  );

  List<Answer> answers = List.generate(4, (index) => Answer(
    id: '',
    content: '',
    isCorrect: false,
    questionId: '',
  ));

  void _updateAnswer(int index, Answer updatedAnswer) {
    setState(() {
      answers[index] = updatedAnswer;
    });
  }

  bool _validateAnswers() {
    final nonEmpty = answers.where((a) => a.content.isNotEmpty).length == 4;
    final hasCorrect = answers.any((a) => a.isCorrect);
    return nonEmpty && hasCorrect;
  }

  final TextEditingController _contentController = TextEditingController();

  Future<void> _saveQuestion() async{
    setupQuestion.content = _contentController.text.trim();

    if (setupQuestion.content.isEmpty) {
      await showAlertDialog(context, message: "Provide a question");
      return;
    }

    if(!_validateAnswers()) {
      await showAlertDialog(context, message: "Provide 4 answers, with at least one correct");
      return;
    }

    String questionId = await addQuestion(widget.topicId, setupQuestion.content);

    for(var answer in answers) {
      await addAnswer(questionId, answer.content, answer.isCorrect);
    }

    await showSaveDialog(context, message: "Question");
  }

  Widget _buildContext(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ReturnBackButton(iconColor: Colors.amber),
                  ),
                  Center(child: ScreenTitle(title: "New Question")),
                ],
              ),
              SizedBox(height: 40),
              QuestionContentWidget(controller: _contentController),
              SizedBox(height: 50),
              AnswerList(
                answers: answers,
                onAnswerChanged: _updateAnswer,
              ),
              SizedBox(height: 50),
              SaveTopicButton(
                text: "Add question",
                color: Color(0xFF6E3DDA),
                width: double.infinity,
                height: 90,
                onPressed: _saveQuestion,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContext(context);
  }
}