import 'package:fluter_prjcts/Actions/Buttons/play_button.dart';
import 'package:fluter_prjcts/Screens/loading_screen.dart';
import 'package:flutter/material.dart';
import '../Firestore/Player/player.firestore.dart';
import '../Firestore/Streak/streak.firestore.dart';
import '../Router/router.dart';
import '../Widgets/LeaderBoard/short_leaderboard.dart';
import "../Widgets/Other/streak_widget.dart";
import '../Widgets/Topics/recent_topics.dart';
import '../Widgets/Other/screen_title.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<int> _fetchStreak() async {
    final currPlayer = await getCurrentPlayer();
    if (currPlayer == null) {
      router.push("/sign-in");
      throw Exception("Sign In first");
    }
    return await getStreak(currPlayer.id);
  }

  Widget buildContent(BuildContext context, int streak) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 15),
            const ScreenTitle(title: "Quiz Luiz"),
            const SizedBox(height: 15),

            const StreakWidget(),

            const SizedBox(height: 20),

            const RecentTopicsWidget(),

            //LeaderBoard
            const SizedBox(height: 20),
            const LeaderboardWidget(),

            //Play Button
            const SizedBox(height: 30),
            Center(
              child: PlayButton(
                  text: "Play",
                  color: const Color(0xFF6E3DDA),
                  width: screenSize.width * 0.6,
                  height: 70
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
        future: _fetchStreak,
        builder: buildContent,
        loadingText: "Loading",
        backgroundColor: Theme.of(context).scaffoldBackgroundColor
    );
  }
}

