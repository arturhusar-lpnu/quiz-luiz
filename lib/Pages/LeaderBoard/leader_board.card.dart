import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Models/ranked_player.dart';

class LeaderBoardCard extends StatelessWidget {
  final RankedPlayer rankedPlayer;
  final VoidCallback onCardTapped;

  const LeaderBoardCard({
    super.key,
    required this.rankedPlayer,
    required this.onCardTapped,
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

  Color _getColor(int? number) {
    switch (number) {
      case 1:
        return Color(0xFFE0BF37);
      case 2:
        return Color(0xFFb9b5b5);
      case 3:
        return Color(0xFF9a5656);
      default:
        return Color(0xFFa27bfa);
    }
  }

  TextStyle _textStyle() => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTapped,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF30323d),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 130,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              decoration: BoxDecoration(
                color: _getColor(rankedPlayer.rank),
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Text(
                    "${rankedPlayer.rank}${_getOrdinal(rankedPlayer.rank)}",
                    style: _textStyle(),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.account_circle,
                    size: 40,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Row(
                children: [
                  Text(
                    rankedPlayer.username,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${rankedPlayer.points} Points",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: _getColor(rankedPlayer.rank),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}