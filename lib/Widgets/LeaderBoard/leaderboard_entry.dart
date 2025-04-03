import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Router/router.dart';

class LeaderboardEntry extends StatelessWidget {
  final int rank;
  final String name;
  final int points;
  final Color color;

  const LeaderboardEntry({
    super.key,
    required this.rank,
    required this.name,
    required this.points,
    required this.color,
  });

  String _getOrdinal(int number) {
    if (number >= 11 && number <= 13) return "th";
    switch (number % 10) {
      case 1:
        return "st";
      case 2:
        return "nd";
      case 3:
        return "rd";
      default:
        return "th";
    }
  }

  TextStyle _textStyle() => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  void _onTap(BuildContext context) {
    router.go("/stats");
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onTap(context),  // Navigate to the stats page
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: color,  // Directly using the color passed in the constructor
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Rank & Profile
            Row(
              children: [
                Text("$rank${_getOrdinal(rank)}", style: _textStyle()),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.black, // Icon background
                  radius: 14,
                  child: const Icon(Icons.person, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 8),
                Text(name, style: _textStyle()),
              ],
            ),
            // Points
            Text("$points Points", style: _textStyle()),
          ],
        ),
      ),
    );
  }
}
