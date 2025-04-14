import 'package:fluter_prjcts/Blocs/LeaderboardBLoC/leaderboard_bloc.dart';
import 'package:fluter_prjcts/Pages/LeaderBoard/leader_board.list.dart';
import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Models/ranked_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Actions/Buttons/back_button.dart';
import '../Widgets/Other/screen_title.dart';
import '../Widgets/PopUp/error.popup.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

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
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          )
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: [
                          Tab(text: 'Leaderboard'),
                          Tab(text: 'Match history'),
                        ],
                      ),
                    ),

                    /// TabBarView
                    Expanded(
                      child: TabBarView(
                        children: [
                          /// TAB 1: Leaderboard
                          LeaderBoardWidget(),

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

class LeaderBoardWidget extends StatefulWidget {
  const LeaderBoardWidget({super.key});

  @override
  State<StatefulWidget> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoardWidget> {
  late LeaderBoardBloc lbBloc;

  @override
  void initState() {
    super.initState();
    lbBloc = LeaderBoardBloc();
    lbBloc.add(SubscribeLeaderBoardEvent());
  }

  Widget _buildLeaderBoardList(BuildContext context, List<RankedPlayer> rankedPlayers) {
    return LeaderBoardList(
      rankedPlayers: rankedPlayers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: lbBloc,
      child: BlocBuilder<LeaderBoardBloc, LeaderBoardState> (
          builder: (context, state) {
            if(state is LeaderBoardLoadSuccess) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Color(0xFF4d5061),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: _buildLeaderBoardList(
                    context,
                    state.rankedPlayers
                ),
              );
            } else if(state is LeaderBoardLoadFailure) {
              showErrorDialog(
                context: context,
                icon: Icons.error_outlined, title: 'Api Error',
                message: state.errorMessage,
                onRetry: () {  },
              );
              return SizedBox(height: 0);
            }
            return Column(
              children: [
                const Center(
                    child: Text(
                        "Loading...")
                ),
                CircularProgressIndicator()
              ],
            );
          }
      ),
    );
  }
}