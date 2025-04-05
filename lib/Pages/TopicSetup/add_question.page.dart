import "package:fluter_prjcts/Firestore/Question/question.firestore.dart";
import "package:fluter_prjcts/Pages/TopicSetup/Buttons/save_topic.button.dart";
import "package:fluter_prjcts/Router/router.dart";
import "package:fluter_prjcts/Widgets/Other/screen_title.dart";
import "package:flutter/material.dart";
import "package:fluter_prjcts/Models/question.dart";
import "package:fluter_prjcts/Actions/Buttons/back_button.dart";

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

  final TextEditingController _contentController = TextEditingController();

  Future<void> _saveQuestion() async{
    setupQuestion.content = _contentController.text.trim();

    if (setupQuestion.content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Content is required!")),
      );
      return;
    }

    String questionId = await addQuestion(widget.topicId, setupQuestion.content);

    router.pushNamed("/add-answers", extra: questionId); // TODO check for route
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
              Align(
                  alignment: Alignment.topLeft,
                  child:
                  Row(
                    children: [
                      ReturnBackButton(
                        iconColor: Colors.amber,
                      ),
                      SizedBox(width: 40),
                      ScreenTitle(title: "New Question")
                    ],
                  )
              ),
              SizedBox(height: 20),
              QuestionContentWidget(controller: _contentController),
              SizedBox(height: 16),
              SizedBox(height: 32),
              SaveTopicButton(
                text: "Save Answers",
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