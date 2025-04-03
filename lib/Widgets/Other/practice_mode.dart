import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Widgets/Cards/match_card.dart';
import 'package:fluter_prjcts/Models/match_details.dart';
import 'package:fluter_prjcts/Actions/Buttons/practice_mode_buttons.dart';

class PracticeMode extends StatelessWidget{
  const PracticeMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF3A3D4D),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const Text("Practice", style: TextStyle(fontSize: 24, color: Colors.amber)),
            const SizedBox(height: 20,),
            Column(
              children: [
                MatchCard(
                    matchDetails: MatchDetails(
                        title: "Match with AI",
                        mode: "Death Run",
                        type: "Random",
                        topics: "Random"),
                    width: 336,
                    height: 151,
                    headerBackColor: Color(0xFF1DC379),
                    button: StartMatchWithAiButton(
                      text: "Start",
                      fontSize: 24,
                      width: 120,
                      height: 46,
                      color: Color(0xFF5DD39E),
                    )
                ),
                const SizedBox(height: 40,),
                MatchCard(
                    matchDetails: MatchDetails(
                        title: "Rerun Mistakes",
                        mode: "Death Run",
                        type: "Random",
                        topics: "Random"),
                    titleColor: Color(0xFFFFFFFF),
                    width: 336,
                    height: 151,
                    headerBackColor: Color(0xFF4F378A),
                    button: RerunMistakesButton(
                      text: "Start",
                      fontSize: 24,
                      width: 120,
                      height: 46,
                      color: Color(0xFFCFB9FF),
                    )
                ),
              ],
            )
          ],
        )
    );
  }
}