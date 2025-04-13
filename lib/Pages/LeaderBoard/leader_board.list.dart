import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Models/ranked_player.dart';

import 'leader_board.card.dart';

class LeaderBoardList extends StatelessWidget {
  final List<RankedPlayer> rankedPlayers;

  const LeaderBoardList({
    super.key,
    required this.rankedPlayers,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: rankedPlayers.length,
      itemBuilder: (context, index) {
        final rankedPlayer = rankedPlayers[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: LeaderBoardCard(
            rankedPlayer: rankedPlayer,
            onCardTapped: () {
            },
          ),
        );
      },
    );
  }
}