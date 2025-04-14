import 'package:flutter/material.dart';
import "package:fluter_prjcts/Firestore/Player/player.firestore.dart";
import "package:fluter_prjcts/Widgets/user_image.helper.dart";
import 'package:fluter_prjcts/Router/router.dart';
import 'package:fluter_prjcts/Models/player.dart';

class PlayerData {
  static Future<Map<String, dynamic>> fetchProfileData(String playerId) async {
    final player = await getPlayer(playerId);
    final avatar = await fetchProfileImage(player.id);
    return { "player": player, "avatar": avatar};
  }

  static Future<Map<String, dynamic>> fetchCurrentProfileData() async {
    final player = await getCurrentPlayer();
    if (player == null) {
      router.push("/sign-in");
      throw Exception("Not signed in.");
    }

    final avatar = await fetchProfileImage(player.id);
    return { "player": player, "avatar": avatar};
  }
}

class PlayerCredentialsWidget extends StatelessWidget {
  final Future<Map<String, dynamic>> callBack;

  const PlayerCredentialsWidget({super.key, required this.callBack});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future:  callBack,
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        else if (snapshot.hasData) {
          final player = snapshot.data!['player'];
          final avatar = snapshot.data!['avatar'];
          return _buildUserCredits(context, player: player, playerAva: avatar);
        }

        else {
          return Center(child: Text("No data found"));
        }
      },
    );
  }

  Widget _buildUserCredits( BuildContext context,
      {
        required Player player,
        required ImageProvider playerAva
      }
      ) {
    final String username = player.username;

    return Column(
      children: [
        Image(
          image: playerAva,
          width: 150,
          height: 150,
        ),

        const SizedBox(height: 10,),

        Text(
          username,
          style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold
          ),
        )
      ],
    );
  }
}