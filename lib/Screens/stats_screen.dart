import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluter_prjcts/Blocs/LeaderboardBLoC/leaderboard_bloc.dart';
import 'package:fluter_prjcts/Firestore/LeaderBoard/leaderboard.firestore.dart';
import 'package:fluter_prjcts/Pages/LeaderBoard/leader_board.list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Actions/Buttons/back_button.dart';
import '../Widgets/Other/screen_title.dart';
import '../Widgets/PopUp/error.popup.dart';

class StatsScreen extends StatelessWidget {
  final LeaderBoardRepository leaderRepo;
  final LeaderBoardBloc? _testBloc;
  StatsScreen({super.key, LeaderBoardRepository? injectRepo, LeaderBoardBloc? testBloc}) : leaderRepo = injectRepo ?? LeaderBoardRepository(firestore: FirebaseFirestore.instance), _testBloc = testBloc;

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
                          BlocProvider<LeaderBoardBloc>(
                            create: (_) => _testBloc ?? LeaderBoardBloc(leaderRepo: leaderRepo)..add(SubscribeLeaderBoardEvent()),
                            child: LeaderBoardWidget(injectedRepo: leaderRepo),
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

class LeaderBoardWidget extends StatelessWidget {
  final LeaderBoardRepository injectedRepo;

  const LeaderBoardWidget({super.key, required this.injectedRepo});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaderBoardBloc, LeaderBoardState>(
      builder: (context, state) {
        if (state is LeaderBoardLoadSuccess) {
          return LeaderBoardList(rankedPlayers: state.rankedPlayers);
        } else if (state is LeaderBoardLoadFailure) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showErrorDialog(
              context: context,
              icon: Icons.error_outlined,
              title: 'Api Error',
              message: state.errorMessage,
              onRetry: () {},
            );
          });
          return const SizedBox(height: 0);
        } else if (state is LeaderBoardLoading) {
          return const Column(
            children: [
              Center(child: Text("Loading...")),
              CircularProgressIndicator(),
            ],
          );
        }
        return const SizedBox(height: 0);

      },
    );
  }
}