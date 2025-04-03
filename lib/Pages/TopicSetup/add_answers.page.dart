import "package:flutter/material.dart";
import "package:fluter_prjcts/Actions/Buttons/add_topic.button.dart";
import "package:fluter_prjcts/Pages/TopicSetup/List/answers.list.dart";
import "package:fluter_prjcts/Actions/Buttons/back_button.dart";
import "package:fluter_prjcts/Widgets/Other/screen_title.dart";

class AddAnswersPage extends StatelessWidget {
  const AddAnswersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      children: [
        // Top Row with ReturnBackButton and ScreenTitle
        Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Row(
            children: [
              ReturnBackButton(
                backColor: Colors.amber,
                iconColor: Colors.black,
                radius: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: ScreenTitle(title: "Create Topic"),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: AnswerList(),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: AddTopicButton(
              text: "Add Answers",
              color: Color(0xFF6E3DDA),
              width: 220,
              height: 70,
            )
        )
      ],
    );
  }
}
