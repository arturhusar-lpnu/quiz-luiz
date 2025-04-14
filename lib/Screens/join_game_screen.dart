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

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20,),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: ReturnBackButton(iconColor: Colors.amber),
              ),
              Center(child: ScreenTitle(title: "Joining Game")),
            ],
          ),
          const SizedBox(height: 20,),
          Column(
            children: [
              Align(
                child: Text(
                  "Match details",
                  style: TextStyle(fontSize: 26, color: Colors.amber),
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
                    height: 350,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Stack(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: DeclineButton(
                    text: "Decline",
                    color: Color(0xFFD66C6C),
                    width: 160,
                    height: 60,
                    fontSize: 24,
                    textColor: Colors.black
                ),
              ),

              Align(
                alignment: Alignment.bottomRight,
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
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }
}