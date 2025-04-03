import "package:fluter_prjcts/Models/topic.dart";
import "package:flutter/material.dart";

class TopicSetupPage extends StatefulWidget {
  const TopicSetupPage({super.key});

  @override
  TopicSetupPageState createState() => TopicSetupPageState();
}

class TopicSetupPageState extends State<TopicSetupPage> {
  Topic setupTopic = Topic(
    id: '',
    description: '',
    title: '',
    questions: []
  );

  @override
  Widget build(BuildContext context) {
   return Container(
     padding: const EdgeInsets.all(16),
     decoration: BoxDecoration(
       color: const Color(0xFF4D5061),
       borderRadius: BorderRadius.circular(12),
     ),
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [

       ],
     ),
   );
  }
}