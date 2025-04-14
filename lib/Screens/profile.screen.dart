import "package:firebase_auth/firebase_auth.dart";
import "package:fluter_prjcts/Actions/Buttons/action_button.dart";
import "package:fluter_prjcts/Models/ranked_player.dart";
import "package:fluter_prjcts/Pages/Profile/friends.list.dart";
import "package:fluter_prjcts/Screens/loading_screen.dart";
import "package:fluter_prjcts/Widgets/Other/screen_title.dart";
import "package:flutter/material.dart";
import "package:fluter_prjcts/Models/player.dart";
import "package:fluter_prjcts/Firestore/Player/player.firestore.dart";
import "package:fluter_prjcts/Router/router.dart";

import "../Firestore/LeaderBoard/leaderboard.firestore.dart";
import "../Firestore/Streak/streak.firestore.dart";
import "../Firestore/Topic/topic.firestore.dart";
import "../Pages/Profile/player_profile_data.dart";

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<Player> _getCurrentPlayer() async {
    final currPlayer = await getCurrentPlayer();

    if(currPlayer == null) {
      router.push("/sign-in");
      throw Exception("Sign in first");
    }

    return currPlayer;
  }
  //
  // void _addFriend() {
  //   router.pushNamed("/add-friend");
  // }

  Future<Map<String, dynamic>> fetchData() async{
    try {
      Map<String, dynamic> data = {};
      Player? currentPlayer = await _getCurrentPlayer();
      ///Current Player info
      data["current-player"] = currentPlayer;

      ///Player streak record
      final int streakDays = await getStreak(currentPlayer.id);
      data["streak"] = streakDays;

      ///Player ranked records
      final RankedPlayer rankedPlayer = await fetchRankedPlayer(currentPlayer.id);
      data["ranked-player"] = rankedPlayer;

      /// Lists of all and solved topics
      var totalTopics = await getTopics();
      var solvedTopics = await getSolvedTopics(currentPlayer.id);

      data['topics'] = { "all-topics" : totalTopics.length, "solved-topics": solvedTopics.length };

      return data;
    } catch(e) {
      throw Exception(e);
    }
  }

  Widget _buildStreak(BuildContext context, int days) {
    final hasStreak = days > 0;
    final String streakMessage = hasStreak ? "$days day${days == 1 ? "" : "s"} streak" : "Keep it up";
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white10,
        border: Border.all(
          width: 0,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Icon(
              Icons.local_fire_department_rounded,
              color: hasStreak ? Colors.orange : Colors.white24,
              size: 32,
            ),
          ),

          const SizedBox(height: 20),
          Text(
            streakMessage,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16
            ),
            textAlign: TextAlign.center,
          ),
        ],
      )
    );
  }

  Widget _buildRank(BuildContext context, RankedPlayer rp) {
    final rank = rp.rank;
    final points = rp.points;

    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white10,
          border: Border.all(
            width: 0,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Rank : $rank",
              style: TextStyle(
                color: Colors.amber,
                fontSize: 20
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              "$points Points",
              style: TextStyle(
                 color: Colors.white,
                 fontSize: 16
              ),
              textAlign: TextAlign.center,
            ),
          ],
        )
    );
  }

  Widget _buildTopics(BuildContext context, { required int solved, required int allTopics}) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white10,
          border: Border.all(
            width: 0,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
                "$solved / $allTopics",
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 20
                ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
                "Topics solved",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),
              textAlign: TextAlign.center,
            ),
          ],
        )
    );
  }

  Widget _buildContent(BuildContext context, data) {
    final currentPlayer = data['current-player'] as Player; ///
    final int streakDays = data['streak'] as int; ///
    final rankData = data['ranked-player'] as RankedPlayer; ///
    final topicsData = data['topics'];
    final allTopicsCount = topicsData["all-topics"] as int;
    final solvedTopicsCount = topicsData["solved-topics"] as int;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const ScreenTitle(title: "Profile"),
                    const SizedBox(height: 20),
                    PlayerCredentialsWidget(
                      callBack: PlayerData.fetchCurrentProfileData(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStreak(context, streakDays),
                        _buildRank(context, rankData),
                        _buildTopics(context,
                          solved: solvedTopicsCount,
                          allTopics: allTopicsCount,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Friends",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 200, // Fixed height for friends list
                        child: FriendListWidget(playerId: currentPlayer.id),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: ActionButton(
                      text: "Logout",
                      onPressed: () async{
                        await FirebaseAuth.instance.signOut();
                        router.go("/sign-in");
                      },
                      color: const Color(0xFF6E3DDA),
                      width: 170,
                      height: 65
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
        future: fetchData,
        builder: _buildContent,
        loadingText: "Loading...",
        backgroundColor: Theme.of(context).scaffoldBackgroundColor
    );
  }
}