import 'dart:collection';

import 'package:fluter_prjcts/Firestore/FCM/notification.firestore.dart';
import 'package:fluter_prjcts/Firestore/Game/game.firestore.dart';
import 'package:fluter_prjcts/Models/game_data.dart';
import 'package:fluter_prjcts/Router/router.dart';
import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Actions/Buttons/create_game_button.dart';
import 'package:fluter_prjcts/Models/game.dart';
import 'package:fluter_prjcts/Models/topic.dart';
import "package:fluter_prjcts/Firestore/Player/player.firestore.dart";
import "package:fluter_prjcts/Firestore/Topic/topic.firestore.dart";
import 'package:fluter_prjcts/Models/player.dart';
import 'package:fluter_prjcts/Models/Enums/game_type.enum.dart';
import 'package:fluter_prjcts/Models/Enums/game_mode.enum.dart';
import 'package:fluter_prjcts/Widgets/Cards/game_data_card.dart';
import 'package:fluter_prjcts/Screens/loading_screen.dart';

class FinalSetupPage extends StatefulWidget {
  final GameType? selectedGameType;
  final GameMode? selectedGameMode;
  final Set<String> selectedTopicsIds;
  final String selectedOpponentId;
  final String currentUserId;

  const FinalSetupPage({
    super.key,
    required this.selectedOpponentId,
    required this.selectedGameType,
    required this.selectedGameMode,
    required this.selectedTopicsIds,
    required this.currentUserId,
  });

  @override
  FinalSetupState createState() => FinalSetupState();
}

class FinalSetupState extends State<FinalSetupPage> {
  Set<Topic> selectedTopicsData = HashSet<Topic>();

  Future<Player> fetchOpponentData(String opponentId) async {
    var opponentPlayer = await getPlayer(opponentId);
    if(opponentPlayer == null) {
      throw Exception("Player not found");
    }
    return opponentPlayer;
  }

  Future<List<Topic>> fetchTopicsData(Set<String> topicIds) async {
    List<Topic> topics =  await getTopics();
    
    return topics.where((t) => topicIds.contains(t.id)).toList();
  }


  Future<Map<String, dynamic>> fetchData() async {
    final opponent = await fetchOpponentData(widget.selectedOpponentId);
    final topics = await fetchTopicsData(widget.selectedTopicsIds);
    final currentPlayer = await fetchCurrPlayer();
    return {"current_player": currentPlayer, "opponent": opponent, "topics": topics};
  }

  Future<Player> fetchCurrPlayer() async{
    var currPl = await getCurrentPlayer();

    if(currPl == null) {
      throw Exception("No Current Player Found");
    }

    return currPl;
  }

  Future<void> _addGame(GameData gameData) async {
    Game game = gameData.game;
    GameController controller = GameController(gameSetup: game);

    controller.setTopicIds(widget.selectedTopicsIds);
    controller.setPlayers(widget.currentUserId, widget.selectedOpponentId);

    await controller.addTopics();
    await controller.addPlayers();
    gameData.game.id = await controller.getGameId();
    await sendNotification(gameData.invitedPlayer.id, gameData);
    router.push("/waiting-room", extra: gameData);
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen<Map<String, dynamic>>(
      backgroundColor: Color(0xFF30323D),
      loadingText: "Almost there",
      future: fetchData,
      builder: (context, data) {
        final Player opponent = data["opponent"] as Player;
        final Player currentPlayer = data["current_player"] as Player;
        final List<Topic> topics = data["topics"] as List<Topic>;

        GameData gameData = GameData(
          game: Game(
            id: "",
            mode: widget.selectedGameMode!,
            type: widget.selectedGameType!,
          ),
          topics: topics,
          hostPlayer: currentPlayer,
          invitedPlayer: opponent
        );

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF4D5061),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                "Selected options",
                style: TextStyle(fontSize: 32, color: Colors.amber),
              ),
              const SizedBox(height: 20),
              Center(
                child: GameDataCard(
                  gameData: gameData,
                  width: 350,
                  height: 300,
                  headerBackColor: Color(0xFF5DD39E),
                  titleColor: Color(0xFF30323D),
                  titleText: "Duel with ${opponent.username}",
                ),
              ),

              const SizedBox(height: 20),
              Expanded(child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CreateGameButton(
                    text: "Create",
                    color: Color(0xFF6E3DDA),
                    width: 220,
                    height: 70,
                    onPressed: () => _addGame(gameData),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
