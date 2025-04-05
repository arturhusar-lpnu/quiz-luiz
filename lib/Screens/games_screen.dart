import 'package:fluter_prjcts/Widgets/Other/match_history_short.dart';
import 'package:fluter_prjcts/Widgets/Other/practice_mode.dart';
import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Widgets/Other/screen_title.dart';

import 'package:fluter_prjcts/Widgets/Other/new_game_modes.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      children: [
        /// Title
        const SizedBox(height: 15),
        ScreenTitle(title: "QuizLuiz"),
        const SizedBox(height: 25),


        /// New Game Container Buttons
        NewGameModes(),

        const SizedBox(height: 20),
        /// Practice Container
        PracticeMode(),

        /// Match History
        const SizedBox(height: 20),
        MatchHistoryShort(),
      ],
    );
  }
}