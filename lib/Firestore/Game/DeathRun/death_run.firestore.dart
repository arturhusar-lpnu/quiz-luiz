import 'package:cloud_firestore/cloud_firestore.dart';

enum GameStatus { inProgress, ended}

Future<void> addNewDeathRunGame(String gameId, String player1Id, String player2Id) async{
  try{
    await FirebaseFirestore.instance.collection("death-runs").doc(gameId).set({
      "players" : {
        player1Id: {
          "fails": 0,
          "score": 0,
        },
        player2Id: {
          "fails": 0,
          "score": 0,
        }
      },
      "status" : "inProgress",
      "currentQuestion" : "",
      "winner" : null,
    });

  } on FirebaseException catch (e) {
    print(e.message);
  }
}

Future<Map<String, dynamic>?> getDeathRunGame(String gameId) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection("death-runs")
        .doc(gameId)
        .get();

    if (!snapshot.exists) return null;

    return snapshot.data();
  } on Exception catch (e) {
    print(e);
    return null;
  }
}


Future<void> updateCurrentQuestion(String gameId, String questionId) async {
  try{
    await FirebaseFirestore.instance.collection("death-runs").doc(gameId).update({
      "currentQuestion" : questionId,
    });
  } on FirebaseException catch (e) {
    print(e.message);
  }
}

Future<void> updateStatus(String gameId, GameStatus status) async {
  try{
    await FirebaseFirestore.instance.collection("death-runs").doc(gameId).update({
      "status" : status.name,
    });
  } on FirebaseException catch (e) {
    print(e.message);
  }
}

Future<void> updatePlayerData(String gameId, String playerId, {int? score, int? fails}) async {
  try {
    final updates = <String, dynamic>{};

    if (score != null) updates['players.$playerId.score'] = score;
    if (fails != null) updates['players.$playerId.fails'] = fails;

    if (updates.isEmpty) return;

    await FirebaseFirestore.instance.collection("death-runs").doc(gameId).update(updates);
  } on FirebaseException catch (e) {
    print(e.message);
  }
}


Future<void> setWinner(String gameId, String playerId) async {
  try {
    await FirebaseFirestore.instance.collection("death-runs").doc(gameId).update({
      "winner": playerId,
    });
  } on FirebaseException catch (e) {
    print(e.message);
  }
}

Future<List<String>> getPlayerIdsFromDeathRun(String gameId) async {
  try {
    final docSnapshot = await FirebaseFirestore.instance
        .collection("death-runs")
        .doc(gameId)
        .get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      final playersMap = data?['players'] as Map<String, dynamic>;
      return playersMap.keys.toList(); // List of player IDs
    } else {
      throw Exception("Game not found");
    }
  } on FirebaseException catch (e) {
    print("Error fetching players: ${e.message}");
    return [];
  }
}