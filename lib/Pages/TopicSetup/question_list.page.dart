import "package:fluter_prjcts/Models/question.dart";
import "package:flutter/material.dart";

class QuestionListPage extends StatelessWidget {
  final List<Question> questions;

  const QuestionListPage({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: questions.map((q) => ListTile(title: Text(q.content))).toList(),
      ),
    );
  }
}