import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluter_prjcts/Models/answer.dart';
import 'package:fluter_prjcts/Models/move.dart';

class MoveRepository {
  final FirebaseFirestore firestore;

  MoveRepository({required this.firestore});


  Future<void> makeMove(String gameId, String playerId, String questionId, String answerId) async {
    final answerRef = await firestore.collection("answers").doc(answerId).get();

    final answer = Answer.fromFirestore(answerRef);

    await firestore.collection("moves").add({
      "gameId": gameId,
      "playerId" : playerId,
      "questionId": questionId,
      'answerId' : answerId,
      "isCorrect" : answer.isCorrect,
    });
  }

  Future<List<Move>> getQuestionMoves(String gameId, String playerId, String questionId) async {
    final snapshot = await firestore
        .collection("moves")
        .where("gameId", isEqualTo: gameId)
        .where("playerId", isEqualTo: playerId)
        .where("questionId", isEqualTo: questionId)
        .get();

    if(snapshot.docs.isEmpty) return [ ];

    List<Move> moves = [];
    for(final doc in snapshot.docs) {
      moves.add(Move.fromFirestore(doc));
    }
    return moves;
  }
}