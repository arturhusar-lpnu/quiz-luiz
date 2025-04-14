import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Widgets/Cards/match_history_card.dart';
import 'package:fluter_prjcts/Models/match_history_details.dart';

class MatchHistoryShort extends StatelessWidget{
  const MatchHistoryShort({super.key});

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
            Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Match History", style: TextStyle(fontSize: 24, color: Colors.amber)),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.more_horiz, color: Colors.white,),
                )
              ],
            ),

            const SizedBox(height: 20,),
            Center(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    const SizedBox(width: 20),
                    MatchHistoryCard(
                      headerBackColor: Color(0xFF1DC379),
                      matchDetails: MatchHistoryDetails(
                        result: MatchResult.Win,
                        type: "Random",
                        topics: "Random",
                      ),
                      width: 150,
                      height: 140,
                    ),
                    const SizedBox(width: 10),
                    MatchHistoryCard(
                      headerBackColor: Color(0xFF1DC379),
                      matchDetails: MatchHistoryDetails(
                        result: MatchResult.Draw,
                        type: "Ranked",
                        topics: "Random",
                      ),
                      width: 150,
                      height: 140,
                    ),
                  ],
                )
            )

          ],
        )
    );
  }
}