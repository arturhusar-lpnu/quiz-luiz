import "package:flutter/material.dart";
import "package:fluter_prjcts/Pages/TopicSetup/List/answers.list.dart";
import "package:fluter_prjcts/Actions/Buttons/back_button.dart";
import "package:fluter_prjcts/Widgets/Other/screen_title.dart";

class AddAnswersPage extends StatelessWidget {
  final String questionId;
  const AddAnswersPage({super.key, required this.questionId});
  @override
  Widget build(BuildContext context) {
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
                  child: Row(
                    children: [
                      ReturnBackButton(
                        iconColor: Colors.amber,
                      ),
                      SizedBox(width: 40),
                      ScreenTitle(title: "Answers")
                    ],
                  )
              ),
              SizedBox(height: 40),
              Align(
                alignment: Alignment.center,
                child: AnswerList(questionId: questionId),
              ),
            ],
          ),
        ),
      ),
    );
  }
}