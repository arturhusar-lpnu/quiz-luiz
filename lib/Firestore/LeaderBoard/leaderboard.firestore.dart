import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluter_prjcts/Models/ranked_player.dart';

Future<RankedPlayer> fetchRankedPlayer(String playerId) async {
  var playerList = await fetchRankedPlayers();

  return playerList.firstWhere((p) => p.playerId == playerId);
}

Future<List<RankedPlayer>> fetchRankedPlayers() async {
  final leaderboardSnapshot = await FirebaseFirestore.instance
      .collection('leaderboard')
      .orderBy('points', descending: true)
      .get();

  List<Map<String, dynamic>> leaderboardData = leaderboardSnapshot.docs.map((doc) {
    return {
      'playerId': doc['playerId'],
      'points': doc['points'] ?? 0,
    };
  }).toList();

  List<RankedPlayer> rankedPlayers = [];

  for (var entry in leaderboardData) {
    final playerSnapshot = await FirebaseFirestore.instance
        .collection('players')
        .doc(entry['playerId'])
        .get();

    final username = playerSnapshot.data()?['username'] ?? 'Unknown';

    rankedPlayers.add(RankedPlayer(
      playerId: entry['playerId'],
      username: username,
      points: entry['points'],
    ));
  }

  return _assignRanks(rankedPlayers);
}

List<RankedPlayer> _assignRanks(List<RankedPlayer> players) {
  players.sort((a, b) => b.points.compareTo(a.points));

  int currentRank = 1;
  int sameScoreCount = 1;

  for (int i = 0; i < players.length; i++) {
    if (i > 0 && players[i].points == players[i - 1].points) {
      players[i].rank = players[i - 1].rank;
      sameScoreCount++;
    } else {
      players[i].rank = currentRank;
      currentRank += sameScoreCount;
      sameScoreCount = 1;
    }
  }

  return players;
}

Future<void> addToLeaderBoard(String playerId) async{
  await FirebaseFirestore.instance.collection("leaderboard").add({
    "playerId" : playerId,
    "points" : 0,
  });
}
