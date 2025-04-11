import 'package:fluter_prjcts/Firestore/Player/player.firestore.dart';
import 'package:fluter_prjcts/Firestore/Streak/streak.firestore.dart';
import 'package:flutter/material.dart';
import '../../Router/router.dart';

class StreakWidget extends StatelessWidget {
  const StreakWidget({super.key});

  Future<int> _fetchStreak() async {
    final currPlayer = await getCurrentPlayer();
    if (currPlayer == null) {
      router.push("/sign-in");
      throw Exception("Sign In first");
    }
    return await getStreak(currPlayer.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3D4D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: FutureBuilder<int>(
        future: _fetchStreak(),
        builder: (context, snapshot) {
          final hasData = snapshot.hasData && snapshot.data! > 0;
          final iconColor = hasData ? Colors.amber : Colors.grey;
          final textColor = hasData ? Colors.amber : Colors.grey;
          final displayText = hasData
              ? "${snapshot.data} Days Streak"
              : "Keep it up";

          return Row(
            children: [
              Icon(
                Icons.local_fire_department_rounded,
                color: iconColor,
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                displayText,
                style: TextStyle(fontSize: 18, color: textColor),
              ),
            ],
          );
        },
      ),
    );
  }
}
