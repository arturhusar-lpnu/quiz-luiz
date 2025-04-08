import 'package:cloud_firestore/cloud_firestore.dart';

enum GameStatus { inProgress, ended}

Future<void> updatePlayerData(String gameId, String playerId, {int? score, int? fails}) async {
  try {
    final updates = <String, dynamic>{};

    if (score != null) updates['players.$playerId.score'] = score;
    if (fails != null) updates['players.$playerId.fails'] = fails;

    if (updates.isEmpty) return;

    await FirebaseFirestore.instance.collection("death-runs").doc(gameId).update(updates);
  } catch (e) {
    throw Exception(e);
  }
}