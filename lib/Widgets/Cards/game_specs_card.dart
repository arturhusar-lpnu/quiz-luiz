import "package:flutter/material.dart";
import "package:fluter_prjcts/Models/game.dart";
import "package:fluter_prjcts/Models/player.dart";
import "package:fluter_prjcts/Models/topic.dart";


class GameSpecsCard extends StatelessWidget {
  final double width;
  final double height;
  final Game game;
  final List<Player> players;
  final List<Topic> topics;
  final Color headerBackColor;
  final Color bodyBackColor;
  final Color titleColor;
  final String titleText;

  const GameSpecsCard({
    super.key,
    required this.game,
    required this.topics,
    required this.players,
    required this.width,
    required this.height,
    required this.headerBackColor,
    required this.titleText,
    this.titleColor = Colors.black,
    this.bodyBackColor = const Color(0xFF30323D),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bodyBackColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: headerBackColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: titleColor,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Icon(Icons.person, size: 50), //TODO change to user profile-image
                ),
                const SizedBox(width: 8), // Space between icon and text
                Expanded(
                  child: Text(
                    titleText,
                    //
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Body Section
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Type: ${game.type.name.toLowerCase()[0].toUpperCase()}",
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Mode: ${game.mode.name.toLowerCase()[0].toUpperCase()}",
                      style: TextStyle(
                        color: Color(0xFF929292),
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Topics: ${topics.join(", ")}",
                      style: TextStyle(
                        color: Color(0xFF929292),
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
