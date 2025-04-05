import "package:flutter/material.dart";

class QuestionContentWidget extends StatelessWidget {
  final TextEditingController controller;
  const QuestionContentWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return TextField(
          controller: controller,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: "Question Content",
            hintText: "Insert question content",
          ),
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        );
      },
    );
  }
}