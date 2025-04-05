import "package:fluter_prjcts/Firestore/Topic/topic.firestore.dart";
import "package:fluter_prjcts/Models/topic.dart";
import "package:fluter_prjcts/Pages/TopicSetup/Buttons/save_topic.button.dart";
import "package:fluter_prjcts/Router/router.dart";
import "package:fluter_prjcts/Widgets/Other/screen_title.dart";
import "package:flutter/material.dart";
import "package:fluter_prjcts/Pages/TopicSetup/Widgets/title_input.dart";
import "package:fluter_prjcts/Pages/TopicSetup/Widgets/description_title.dart";

import "../Actions/Buttons/back_button.dart";

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

  Future<void> _saveTopic() async{
    setupTopic.title = _titleController.text.trim();
    setupTopic.description = _descriptionController.text.trim();

    if (setupTopic.title.isEmpty || setupTopic.description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Title and Description are required!")),
      );
      return;
    }

    String topicId = await addTopic(setupTopic.title, setupTopic.description);

    router.pushNamed("/question-list", extra: topicId);
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
                      ScreenTitle(title: "New Topic")
                    ],
                  )
              ),
              BackButton(),
              SizedBox(height: 20),
              TopicTitleWidget(controller: _titleController),
              SizedBox(height: 16),
              TopicDescriptionWidget(controller: _descriptionController),
              SizedBox(height: 32),
              SaveTopicButton(
                text: "Save",
                color: Color(0xFF6E3DDA),
                width: double.infinity,
                height: 70,
                onPressed: _saveTopic,
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