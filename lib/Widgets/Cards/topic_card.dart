// import 'package:fluter_prjcts/Models/topic.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:fluter_prjcts/Actions/RadioButtons/select_radio_button.dart';
//
// class TopicCard extends StatelessWidget {
//   Topic topic;
//   Color mainColor;
//   Color topicTitleColor;
//   bool isSelected;
//   VoidCallback onSelectionTapped;
//   TopicCard({
//     super.key,
//     required this.topic,
//     required this.mainColor,
//     required this.topicTitleColor,
//     required this.onSelectionTapped,
//     required this.isSelected,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF3A3D4D),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           //header
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: mainColor,
//               borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
//             ),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 topic.title,
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: topicTitleColor,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 20,),
//           Text("${topic.questions.length} questions"),
//           Align(
//             alignment: Alignment.centerRight,
//             child: SelectRadioButton(isSelected: isSelected, onTap: onSelectionTapped, color: mainColor),
//           ),
//         ],
//       )
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Models/topic.dart';
import 'package:fluter_prjcts/Actions/RadioButtons/select_radio_button.dart';

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

  @override
  Widget build(BuildContext context) {
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
              "${topic.questions.length} questions",
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
}
