import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Models/ranked_player.dart';

class LeaderBoardCard extends StatefulWidget {
  final RankedPlayer rankedPlayer;
  final VoidCallback onCardTapped;

  const LeaderBoardCard({
    super.key,
    required this.rankedPlayer,
    required this.onCardTapped,
  });

  @override
  State<LeaderBoardCard> createState() => _LeaderBoardCardState();
}

class _LeaderBoardCardState extends State<LeaderBoardCard> {

  @override
  void initState() {
    super.initState();
  }

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
      return InkWell(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF30323d),  // Directly using the color passed in the constructor
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 130,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                decoration: BoxDecoration(
                  color: _getColor(widget.rankedPlayer.rank),
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    // Rank & Profile
                    Row(
                      children: [
                        Text("${widget.rankedPlayer.rank}${widget.rankedPlayer.rank != null ? _getOrdinal(widget.rankedPlayer.rank!) : ''}", style: _textStyle()),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: Colors.black, // Icon background
                          radius: 22,
                          child: const Icon(Icons.person, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),

                  ]
                )
              ),

              const SizedBox(width: 12),

              /// Questions Count
              Expanded(
                  child: Row(
                      children: [
                        Text(
                          widget.rankedPlayer.username,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${widget.rankedPlayer.points} Points",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: _getColor(widget.rankedPlayer.rank),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ]
                  )
              ),
            ],
          ),
        ),
      );
    }
}
