import 'package:fluter_prjcts/Models/user.dart';
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

  Future<List<User>> getAllUsers() async{ // TODO fetch from Firebase
    await Future.delayed(Duration(seconds: 2));
    return [
      User(id: "user-id-1", username: "Halla Jordan"),
      User(id: "user-id-2", username: "Yussuf Khan"),
      User(id: "user-id-3", username: "Hall Jordan"),
    ];
  }

  Future<User> getUser(String userId) async{
      List<User> users = await getAllUsers();
      return users.where((user) {
         return user.id == userId;
      }).first;
  }

  void _updateSelection(String userId) async {
    /// Only proceed if the user selection is different
    if (selectedOpponentId != userId) {
      String opponentId = "";

      try {
        User user = await getUser(userId);
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
            FutureBuilder<User>(
              future: getUser(selectedOpponentId),
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
            child: LoadingScreen<List<User>>(
                future: getAllUsers,
                builder: (context, users) {
                  List<User> filteredUsers = users.where((user) {
                    return user.username.toLowerCase().contains(searchQuery.toLowerCase());
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: UserCard(
                          headerWidth: 80,
                          user: user,
                          userId: widget.userId,
                          mainColor: Color(0xFF7173FF),
                          usernameStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          onInviteTapped: () => _updateSelection(user.id),
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
