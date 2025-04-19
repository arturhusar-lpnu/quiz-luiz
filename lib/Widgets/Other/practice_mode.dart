import 'package:fluter_prjcts/Actions/Buttons/StartSoloGame/start-first-to.button.dart';
import 'package:fluter_prjcts/Actions/Buttons/StartSoloGame/start-in-arow.button.dart';
import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Widgets/Cards/match_card.dart';
import 'package:fluter_prjcts/Models/match_details.dart';

import '../../Actions/Buttons/StartSoloGame/start-death-run.button.dart';

class SoloMode extends StatelessWidget{
  const SoloMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        // decoration: BoxDecoration(
        //   color: const Color(0xFF3A3D4D),
        //   borderRadius: BorderRadius.circular(12),
        // ),
        child: ListView(
          children: [
            // const Center(
            //   child: Text("Solo", style: TextStyle(fontSize: 24, color: Colors.amber)),
            // ),
            const SizedBox(height: 20,),
            Column(
              children: [
                MatchCard(
                    matchDetails: MatchDetails(
                        title: "Death Run",
                        mode: "Death Run",
                        type: "Practice",
                        topics: "Random"),
                    width: 336,
                    height: 151,
                    headerBackColor: Color(0xFF1DC379),
                    button: StartDeathRunSoloButton(
                      fontSize: 20,
                      width: 100,
                      height: 46,
                      color: Color(0xFF5DD39E),
                    )
                ),
                const SizedBox(height: 40,),
                MatchCard(
                    matchDetails: MatchDetails(
                        title: "First To 15",
                        mode: "Death Run",
                        type: "Practice",
                        topics: "Random"),
                    titleColor: Color(0xFFFFFFFF),
                    width: 336,
                    height: 151,
                    headerBackColor: Color(0xFF4F378A),
                    button: StartFirstToSoloButton(
                      fontSize: 20,
                      width: 100,
                      height: 46,
                      color: Color(0xFF7944FD),
                    )
                ),
                const SizedBox(height: 40,),
                MatchCard(
                    matchDetails: MatchDetails(
                        title: "5 in a Row",
                        mode: "Death Run",
                        type: "Practice",
                        topics: "Random"),
                    titleColor: Colors.black,
                    width: 336,
                    height: 151,
                    headerBackColor: Colors.amber,
                    button: StartInArowSoloButton(
                      fontSize: 20,
                      width: 100,
                      height: 46,
                      color: Colors.amber.shade100,
                    )
                ),
              ],
            )
          ],
        )
    );
  }
}