import "package:fluter_prjcts/Firestore/Topic/topic.firestore.dart";
import "package:fluter_prjcts/Models/topic.dart";
import "package:fluter_prjcts/Pages/TopicSetup/Buttons/save_topic.button.dart";
import "package:fluter_prjcts/Router/router.dart";
import "package:fluter_prjcts/Widgets/Other/screen_title.dart";
import "package:flutter/material.dart";
import "package:fluter_prjcts/Pages/TopicSetup/Widgets/title_input.dart";
import "package:fluter_prjcts/Pages/TopicSetup/Widgets/description_title.dart";
import "package:fluter_prjcts/Actions/Buttons/back_button.dart";

class CreateTopicScreen extends StatefulWidget {
  const CreateTopicScreen({super.key});

  @override
  State<CreateTopicScreen> createState() => _CreateTopicState();
}


class _CreateTopicState extends State<CreateTopicScreen> {
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

    router.pushReplacementNamed("/question-list", extra: topicId);
  }

  Widget _buildContext(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: ReturnBackButton(iconColor: Colors.amber),
                ),
                Center(child: ScreenTitle(title: "New Topic")),
              ],
            ),
            // Instead of using another Center widget, use MainAxisAlignment.center here
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TopicTitleWidget(controller: _titleController),
                    const SizedBox(height: 16),
                    TopicDescriptionWidget(controller: _descriptionController),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            SaveTopicButton(
              text: "Save",
              color: Color(0xFF6E3DDA),
              width: double.infinity,
              height: 70,
              onPressed: _saveTopic,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContext(context);
  }
}