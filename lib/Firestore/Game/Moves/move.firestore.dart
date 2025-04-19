import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluter_prjcts/Models/answer.dart';
import 'package:fluter_prjcts/Models/move.dart';

Future<void> makeMove(String gameId, String playerId, String questionId, String answerId) async {
  var db = FirebaseFirestore.instance;

  final answerRef = await db.collection("answers").doc(answerId).get();

  final answer = Answer.fromFirestore(answerRef);

  await FirebaseFirestore.instance.collection("moves").add({
    "gameId": gameId,
    "playerId" : playerId,
    "questionId": questionId,
    'answerId' : answerId,
    "isCorrect" : answer.isCorrect,
  });
}

Future<List<Move>> getQuestionMoves(String gameId, String playerId, String questionId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection("moves")
      .where("gameId", isEqualTo: gameId)
      .where("playerId", isEqualTo: playerId)
      .where("questionId", isEqualTo: questionId)
      .get();

  if(snapshot.docs.isEmpty) throw Exception("Cant find the move");

  List<Move> moves = [];
  for(final doc in snapshot.docs) {
    moves.add(Move.fromFirestore(doc));
  }
  return moves;
}
