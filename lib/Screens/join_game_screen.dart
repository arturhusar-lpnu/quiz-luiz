import 'package:fluter_prjcts/Actions/Buttons/decline_button.dart';
import 'package:fluter_prjcts/Firestore/Game/game.firestore.dart';
import 'package:fluter_prjcts/Models/game.dart';
import 'package:fluter_prjcts/Models/player.dart';
import 'package:fluter_prjcts/Screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Actions/Buttons/back_button.dart';
import "package:fluter_prjcts/Widgets/Other/screen_title.dart";
import "package:fluter_prjcts/Widgets/Cards/game_specs_card.dart";
import 'package:fluter_prjcts/Actions/Buttons/accept_button.dart';
import 'package:fluter_prjcts/Models/topic.dart';

class JoinGameScreen extends StatelessWidget {
  final String gameId;
  const JoinGameScreen({super.key, required this.gameId});

  Future<Game> _getGame() async{
    return await getGame(gameId);
  }
  Future<List<Topic>> getTopics() async {
    return await getGameTopics(gameId);
  }
  Future<List<Player>> getPlayers() async {
    return await getGamePlayers(gameId);
  }

  Future<Map<String, dynamic>> fetchData() async {
    final game = await _getGame();
    final topics = await getTopics();
    final players = await getPlayers();

    return {"game": game, "topics": topics, "players" : players};
  }

  Widget _buildContext(BuildContext context, Map<String, dynamic> data) {
    final configGame = data["game"] as Game;
    final topics = data["topics"] as List<Topic>;
    final players = data["players"] as List<Player>;
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
                      child: GameSpecsCard(
                        game: configGame,
                        players: players,
                        topics: topics,
                        headerBackColor: Color(0xFF5DD39E),
                        titleColor: Color(0xFF30323D),
                        titleText: "Opps\n"
                            "set a duel with you \n"
                            "Game Id: 1289",
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
    return LoadingScreen<Map<String, dynamic>>(
      loadingText: "Loading data...",
      future: fetchData,
      builder: _buildContext,
      backgroundColor: Color(0xFF3A3D4D),
    );
  }
}