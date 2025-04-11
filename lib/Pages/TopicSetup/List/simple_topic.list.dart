import 'package:fluter_prjcts/Pages/TopicSetup/Cards/simple_topic.card.dart';
import 'package:fluter_prjcts/Router/router.dart';
import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Models/topic.dart';

class SimpleTopicsList extends StatelessWidget {
  final List<Topic> topics;

  const SimpleTopicsList({
    super.key,
    required this.topics,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: topics.length,
      itemBuilder: (context, index) {
        final topic = topics[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: SimpleTopicCard(
            headerWidth: 150,
            topic: topic,
            mainColor: Color(0xFF7173FF),
            titleStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF30323D),
            ),
            questionsStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            onCardTapped: () {
              router.pushNamed("/question-list", extra: topic.id);
            },
          ),
        );
      },
    );
  }
}