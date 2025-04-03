import 'package:flutter/material.dart';
import './leaderboard_entry.dart';

class LeaderboardWidget extends StatelessWidget {
  const LeaderboardWidget({super.key});

  Widget _leaderboardAvatar(String name, int points, Color borderColor, double size) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 3),
          ),
          padding: const EdgeInsets.all(4), // Space for border
          child: CircleAvatar(
            radius: size,
            backgroundColor: Colors.black,
            child: Icon(Icons.person, size: size),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "$name \t $points pts",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🏆 Leaderboard Section Title
        Center(
          child: const Text(
            "LeaderBoard",
            style: TextStyle(fontSize: 24, color: Colors.amber),
          ),
        ),

        // 🏆 Leaderboard Container
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF3A3D4D),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // First Place
              _leaderboardAvatar("Erika", 40, Colors.yellow, 20),
              const SizedBox(height: 10),

              // Second & Third Place
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _leaderboardAvatar("Vasyl", 34, Colors.grey, 15),
                  const SizedBox(width: 40), // Space between avatars
                  _leaderboardAvatar("OlyaUA", 30, Colors.redAccent, 15),
                ],
              ),
              const SizedBox(height: 20),

              // Leaderboard Entry for "You"
              LeaderboardEntry(rank: 15, name: "You", points: 3, color: Color(0xFFE0BF37),),
            ],
          ),
        ),
      ],
    );
  }
}