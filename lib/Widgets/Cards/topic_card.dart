import 'package:fluter_prjcts/Screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Models/topic.dart';
import 'package:fluter_prjcts/Actions/RadioButtons/select_radio_button.dart';
import 'package:fluter_prjcts/Firestore/Topic/topic.firestore.dart';
import 'package:fluter_prjcts/Models/question.dart';

class TopicCard extends StatelessWidget {
  final Topic topic;
  final Color mainColor;
  final bool isSelected;
  final TextStyle titleStyle;
  final TextStyle questionsStyle;
  final VoidCallback onSelectionTapped;
  double headerWidth;

  TopicCard({
    super.key,
    required this.topic,
    required this.mainColor,
    required this.onSelectionTapped,
    required this.isSelected,
    required this.titleStyle,
    required this.questionsStyle,
    this.headerWidth = 100,
  });

  Future<List<Question>> getQuestions() async {
    return await getTopicQuestions(topic.id);
  }

  Widget _buildContext(BuildContext context, List<Question> questions) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3A3D4D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ///Header
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: headerWidth, // Fixed width to maintain consistency
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              ),
              child: Text(
                topic.title,
                style: titleStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),


          const SizedBox(width: 12), // Spacing between sections

          /// Questions Count
          Expanded(
            child: Text(
              "${questions.length} questions",
              style: questionsStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          SelectRadioButton(
            isSelected: isSelected,
            onTap: onSelectionTapped,
            color: mainColor,
          ),
          const SizedBox(width: 12)
        ],
      ),
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
