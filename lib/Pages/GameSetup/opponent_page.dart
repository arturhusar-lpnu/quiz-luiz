import 'package:fluter_prjcts/Firestore/Player/player.firestore.dart';
import 'package:fluter_prjcts/Models/player.dart';
import 'package:fluter_prjcts/Screens/loading_screen.dart';
import 'package:flutter/material.dart';
import '../../Widgets/Cards/user_card.dart';

class OpponentPage extends StatefulWidget {
  final String? selectedOpponentId;
  final String userId;
  final Function(String) onSelectedOpponent;
  const OpponentPage({
    super.key,
    required this.onSelectedOpponent,
    required this.selectedOpponentId,
    required this.userId
  });

  @override
  OpponentPageState createState() => OpponentPageState();
}

class OpponentPageState extends State<OpponentPage> {
  late String selectedOpponentId;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    selectedOpponentId = widget.selectedOpponentId ?? "";
  }

  Future<Player> getOpponent(String opponentId) async{
    Player? player = await getPlayer(opponentId);
    if(player == null) {
      throw Exception("Opponent not found");
    }

    return player;
  }

  void _updateSelection(String userId) async {
    /// Only proceed if the user selection is different
    if (selectedOpponentId != userId) {
      String opponentId = "";

      try {
        Player user = await getOpponent(userId);
        opponentId = user.id;
      } catch (e) {
        opponentId = "";
      }

      setState(() {
        selectedOpponentId = opponentId;
      });

      widget.onSelectedOpponent(selectedOpponentId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF4D5061),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text("Select your opponent", style: TextStyle(color: Colors.amber, fontSize: 24)),
          const SizedBox(height: 20),
          if (selectedOpponentId.isNotEmpty)
            FutureBuilder<Player>(
              future: getOpponent(selectedOpponentId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(
                    "Loading opponent...",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  );
                } else if (snapshot.hasError) {
                  return const Text(
                    "Error loading opponent",
                    style: TextStyle(color: Colors.red, fontSize: 20),
                    textAlign: TextAlign.center,
                  );
                } else if (snapshot.hasData) {
                  return Text(
                    "Selected ${snapshot.data!.username} for a clash.",
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  );
                } else {
                  return const SizedBox(); // Empty widget if no data
                }
              },
            ),
          const SizedBox(height: 10),
          // Search Bar
          SearchBar(
            leading: const Icon(Icons.search),
            hintText: "Search user...",
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 10),

          // Topics List
          Expanded(
            child: LoadingScreen<List<Player>>(
              backgroundColor: Color(0xFF4D5061),
              loadingText: "Eeny, meeny, miney moe...",
                future: getAllPlayers,
                builder: (context, players) {
                  List<Player> filteredPlayers = players.where((player) {
                    return player.username.toLowerCase().contains(searchQuery.toLowerCase());
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredPlayers.length,
                    itemBuilder: (context, index) {
                      Player player = filteredPlayers[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: PlayerCard(
                          headerWidth: 80,
                          player: player,
                          userId: widget.userId,
                          mainColor: Color(0xFF7173FF),
                          usernameStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          onInviteTapped: () => _updateSelection(player.id),
                          selectedOpponentId: selectedOpponentId,
                        ),
                      );
                    },
                  );
                },
            ),
          ),
        ],
      ),
    );
  }
}
