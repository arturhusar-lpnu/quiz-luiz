import 'package:fluter_prjcts/Actions/AnimatedButton/invite_player.button.dart';
import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Actions/Buttons/back_button.dart';
import "package:fluter_prjcts/Widgets/Other/screen_title.dart";
import "package:fluter_prjcts/Widgets/Cards/game_data_card.dart";
import '../Firestore/FCM/notification.firestore.dart';
import '../Models/game_data.dart';

class WaitingRoomScreen extends StatelessWidget {
  final GameData gameData;

  const WaitingRoomScreen({super.key, required this.gameData});

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Row(
              children: [
                ReturnBackButton(
                  iconColor: Colors.amber,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: ScreenTitle(title: "Waiting for \n${gameData.invitedPlayer.username}"),
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
                        titleText: "${gameData.invitedPlayer.username}\n"
                            "is invited \n"
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
          Center(child: InviteButton(
              color: Color(0xFF5DD39E),
              width: 160,
              height: 60,
              fontSize: 24,
              userId: gameData.hostPlayer.id,
              opponentId: gameData.invitedPlayer.id,
              onInviteTapped: () async{
                await sendNotification(gameData.invitedPlayer.id, gameData);
              },
              isSelected: false,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }
}