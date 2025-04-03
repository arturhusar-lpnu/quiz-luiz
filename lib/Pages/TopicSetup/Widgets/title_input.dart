import "package:flutter/material.dart";

class TopicTitleWidget extends StatelessWidget {
  final TextEditingController controller;
  const TopicTitleWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return TextField(
          controller: controller,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: "Topic Title",
            hintText: "Insert topic title",
          ),
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
          ),
        );
      },
    );
  }
}