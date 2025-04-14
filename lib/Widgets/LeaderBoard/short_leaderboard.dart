import 'package:fluter_prjcts/Blocs/LeaderboardBLoC/leaderboard_bloc.dart';
import 'package:fluter_prjcts/Firestore/Player/current_player.dart';
import 'package:fluter_prjcts/Models/ranked_player.dart';
import 'package:fluter_prjcts/Widgets/PopUp/error.popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './leaderboard_entry.dart';

class LeaderboardWidget extends StatefulWidget {
  const LeaderboardWidget({super.key});

  @override
  State<StatefulWidget> createState() => _LeaderBoardState();
}


class _LeaderBoardState extends State<LeaderboardWidget> {
  late LeaderBoardBloc lbBloc;

  @override
  void initState() {
    super.initState();
    lbBloc = LeaderBoardBloc();
    lbBloc.add(SubscribeLeaderBoardEvent());
  }

  @override
  void dispose() {
    lbBloc.close();
    super.dispose();
  }


  Widget _buildPlayersList(BuildContext context, List<RankedPlayer> players) {
    return ListView.separated(
        itemBuilder: (context, index) {
          final p = players[index];
          return LeaderboardEntry(rank: p.rank, name: "You", points: p.points, color: Color(0xFFE0BF37),);
        },
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemCount: players.length
    );
  }

  (List<RankedPlayer>, RankedPlayer, List<RankedPlayer>) fetchData(List<RankedPlayer> players) {
    List<RankedPlayer> top = [];

    if(players.length >= 3) {
      top.add(players[0]);
      top.add(players[1]);
      top.add(players[2]);
    }

    final currentPlayer = players.where((pl) => pl.playerId == CurrentPlayer.player!.id).first;

    players.removeWhere((pl) => pl.playerId == currentPlayer.playerId);

    return ( top, currentPlayer, players );
  }


  Widget buildContent(BuildContext context, List<RankedPlayer> players) {
    final data = fetchData(players);
    final topPlayers = data.$1;
    final currentPlayer = data.$2;
    final allPlayers = data.$3;

    return Column(
      children: [
        // 🏆 Leaderboard Section Title
        Center(
          child: const Text(
            "LeaderBoard",
            style: TextStyle(fontSize: 24, color: Colors.amber),
          ),
        ),

        // 🏆 Leaderboard Container
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF3A3D4D),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(topPlayers.isNotEmpty)
                TopListWidget(context: context, players: topPlayers),
              if(topPlayers.isEmpty)
                _buildPlayersList(context, allPlayers),

              const SizedBox(height: 20),

              LeaderboardEntry(rank: currentPlayer.rank, name: "You", points: currentPlayer.points, color: Color(0xFFE0BF37),),
            ],
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: lbBloc,
        child: BlocBuilder<LeaderBoardBloc, LeaderBoardState>(
            builder: (context, state) {
              if(state is LeaderBoardLoadSuccess) {
                return buildContent(context, state.rankedPlayers);
              } else if(state is LeaderBoardLoadFailure) {
                showErrorDialog(
                    context: context,
                    title: "Api Error",
                    message: state.errorMessage,
                    icon: Icons.error_outlined,
                    onRetry: () {}
                );
                return const SizedBox();
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

class TopListWidget extends StatelessWidget {
  const TopListWidget({
    super.key,
    required this.context,
    required this.players,
  });

  final BuildContext context;
  final List<RankedPlayer> players;

  @override
  Widget build(BuildContext context) {
    RankedPlayer firstPlayer = players.first;
    RankedPlayer secondPlayer = players[1];
    RankedPlayer thirdPlayer = players[2];
    return Column(
      children: [
        LeaderBoardAvatarWidget(player: firstPlayer, borderColor: Colors.yellow, size: 20),
        const SizedBox(height: 10),

        // Second & Third Place
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LeaderBoardAvatarWidget(player: secondPlayer, borderColor: Colors.grey, size: 15),
            const SizedBox(width: 40), // Space between avatars
            LeaderBoardAvatarWidget(player: thirdPlayer, borderColor: Colors.redAccent, size: 15),
          ],
        ),
      ],
    );
  }
}

class LeaderBoardAvatarWidget extends StatelessWidget {
  const LeaderBoardAvatarWidget({
    super.key,
    required this.player,
    required this.borderColor,
    required this.size,
  });

  final RankedPlayer player;
  final Color borderColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    String pointsMessage = "${player.username} \t ${player.points} "
        "${player.points == 1 ? 'pt' : 'pts'}";
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 3),
          ),
          padding: const EdgeInsets.all(4), // Space for border
          child: CircleAvatar(
            radius: size,
            backgroundColor: Colors.black,
            child: Icon(Icons.person, size: size),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          pointsMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}