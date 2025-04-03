import 'package:fluter_prjcts/Actions/Buttons/play_button.dart';
import 'package:flutter/material.dart';
import '../Widgets/LeaderBoard/short_leaderboard.dart';
import "../Widgets/Other/streak_widget.dart";
import '../Widgets/Topics/recent_topics.dart';
import '../Widgets/Other/screen_title.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      children: [
        // 🔹 Title
        const SizedBox(height: 15),
        ScreenTitle(title: "QuizLuiz"),
        const SizedBox(height: 15),

        // 🔥 Days Streak Box
        StreakWidget(),

        const SizedBox(height: 10),

        //Recent Topics
        RecentTopicsWidget(),

        //LeaderBoard
        const SizedBox(height: 20),
        LeaderboardWidget(),

        //Play Button
        const SizedBox(height: 20),
        Center(child: PlayButton(text: "Play", color: Color(0xFF6E3DDA), width: 220, height: 70),
        ),
      ],
    );
  }
}

