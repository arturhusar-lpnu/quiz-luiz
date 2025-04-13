import 'package:fluter_prjcts/Pages/LeaderBoard/leader_board.list.dart';
import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Screens/loading_screen.dart';
import 'package:fluter_prjcts/Models/ranked_player.dart';
import '../Actions/Buttons/back_button.dart';
import '../Firestore/LeaderBoard/leaderboard.firestore.dart';
import '../Widgets/Other/screen_title.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  Future<List<RankedPlayer>> fetchTopics() async {
    return await fetchRankedPlayers();
  }

  Widget _buildLeaderBoardList(BuildContext context, List<RankedPlayer> rankedPlayers) {

    return LeaderBoardList(
      rankedPlayers: rankedPlayers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: ReturnBackButton(iconColor: Colors.amber),
                ),
                Center(child: ScreenTitle(title: "Statistics")),
              ],
            ),
            const SizedBox(height: 20),

            /// Tab Controller
            DefaultTabController(
              length: 2,
              child: Expanded(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFF4d5061),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: TabBar(
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white70,
                        labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontSize: 18,
                        ),
                        indicator: BoxDecoration(
                          color: Color(0xFF7173ff),
                        ),
                        tabs: [
                          Tab(text: 'Leaderboard'),
                          Tab(text: 'Match history'),
                        ],
                      ),
                    ),

                    /// TabBarView - Вміст кожної вкладки
                    Expanded(
                      child: TabBarView(
                        children: [
                          /// TAB 1: Leaderboard
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Color(0xFF4d5061),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            child: LoadingScreen(
                              future: fetchTopics,
                              builder: _buildLeaderBoardList,
                              loadingText: "Almost there",
                              backgroundColor: Color(0xFF4d5061),
                            ),
                          ),

                          /// TAB 2: Match History
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF4d5061),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Match history',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}