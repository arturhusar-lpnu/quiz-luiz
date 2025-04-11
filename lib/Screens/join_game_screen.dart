import 'package:fluter_prjcts/Actions/Buttons/decline_button.dart';
import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Actions/Buttons/back_button.dart';
import "package:fluter_prjcts/Widgets/Other/screen_title.dart";
import "package:fluter_prjcts/Widgets/Cards/game_data_card.dart";
import 'package:fluter_prjcts/Actions/Buttons/accept_button.dart';
import '../Models/game_data.dart';

class JoinGameScreen extends StatelessWidget {
  final GameData gameData;

  const JoinGameScreen({super.key, required this.gameData});

  // Future<Map<String, dynamic>> fetchData() async {
  //   final game = await getGame(gameId);
  //   final topics = await getGameTopics(gameId);
  //   final players = await getGamePlayers(gameId, game.mode);
  //
  //   return {"game": game, "topics": topics, "players" : players};
  // }

  Widget _buildContent(BuildContext context) {
      // , Map<String, dynamic> data) {
    // final configGame = data["game"] as Game;
    // final topics = data["topics"] as List<Topic>;
    // final players = data["players"] as List<Player>;
    // final gameData = GameData(
    //   game: configGame,
    //
    // )

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        children: [
          // Top Row with ReturnBackButton and ScreenTitle
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Row(
              children: [
                ReturnBackButton(
                  iconColor: Colors.amber,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: ScreenTitle(title: "Joining Game"),
                ),
              ],
            ),
          ),

          // Match Details Container with GameCard
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF3A3D4D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Match details",
                      style: TextStyle(fontSize: 32, color: Colors.amber),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(
                      child: GameDataCard(
                        gameData: gameData,
                        headerBackColor: Color(0xFF5DD39E),
                        titleColor: Color(0xFF30323D),
                        titleText: "${gameData.hostPlayer.username}\n"
                            "set a duel with you \n"
                            "Game Id: ${gameData.game.id.substring(0, 4)}",
                        width: 350,
                        height: 300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Row for Decline and Accept Buttons
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: DeclineButton(
                      text: "Decline",
                      color: Color(0xFFD66C6C),
                      width: 160,
                      height: 60,
                      fontSize: 24,
                      textColor: Colors.black
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: AcceptButton(
                      text: "Accept",
                      color: Color(0xFF8BFFD6),
                      width: 160,
                      height: 60,
                      fontSize: 24,
                      textColor: Colors.black
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // return LoadingScreen<Map<String, dynamic>>(
    //   loadingText: "Loading data...",
    //   future: fetchData,
    //   builder: _buildContent,
    //   backgroundColor: Color(0xFF3A3D4D),
    // );
    return _buildContent(context);
  }
}