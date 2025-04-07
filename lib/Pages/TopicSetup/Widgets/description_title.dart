import "package:flutter/material.dart";

class TopicDescriptionWidget extends StatelessWidget {
  final TextEditingController controller;
  const TopicDescriptionWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return TextField(
          controller: controller,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: "Topic Description",
            hintText: "Insert topic Description",
          ),
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        );
      },
    );
  }
}