// import 'package:fluter_prjcts/Actions/Buttons/create_game_button.dart';
// import 'package:fluter_prjcts/Models/game.dart';
// import 'package:fluter_prjcts/Models/match_details.dart';
// import 'package:fluter_prjcts/Models/topic.dart';
// import 'package:fluter_prjcts/Models/user.dart';
// import 'package:fluter_prjcts/Widgets/Cards/game_specs_card.dart';
// import 'package:flutter/material.dart';
//
// import '../../Screens/game_setup_screen.dart';
//
// class FinalSetupPage extends StatefulWidget {
//   final GameType selectedGameType;
//   final GameMode selectedGameMode;
//   final Set<String> selectedTopics;
//   final String selectedOpponentId;
//   final String currentUserId;
//
//   const FinalSetupPage({
//     super.key,
//     required this.selectedOpponentId,
//     required this.selectedGameType,
//     required this.selectedGameMode,
//     required this.selectedTopics,
//     required this.currentUserId,
//   });
//
//   @override
//   FinalSetupState createState() => FinalSetupState();
// }
//
// class FinalSetupState extends State<FinalSetupPage> {
//
//   String genId() {
//     return "#1245";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String gameId = genId();
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF4D5061),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           const SizedBox(height: 10,),
//           const Text(
//             "Selected options",
//             style: TextStyle(
//                 fontSize: 22,
//                 color: Colors.amber
//             ),
//           ),
//           const SizedBox(height: 10,),
//
//           Align(
//             alignment: Alignment.center,
//             child: GameSpecsCard(
//                 gameDetails: Game(
//                     matchDetails: MatchDetails(
//                         title: "",
//                         type: widget.selectedGameType.name,
//                         topics: widget.selectedTopics.toString(),
//                         mode: widget.selectedGameMode.name),
//                     id: gameId,
//                     users: [
//                       widget.selectedOpponent,
//                       widget.currentUser,
//                     ]),
//                 width: 350,
//                 height: 300,
//                 headerBackColor: Color(0xFF5DD39E),
//                 titleColor: Color(0xFF30323D),
//                 titleText: "Duel with ${widget.selectedOpponent.username}\n"
//                     "Game Id: $gameId", //TODO GenId
//             ),
//           ),
//
//           const SizedBox(height: 20,),
//
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: CreateGameButton(
//                 text: "Create",
//                 color: Color(0xFF6E3DDA),
//                 width: 220,
//                 height: 70,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Actions/Buttons/create_game_button.dart';
import 'package:fluter_prjcts/Models/game.dart';
import 'package:fluter_prjcts/Models/match_details.dart';
import 'package:fluter_prjcts/Models/topic.dart';
import 'package:fluter_prjcts/Models/user.dart';
import 'package:fluter_prjcts/Models/Enums/game_type.enum.dart';
import 'package:fluter_prjcts/Models/Enums/game_mode.enum.dart';
import 'package:fluter_prjcts/Widgets/Cards/game_specs_card.dart';
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
  User? selectedOpponent;
  Set<Topic> selectedTopicsData = HashSet<Topic>();

  // Function to fetch opponent data by ID
  Future<User> fetchOpponentData(String opponentId) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));
    // Replace with actual data fetching logic
    return User(id: opponentId, username: "OpponentUsername"); // Mock data
  }

  // Function to fetch topics data
  Future<Set<Topic>> fetchTopicsData(Set<String> topicIds) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));
    // Replace with actual data fetching logic
    return {Topic(id: "1", title: "Topic 1", description: "Topic 1 Description", questions: [])}; // Mock data
  }

  // Function to fetch both opponent and topic data
  Future<Map<String, dynamic>> fetchData() async {
    final opponent = await fetchOpponentData(widget.selectedOpponentId);
    final topics = await fetchTopicsData(widget.selectedTopicsIds);
    return {"opponent": opponent, "topics": topics};
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen<Map<String, dynamic>>(
      future: fetchData, // Pass fetchData as the future
      builder: (context, data) {
        final opponent = data["opponent"] as User;
        final topics = data["topics"] as Set<Topic>;

        String gameId = "#1245"; // Example game ID, replace with your logic

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
                child: GameSpecsCard(
                  gameDetails: Game(
                    matchDetails: MatchDetails(
                      title: "",
                      type: widget.selectedGameType?.name ?? GameType.ranked.name,
                      topics: widget.selectedTopicsIds.toString(),
                      mode: widget.selectedGameMode?.name ?? GameMode.deathRun.name,
                    ),
                    id: gameId,
                    users: [
                      opponent,
                      User(id: widget.currentUserId, username: "CurrentUser"),
                    ],
                  ),
                  width: 350,
                  height: 300,
                  headerBackColor: Color(0xFF5DD39E),
                  titleColor: Color(0xFF30323D),
                  titleText: "Duel with ${opponent.id} ${opponent.username}\nGame Id: $gameId",
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
