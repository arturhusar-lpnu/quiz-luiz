import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluter_prjcts/Models/answer.dart';
import 'package:fluter_prjcts/Models/move.dart';

Future<void> makeMove(String gameId, String playerId, String questionId, String answerId) async {
  var db = FirebaseFirestore.instance;

  final answerRef = await db.collection("answers").doc(answerId).get();

  final answer = answerRef.data() as Answer;

  await FirebaseFirestore.instance.collection("moves").add({
    "gameId": gameId,
    "playerId" : playerId,
    "questionId": questionId,
    "isCorrect" : answer.isCorrect,
  });
}

Future<Move?> getMove(String gameId, String playerId, String questionId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection("moves")
      .where("gameId", isEqualTo: gameId)
      .where("playerId", isEqualTo: playerId)
      .where("questionId", isEqualTo: questionId)
      .limit(1)
      .get();

  if(snapshot.docs.isEmpty) return null;

  final doc = snapshot.docs.first;

  return Move.fromFirestore(doc);
}
