import 'package:fluter_prjcts/Actions/Buttons/decline_button.dart';
import 'package:fluter_prjcts/Models/game.dart';
import 'package:fluter_prjcts/Models/match_details.dart';
import 'package:fluter_prjcts/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Actions/Buttons/back_button.dart';
import "package:fluter_prjcts/Widgets/Other/screen_title.dart";
import "package:fluter_prjcts/Widgets/Cards/game_specs_card.dart";

import '../Actions/Buttons/accept_button.dart';

class JoinGameScreen extends StatelessWidget {
  const JoinGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  backColor: Colors.amber,
                  iconColor: Colors.black,
                  radius: 20,
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
                        gameDetails: Game(
                          matchDetails: MatchDetails(
                            title: "",
                            type: "Ranked",
                            topics: "Star Wars, K-Pop",
                            mode: "Death Run",
                          ),
                          id: "#1289",
                          users: [
                            User(id: "1", username: "You"),
                            User(id: "2", username: "Opps")
                          ],
                        ),
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
}

// class JoinGameScreen extends StatelessWidget {
//   const JoinGameScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: ListView(
//         padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
//         children: [
//           const SizedBox(height: 40,),
//           Row(
//             children: [
//               ReturnBackButton(
//                 backColor: Colors.amber,
//                 iconColor: Colors.black,
//                 radius: 20,
//               ),
//               const SizedBox(width : 50),
//               ScreenTitle(title: "Joining Game")
//             ],
//           ),
//           const SizedBox(height : 100, ),
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: const Color(0xFF3A3D4D),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child:
//             Column(
//               children: [
//                 Text("Match details", style: TextStyle(fontSize: 32, color: Colors.amber)),
//                 const SizedBox(height: 10,),
//                 //Expanded(child:
//                 Center(
//                   child: GameCard(
//                     gameDetails: Game(
//                         matchDetails: MatchDetails(
//                           title: "",
//                           type: "Ranked",
//                           topics: "Star Wars, K-Pop",
//                           mode: "Death Run",
//                         ),
//                         id: "#1289",
//                         users: [
//                           User(id: "1", username: "You"),
//                           User(id: "2", username: "Opps")
//                         ]
//                     ),
//                     headerBackColor: Color(0xFF5DD39E),
//                     titleColor: Color(0xFF30323D),
//                     width: 350,
//                     height: 300,
//                   ),
//                 ),
//
//               ],
//
//             ),
//           ),
//           const SizedBox(height: 20,),
//           Row(
//             children: [
//               const SizedBox(width: 20,),
//               ActionButton(text: "Decline", onPressed: () {}, color: Color(0xFFD66C6C), width: 150, height: 60, fontSize: 24,),
//               const SizedBox(width: 40,),
//               ActionButton(text: "Accept", onPressed: () {}, color: Color(0xFF8BFFD6), width: 150, height: 60, fontSize: 24,),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
