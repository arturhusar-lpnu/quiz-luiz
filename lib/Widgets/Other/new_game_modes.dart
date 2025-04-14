import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Actions/Buttons/new_game_mode_buttons.dart';
import '../../Models/match_details.dart';
import '../Cards/match_card.dart';

class NewGameModes extends StatelessWidget{
  const NewGameModes({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ListView(
            children: [
              const Center(
                child: Text("Online modes", style: TextStyle(fontSize: 32, color: Colors.amber)),
              ),
              const SizedBox(height: 20,),
              Center(
                  child: Column(
                    children: [
                      const SizedBox(width: 10,),
                      MatchCard(
                        matchDetails: MatchDetails(
                            title: "Spectate Game",
                            mode: "Death Run",
                            type: "Random",
                            topics: "Random"),
                        width: 350,
                        height: 160,
                        headerBackColor: Colors.amber,
                        button: SpectateGameButton(
                            text: "Spectate",
                            fontSize: 16,
                            color: Colors.amberAccent,
                            width: 120,
                            height: 50
                        ),
                      ),

                      const SizedBox(height: 20,),

                      MatchCard(
                        matchDetails: MatchDetails(
                            title: "Create Game",
                            mode: "Death Run",
                            type: "Choose",
                            topics: "Choose"),
                        width: 350,
                        height: 160,
                        headerBackColor: Color(0xFF1DC379),
                        button: CreateGameButton(
                            text: "Create",
                            fontSize: 18,
                            color: Color(0xFF5DD39E),
                            width: 120,
                            height: 50
                        ),
                      ),
                     const SizedBox(height: 10,),

                      //MatchHistoryShort(),
                    ],
                  )
              )
            ],
          )
        )
    );
  }
}
