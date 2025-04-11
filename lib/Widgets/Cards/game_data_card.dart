import "package:fluter_prjcts/Models/game_data.dart";
import "package:fluter_prjcts/Screens/loading_screen.dart";
import "package:flutter/material.dart";
import "package:fluter_prjcts/Widgets/user_image.helper.dart";


class GameDataCard extends StatelessWidget {
  final double width;
  final double height;
  final GameData gameData;
  final Color headerBackColor;
  final Color bodyBackColor;
  final Color titleColor;
  final String titleText;

  const GameDataCard({
    super.key,
    required this.gameData,
    required this.width,
    required this.height,
    required this.headerBackColor,
    required this.titleText,
    this.titleColor = Colors.black,
    this.bodyBackColor = const Color(0xFF30323D),
  });


  String _correctName(String name) {
    name = name.replaceAll("_", " ").trim();
    List<String> parts = name
        .toLowerCase()
        .split(" ")
        .map((p) => p[0].toUpperCase() + p.substring(1))
        .toList();
    return parts.join(" ");
  }

  Future<ImageProvider> fetchOpponentImage() async{
    return await fetchProfileImage(gameData.invitedPlayer.id);
  }

  Widget buildContent(BuildContext context, ImageProvider playerImage) {
    final String type = _correctName(gameData.game.type.name);
    final String mode = _correctName(gameData.game.mode.name);
    playerImage;
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
                  child: Image(image: playerImage, width: 60, height: 60,)
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    titleText,
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
                      "Type: $type",
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Mode: $mode",
                      style: TextStyle(
                        color: Color(0xFF929292),
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Topics: ${gameData.topics.join(", ")}",
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

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
        future: fetchOpponentImage,
        builder: buildContent,
        loadingText: "Who can it be",
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
