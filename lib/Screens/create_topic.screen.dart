import "package:fluter_prjcts/Firestore/Topic/topic.firestore.dart";
import "package:fluter_prjcts/Models/topic.dart";
import "package:fluter_prjcts/Pages/TopicSetup/Buttons/save_topic.button.dart";
import "package:fluter_prjcts/Router/router.dart";
import "package:fluter_prjcts/Screens/loading_screen.dart";
import "package:flutter/material.dart";
import "package:fluter_prjcts/Pages/TopicSetup/Widgets/title_input.dart";
import "package:fluter_prjcts/Pages/TopicSetup/Widgets/description_title.dart";
import "package:fluter_prjcts/Models/question.dart";
import "package:fluter_prjcts/Pages/TopicSetup/Buttons/edit_questions.button.dart";


class CreateTopicScreen extends StatefulWidget {
  const CreateTopicScreen({super.key});

  @override
  CreateTopicState createState() => CreateTopicState();
}


class CreateTopicState extends State<CreateTopicScreen> {
  Topic setupTopic = Topic(
      id: '',
      title: '',
      description: '',
  );

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _saveTopic() {
    setupTopic.title = _titleController.text.trim();
    setupTopic.description = _descriptionController.text.trim();

    if (setupTopic.title.isEmpty || setupTopic.description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Title and Description are required!")),
      );
      return;
    }
  }

  Future<List<Question>> getQuestions() async{
    return await getTopicQuestions(setupTopic.id);
  }

  Widget _buildContext(BuildContext context, List<Question> questions) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopicTitleWidget(controller: _titleController),
            SizedBox(height: 16),
            TopicDescriptionWidget(controller: _descriptionController),
            SizedBox(height: 16),
            Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Questions ${questions.length}"),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: EditQuestionsButton(
                    text: "Edit",
                    width: 100,
                    height: 50,
                    color: Colors.black,
                    onPressed: () {
                      router.goNamed(
                          "/question-list",
                          extra: questions //TODO check maybe can simplify with firebase
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SaveTopicButton(
                    text: "Save",
                    color: Color(0xFF6E3DDA),
                    width: 220,
                    height: 70,
                    onPressed: _saveTopic
                ),
              ],
            ),
          ],
        ),
      ),
      // ListView(
      //   padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      //   children: [
      //     // Top Row with ReturnBackButton and ScreenTitle
      //     Padding(
      //       padding: const EdgeInsets.only(bottom: 100),
      //       child: Row(
      //         children: [
      //           ReturnBackButton(
      //             backColor: Colors.amber,
      //             iconColor: Colors.black,
      //             radius: 20,
      //           ),
      //           Padding(
      //             padding: const EdgeInsets.only(left: 50),
      //             child: ScreenTitle(title: "Create Topic"),
      //           ),
      //         ],
      //       ),
      //     ),
      //     Align(
      //       alignment: Alignment.center,
      //       child: AnswerList(),
      //     ),
      //     Align(
      //       alignment: Alignment.bottomCenter,
      //       child: AddTopicButton(
      //           text: "Add Answers",
      //           color: Color(0xFF6E3DDA),
      //           width: 220,
      //           height: 70,
      //       )
      //     )
      //   ],
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
        future: getQuestions,
        builder: _buildContext
    );
  }
}