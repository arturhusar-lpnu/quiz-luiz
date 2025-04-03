import 'package:flutter/material.dart';

class RecentTopicsWidget extends StatelessWidget {
  const RecentTopicsWidget({super.key});

  // Helper method to create a topic button with text
  Widget _topicButtonText(String text, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        foregroundColor: Color(0xFF444545),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      onPressed: () {},
      child: Text(text, style: TextStyle(fontSize: 14),),
    );
  }

  // Helper method to create a topic button with an icon
  Widget _topicButtonIcon(Icon icon, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        foregroundColor: Colors.white,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      onPressed: onPressed,
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3D4D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Recent Topics", style: TextStyle(fontSize: 18, color: Colors.amber)),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            children: [
              _topicButtonText("Science", Color(0xFFCFB9FF)),
              _topicButtonText("Greek Mythology", Color(0xFF5DD39E)),
              _topicButtonIcon(Icon(Icons.more_horiz, size: 32), Color(0xFF7173FF), () {}),
            ],
          ),
        ],
      ),
    );
  }
}